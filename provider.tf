# +--------------------+ 
# | Provider Selection |
# +--------------------+
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
    }
    tls = {
      source  = "hashicorp/tls"
    }
  }
}

provider "oci" {
    tenancy_ocid = var.tenancy_ocid
    region       = var.region
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}