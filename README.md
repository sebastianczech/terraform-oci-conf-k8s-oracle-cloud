# terraform-oci-conf-k8s-oracle-cloud

Terraform module to configure free Kubernetes cluster in Oracle Cloud

## Prerequisites

1. Install tools:
   - [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
   - [OCI Command Line Interface (CLI)](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)

## Usage

1. Initialize Terraform:

```bash
cd examples/basic
terraform init
```

2. Prepare file with variables values:

```bash
cp example.tfvars terraform.tfvars
vi terraform.tfvars
```

3. Apply code for infrastructure:

```bash
terraform apply
```
