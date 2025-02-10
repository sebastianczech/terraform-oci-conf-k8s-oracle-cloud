# Basic example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4.4 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.4.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_conf_k8s_oracle_cloud"></a> [conf\_k8s\_oracle\_cloud](#module\_conf\_k8s\_oracle\_cloud) | ../../ | n/a |
| <a name="module_infra_k8s_oracle_cloud"></a> [infra\_k8s\_oracle\_cloud](#module\_infra\_k8s\_oracle\_cloud) | git::https://github.com/sebastianczech/terraform-oci-infra-k8s-oracle-cloud.git | b74fcdb23322f6d216ca9f4c5a64a80330290ca7 |

## Resources

| Name | Type |
|------|------|
| [http_http.this](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_domains"></a> [availability\_domains](#input\_availability\_domains) | Availability domains in which instances are going to be created | `list(number)` | <pre>[<br/>  1,<br/>  1<br/>]</pre> | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment ID | `string` | n/a | yes |
| <a name="input_egress_security_rules"></a> [egress\_security\_rules](#input\_egress\_security\_rules) | Egress security rules | `list(map(string))` | <pre>[<br/>  {<br/>    "description": "Allow all outgoing traffic",<br/>    "destination": "0.0.0.0/0",<br/>    "destination_type": "CIDR_BLOCK",<br/>    "protocol": "all"<br/>  }<br/>]</pre> | no |
| <a name="input_id_rsa"></a> [id\_rsa](#input\_id\_rsa) | Path to SSH private key | `string` | `"~/.ssh/id_rsa"` | no |
| <a name="input_id_rsa_pub"></a> [id\_rsa\_pub](#input\_id\_rsa\_pub) | Path to SSH public key | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_ingress_security_rules"></a> [ingress\_security\_rules](#input\_ingress\_security\_rules) | Ingress security rules | `list(map(string))` | <pre>[<br/>  {<br/>    "description": "Allow all for SSH",<br/>    "port": 22,<br/>    "protocol": 6,<br/>    "source": "0.0.0.0/0",<br/>    "source_type": "CIDR_BLOCK"<br/>  },<br/>  {<br/>    "description": "Allow all for HTTP",<br/>    "port": 80,<br/>    "protocol": 6,<br/>    "source": "0.0.0.0/0",<br/>    "source_type": "CIDR_BLOCK"<br/>  },<br/>  {<br/>    "description": "Allow all for HTTPS",<br/>    "port": 443,<br/>    "protocol": 6,<br/>    "source": "0.0.0.0/0",<br/>    "source_type": "CIDR_BLOCK"<br/>  },<br/>  {<br/>    "description": "Allow all for ICMP",<br/>    "icmp_code": 4,<br/>    "icmp_type": 3,<br/>    "protocol": 1,<br/>    "source": "0.0.0.0/0",<br/>    "source_type": "CIDR_BLOCK"<br/>  }<br/>]</pre> | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create | `number` | `2` | no |
| <a name="input_region"></a> [region](#input\_region) | Oracle Cloud region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_domain"></a> [availability\_domain](#output\_availability\_domain) | availability domain |
| <a name="output_compute_instances"></a> [compute\_instances](#output\_compute\_instances) | names and IPs of created instances |
| <a name="output_lb_public_ip"></a> [lb\_public\_ip](#output\_lb\_public\_ip) | public IPs of LB |
| <a name="output_master_public_ip"></a> [master\_public\_ip](#output\_master\_public\_ip) | public IPs of master node |
| <a name="output_microk8s_config_private"></a> [microk8s\_config\_private](#output\_microk8s\_config\_private) | kubectl configuration file with private IP |
| <a name="output_microk8s_config_public"></a> [microk8s\_config\_public](#output\_microk8s\_config\_public) | kubectl configuration file with public IP |
| <a name="output_subnet_cidr"></a> [subnet\_cidr](#output\_subnet\_cidr) | CIDR block of the core subnet |
| <a name="output_vcn_cidr"></a> [vcn\_cidr](#output\_vcn\_cidr) | CIDR block of the core VCN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
