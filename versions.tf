terraform {
  required_version = ">= 1.3.0"

  required_providers {
    remote = {
      source  = "tenstad/remote"
      version = "0.1.3"
    }

    oci = {
      source  = "hashicorp/oci"
      version = "~> 6.7.0"
    }
  }
}
