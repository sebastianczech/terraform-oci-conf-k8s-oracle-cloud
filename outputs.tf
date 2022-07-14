output "master_public_ip" {
  value = local.master_public_ip
}

output "microk8s_config_private" {
  value = data.external.microk8s_config.result.configuration
}

output "microk8s_config_public" {
  value = local.microk8s_config_public
}
