terraform {
  required_version = ">= 1.3.0"

  required_providers {
    remote = {
      source  = "tenstad/remote"
      version = "0.1.3"
    }

    oci = {
      source  = "hashicorp/oci"
      version = "~> 6.33.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }

    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.3"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.0"
    }
  }
}
