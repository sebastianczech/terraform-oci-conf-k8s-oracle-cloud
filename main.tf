################################################################################
# Cluster
################################################################################

locals {
  master_private_ip       = var.compute_instances.private_ip[0]
  master_public_ip        = var.compute_instances.public_ip[0]
  lb_public_ip            = data.oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.ip_addresses[0].ip_address
  microk8s_config_private = data.external.microk8s_config.result.configuration
  microk8s_config_public  = replace(local.microk8s_config_private, local.master_private_ip, local.lb_public_ip)
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [
    null_resource.master_setup,
    null_resource.worker_setup
  ]

  ### uncomment to always execute
  # triggers = {
  #   always_run = "${timestamp()}"
  # }

  ### change to lower value, if nodes are not restarted
  create_duration = "60s"
}

resource "null_resource" "k8s_cluster_setup" {
  count = length(var.compute_instances.public_ip) > 1 ? length(var.compute_instances.public_ip) - 1 : 0

  depends_on = [
    time_sleep.wait_60_seconds
  ]

  triggers = {
    public_ip  = var.compute_instances.public_ip[0]
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = self.triggers.public_ip
    user        = "ubuntu"
    private_key = var.id_rsa
    timeout     = "30s"
  }

  provisioner "remote-exec" { inline = ["echo 'Starting adding node ${var.compute_instances.name[count.index + 1]} to cluster, where master is node with IP ${self.triggers.public_ip}'"] }

  provisioner "file" {
    content = templatefile("${path.module}/scripts/microk8s_join_token.sh", {
      node_name = var.compute_instances.name[count.index + 1]
    })

    destination = "/tmp/join_${var.compute_instances.name[count.index + 1]}.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/join_${var.compute_instances.name[count.index + 1]}.sh",
      "/tmp/join_${var.compute_instances.name[count.index + 1]}.sh",
    ]
  }
}

data "remote_file" "join_command_token" {
  count = length(var.compute_instances.public_ip) > 1 ? length(var.compute_instances.public_ip) - 1 : 0

  depends_on = [
    null_resource.k8s_cluster_setup
  ]

  conn {
    host        = var.compute_instances.public_ip[0]
    user        = "ubuntu"
    private_key = var.id_rsa
  }

  path = "/tmp/join_${var.compute_instances.name[count.index + 1]}.command"
}

resource "null_resource" "k8s_cluster_join" {
  count = length(var.compute_instances.public_ip) > 1 ? length(var.compute_instances.public_ip) - 1 : 0

  triggers = {
    public_ip  = var.compute_instances.public_ip[count.index + 1]
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = self.triggers.public_ip
    user        = "ubuntu"
    private_key = var.id_rsa
    timeout     = "30s"
  }

  provisioner "file" {
    content     = data.remote_file.join_command_token[count.index].content
    destination = "/tmp/join-token.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/join-token.sh",
      "/tmp/join-token.sh",
    ]
  }
}

data "external" "microk8s_config" {
  depends_on = [
    null_resource.k8s_cluster_join
  ]

  program = ["python3", "${path.module}/scripts/microk8s_cluster.py"]

  query = {
    master_public_ip = var.compute_instances.public_ip[0]
    private_key      = var.id_rsa
  }
}

################################################################################
# Node master
################################################################################

data "oci_network_load_balancer_network_load_balancer" "k8s_network_load_balancer" {
  network_load_balancer_id = var.lb_id
}

resource "null_resource" "master_setup" {
  triggers = {
    public_ip = var.compute_instances.public_ip[0]
    ### uncomment to always execute
    # always_run = "${timestamp()}"
  }

  connection {
    type        = "ssh"
    host        = self.triggers.public_ip
    user        = "ubuntu"
    private_key = var.id_rsa
    timeout     = "30s"
  }

  provisioner "remote-exec" { inline = ["echo 'Running worker init script on master node with IP ${self.triggers.public_ip}'"] }

  provisioner "remote-exec" { inline = [file("${path.module}/scripts/install.sh")] }

  provisioner "remote-exec" { inline = [file("${path.module}/scripts/upgrade.sh")] }

  provisioner "file" {
    content = templatefile("${path.module}/files/rules.v4", {
      my_public_ip = var.my_public_ip
      subnet_cidr  = var.subnet_cidr
    })
    destination = "/tmp/rules.v4"
  }

  provisioner "remote-exec" { inline = ["sudo cp /tmp/rules.v4 /etc/iptables/rules.v4"] }

  provisioner "file" {
    content = templatefile("${path.module}/files/csr.conf.template", {
      node_public_ip  = var.compute_instances.public_ip[0]
      node_private_ip = var.compute_instances.private_ip[0]
      lb_public_ip    = data.oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.ip_addresses[0].ip_address
    })
    destination = "/tmp/csr.conf.template"
  }

  provisioner "remote-exec" { inline = ["sudo cp /tmp/csr.conf.template /var/snap/microk8s/current/certs/csr.conf.template"] }

  provisioner "remote-exec" { inline = ["sudo microk8s refresh-certs --cert ca.crt --cert server.crt --cert front-proxy-client.crt"] }

  provisioner "remote-exec" { inline = ["sudo usermod -a -G microk8s ubuntu"] }

  ### comment if you dont want to reboot machine
  # provisioner "remote-exec" { inline = ["sudo shutdown -r now"] }

}

################################################################################
# Node worker
################################################################################

resource "null_resource" "worker_setup" {
  count = length(var.compute_instances.public_ip) > 1 ? length(var.compute_instances.public_ip) - 1 : 0

  triggers = {
    public_ip = var.compute_instances.public_ip[count.index + 1]
    ### uncomment to always execute
    # always_run = "${timestamp()}"
  }

  connection {
    type        = "ssh"
    host        = self.triggers.public_ip
    user        = "ubuntu"
    private_key = var.id_rsa
    timeout     = "30s"
  }

  provisioner "remote-exec" { inline = ["echo 'Running worker init script on worker node ${count.index} with IP ${self.triggers.public_ip}'"] }

  provisioner "remote-exec" { inline = [file("${path.module}/scripts/install.sh")] }

  provisioner "remote-exec" { inline = [file("${path.module}/scripts/upgrade.sh")] }

  provisioner "file" {
    content = templatefile("${path.module}/files/rules.v4", {
      my_public_ip = var.my_public_ip
      subnet_cidr  = var.subnet_cidr
    })
    destination = "/tmp/rules.v4"
  }

  provisioner "remote-exec" { inline = ["sudo cp /tmp/rules.v4 /etc/iptables/rules.v4"] }

  provisioner "file" {
    content = templatefile("${path.module}/files/csr.conf.template", {
      node_public_ip  = var.compute_instances.public_ip[count.index + 1]
      node_private_ip = var.compute_instances.private_ip[count.index + 1]
      lb_public_ip    = data.oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.ip_addresses[0].ip_address
    })
    destination = "/tmp/csr.conf.template"
  }

  provisioner "remote-exec" { inline = ["sudo cp /tmp/csr.conf.template /var/snap/microk8s/current/certs/csr.conf.template"] }

  provisioner "remote-exec" { inline = ["sudo microk8s refresh-certs --cert ca.crt --cert server.crt --cert front-proxy-client.crt"] }

  provisioner "remote-exec" { inline = ["sudo usermod -a -G microk8s ubuntu"] }

  ### comment if you dont want to reboot machine
  # provisioner "remote-exec" { inline = ["sudo shutdown -r now"] }

}
