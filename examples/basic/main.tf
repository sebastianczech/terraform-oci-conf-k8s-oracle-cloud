data "http" "this" {
  url = "https://ifconfig.me"
}

module "infra_k8s_oracle_cloud" {
  source = "git::https://github.com/sebastianczech/terraform-oci-infra-k8s-oracle-cloud.git?ref=b74fcdb23322f6d216ca9f4c5a64a80330290ca7"

  compartment_id         = var.compartment_id
  id_rsa_pub             = try(file(var.id_rsa_pub), null)
  instance_count         = var.instance_count
  availability_domains   = var.availability_domains
  egress_security_rules  = var.egress_security_rules
  ingress_security_rules = var.ingress_security_rules
  my_public_ip           = "${data.http.this.response_body}/32"
}

module "conf_k8s_oracle_cloud" {
  source = "../../"

  compute_instances = module.infra_k8s_oracle_cloud.compute_instances
  lb_id             = module.infra_k8s_oracle_cloud.lb_id
  subnet_cidr       = module.infra_k8s_oracle_cloud.subnet_cidr
  id_rsa            = try(file(var.id_rsa), null)
  my_public_ip      = "${data.http.this.response_body}/32"
}
