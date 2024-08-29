data "http" "this" {
  url = "https://ifconfig.me"
}

module "infra_k8s_oracle_cloud" {
  source = "git::https://github.com/sebastianczech/terraform-oci-infra-k8s-oracle-cloud.git?ref=f253ec13e22763905f2dee61bdf73c5ec9cf2bf4"

  compartment_id         = var.compartment_id
  id_rsa_pub             = try(file(var.id_rsa), null)
  instance_count         = var.instance_count
  availability_domains   = var.availability_domains
  egress_security_rules  = var.egress_security_rules
  ingress_security_rules = var.ingress_security_rules
  my_public_ip           = "${data.http.this.response_body}/32"
}
