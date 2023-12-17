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
variable "ubuntu_iso_filename" {}
variable "ssh_username" {}
variable "ssh_password" {}
variable "http_file_host" {}


source "vsphere-iso" "ubuntu" {
  convert_to_template  = true
  CPUs                 = 1
  RAM                  = 2048
  RAM_reserve_all      = true
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "5m"
  http_ip          = "${var.http_file_host}"
  http_directory   = "../../packer/ubuntu/files/"
  http_port_min    = "8100"
  http_port_max    = "8299"
  boot_wait        = "2s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ---",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
    ]
  disk_controller_type  = ["lsilogic-sas"]
  guest_os_type        = "ubuntu64Guest"
  host                 = "${var.vsphere_esxi_host}"
  insecure_connection  = true
  iso_paths            = [
    "[${var.vsphere_datastore}] ${var.vsphere_iso_folder}/${var.ubuntu_iso_filename}"
  ]
  network_adapters {
    network      = "VM Network"
    network_card = "vmxnet3"
  }
  password     = "${var.vsphere_password}"
  ssh_port     = "22"
  ssh_username = "${var.ssh_username}"
  ssh_password = "${var.ssh_password}"
  ssh_timeout  = "30m"
  username       = "${var.vsphere_username}"
  vcenter_server = "${var.vsphere_server}"
  vm_name        = "ubuntu"
  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }
}

build {
  sources = ["source.vsphere-iso.ubuntu"]

  provisioner "file" {
    source = "../../packer/ubuntu/files/cookbook.zip"
    destination = "/home/ansible/cookbook.zip"
  }
}
