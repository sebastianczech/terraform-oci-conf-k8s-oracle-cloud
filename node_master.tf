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
  provisioner "remote-exec" { inline = ["sudo shutdown -r now"] }

}