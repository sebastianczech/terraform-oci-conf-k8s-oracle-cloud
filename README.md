# terraform-oci-conf-k8s-oracle-cloud

Terraform module to configure free Kubernetes cluster in Oracle Cloud

## Prerequisites

1. Install tools:
   - [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
   - [OCI Command Line Interface (CLI)](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)

## Usage

1. Authenticate to Oracle Cloud:

```bash
oci session authenticate --region eu-frankfurt-1 --profile-name k8s-oci
```

Token can be later refreshed by command:

```bash
oci session refresh --profile k8s-oci
```

2. Initialize Terraform:

```bash
cd examples/basic
terraform init
```

3. Prepare file with variables values:

```bash
cp example.tfvars terraform.tfvars
vi terraform.tfvars
```

4. Apply code for infrastructure:

```bash
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 6.8.0 |
| <a name="requirement_remote"></a> [remote](#requirement\_remote) | 0.1.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.3.3 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2.2 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 6.8.0 |
| <a name="provider_remote"></a> [remote](#provider\_remote) | 0.1.3 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.12.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.k8s_cluster_join](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.k8s_cluster_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.master_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.worker_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_60_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [external_external.microk8s_config](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/network_load_balancer_network_load_balancer) | data source |
| [remote_file.join_command_token](https://registry.terraform.io/providers/tenstad/remote/0.1.3/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute_instances"></a> [compute\_instances](#input\_compute\_instances) | A map of compute instances to create | `map(any)` | n/a | yes |
| <a name="input_id_rsa"></a> [id\_rsa](#input\_id\_rsa) | Path to the private key file | `string` | n/a | yes |
| <a name="input_lb_id"></a> [lb\_id](#input\_lb\_id) | ID of the load balancer | `string` | n/a | yes |
| <a name="input_my_public_ip"></a> [my\_public\_ip](#input\_my\_public\_ip) | My public IP address | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR block for the subnet | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_master_public_ip"></a> [master\_public\_ip](#output\_master\_public\_ip) | The public IP address of the master node |
| <a name="output_microk8s_config_private"></a> [microk8s\_config\_private](#output\_microk8s\_config\_private) | The private configuration for microk8s |
| <a name="output_microk8s_config_public"></a> [microk8s\_config\_public](#output\_microk8s\_config\_public) | The public configuration for microk8s |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

MIT Licensed. See [LICENSE](LICENSE).
