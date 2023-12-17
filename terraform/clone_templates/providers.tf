terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.5.1"
    }
  }
}
provider "vsphere" {
  user                 = var.vsphere_username
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}