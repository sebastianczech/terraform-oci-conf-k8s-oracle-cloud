output "master_public_ip" {
  description = "The public IP address of the master node"
  value       = local.master_public_ip
}

output "microk8s_config_private" {
  description = "The private configuration for microk8s"
  value       = data.external.microk8s_config.result.configuration
}

output "microk8s_config_public" {
  description = "The public configuration for microk8s"
  value       = local.microk8s_config_public
}
