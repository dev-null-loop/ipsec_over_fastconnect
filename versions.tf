terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "= 6.21.0"
    }
  }

  required_version = ">= 1.5.7"
}
