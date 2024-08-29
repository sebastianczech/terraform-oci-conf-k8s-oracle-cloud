output "availability_domain" {
  description = "availability domain"
  value       = module.infra_k8s_oracle_cloud.availability_domain
}

# output "vcn_state" {
#   description = "the state of the VCN"
#   value       = module.infra_k8s_oracle_cloud.vcn_state
# }

output "vcn_cidr" {
  description = "CIDR block of the core VCN"
  value       = module.infra_k8s_oracle_cloud.vcn_cidr
}

# output "vcn_id" {
#   description = "ID of the core VCN"
#   value       = module.infra_k8s_oracle_cloud.vcn_id
# }

# output "subnet_state" {
#   description = "the state of the subnet"
#   value       = module.infra_k8s_oracle_cloud.subnet_state
# }

# output "subnet_id" {
#   description = "ID of the core subnet"
#   value       = module.infra_k8s_oracle_cloud.subnet_id
# }

output "subnet_cidr" {
  description = "CIDR block of the core subnet"
  value       = module.infra_k8s_oracle_cloud.subnet_cidr
}

# output "compute_instances_public_ip" {
#   description = "public IPs of created nodes"
#   value       = module.infra_k8s_oracle_cloud.compute_instances_public_ip
# }

output "compute_instances" {
  value       = module.infra_k8s_oracle_cloud.compute_instances
  description = "names and IPs of created instances"
}

# output "compute_image" {
#   description = "image used for compute instances"
#   value       = module.infra_k8s_oracle_cloud.oci_ubuntu_images
# }

output "lb_public_ip" {
  description = "public IPs of LB"
  value       = module.infra_k8s_oracle_cloud.lb_public_ip
}
