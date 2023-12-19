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
variable "winrm_password" {}

source "vsphere-iso" "windows2019" {
  convert_to_template  = true
  CPUs                 = 2
  RAM                  = 4096
  RAM_reserve_all      = true
  floppy_files = [
    "../../packer/windows2019/files/autounattend.xml",
    "../../packer/windows2019/scripts/disable-network-discovery.cmd",
    "../../packer/windows2019/scripts/disable-winrm.ps1",
    "../../packer/windows2019/scripts/enable-winrm.ps1",
    "../../packer/windows2019/scripts/install-vm-tools.ps1",
    "../../packer/windows2019/scripts/ConfigureRemotingForAnsible.ps1",
    "../../packer/windows2019/scripts/Install-WMF3Hotfix.ps1"
  ]
  guest_os_type        = "windows9Server64Guest"
  host                 = "${var.vsphere_esxi_host}"
  insecure_connection  = true
  communicator         = "winrm"
  iso_url              = "http://lab.malicious.group/Windows_Server_2019.iso"
  iso_checksum         = "549bca46c055157291be6c22a3aaaed8330e78ef4382c99ee82c896426a1cee1"
  iso_paths            = [
    "[] /vmimages/tools-isoimages/windows.iso"
  ]
  folder               = "templates/windows2019/"

  network_adapters {
    network      = "VM Network"
    network_card = "vmxnet3"
  }
  disk_controller_type  = ["lsilogic-sas"]
  password       = "${var.vsphere_password}"
  winrm_username = "ansible"
  winrm_password = "${var.winrm_password}"
  storage {
    disk_size             = 51200
    disk_thin_provisioned = true
  }
  username       = "${var.vsphere_username}"
  vcenter_server = "${var.vsphere_server}"
  vm_name        = "server2019"
}

build {
  sources = ["source.vsphere-iso.windows2019"]
}
