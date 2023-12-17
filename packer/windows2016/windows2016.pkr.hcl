packer {
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = "~> 1"
    }
  }
}

variable "vsphere_server" {}
variable "vsphere_username" {}
variable "vsphere_password" {}
variable "vsphere_esxi_host" {}
variable "vsphere_datastore" {}
variable "vsphere_iso_folder" {}
variable "server2016_iso_filename" {}

source "vsphere-iso" "windows2016" {
  convert_to_template  = true
  CPUs                 = 2
  RAM                  = 4096
  RAM_reserve_all      = true
  floppy_files = [
    "../../packer/windows2016/files/autounattend.xml",
    "../../packer/windows2016/scripts/disable-network-discovery.cmd",
    "../../packer/windows2016/scripts/disable-winrm.ps1",
    "../../packer/windows2016/scripts/enable-winrm.ps1",
    "../../packer/windows2016/scripts/install-vm-tools.cmd",
    "../../packer/windows2016/scripts/ConfigureRemotingForAnsible.ps1",
    "../../packer/windows2016/scripts/Install-WMF3Hotfix.ps1"
  ]
  guest_os_type        = "windows9Server64Guest"
  host                 = "${var.vsphere_esxi_host}"
  insecure_connection  = true
  communicator         = "winrm"
  iso_paths            = [
    "[${var.vsphere_datastore}] ${var.vsphere_iso_folder}/${var.server2016_iso_filename}",
    "[] /vmimages/tools-isoimages/windows.iso"
  ]
  network_adapters {
    network      = "VM Network"
    network_card = "vmxnet3"
  }
  disk_controller_type  = ["lsilogic-sas"]
  password       = "${var.vsphere_password}"
  winrm_username = "ansible"
  winrm_password = "ansible"
  ssh_username   = "ansible"
  ssh_password   = "ansible"
  storage {
    disk_size             = 51200
    disk_thin_provisioned = true
  }
  username       = "${var.vsphere_username}"
  vcenter_server = "${var.vsphere_server}"
  vm_name        = "server2016"
}

build {
  sources = ["source.vsphere-iso.windows2016"]
}
