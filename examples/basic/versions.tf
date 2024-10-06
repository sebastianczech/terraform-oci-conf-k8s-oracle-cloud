terraform {
  required_version = ">= 1.3.0"

  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 6.11.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.4"
    }
  }
}

provider "oci" {
  region              = var.region
  auth                = "SecurityToken"
  config_file_profile = "k8s-oci"
}
