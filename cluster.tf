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
    always_run = "${timestamp()}"
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
    always_run = "${timestamp()}"
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