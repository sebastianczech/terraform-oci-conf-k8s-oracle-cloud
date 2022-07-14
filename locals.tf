locals {
  master_private_ip       = var.compute_instances.private_ip[0]
  master_public_ip        = var.compute_instances.public_ip[0]
  lb_public_ip            = data.oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.ip_addresses[0].ip_address
  microk8s_config_private = data.external.microk8s_config.result.configuration
  microk8s_config_public  = replace(local.microk8s_config_private, local.master_private_ip, local.lb_public_ip)
}