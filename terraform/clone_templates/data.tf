data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "pfsense_template" {
  name          = "pfsense"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "ubuntu_template" {
  name          = "ubuntu"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "server2019_template" {
  name          = "server2019"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "server2016_template" {
  name          = "server2016"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_esxi_host}/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "VM_Network" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name = "VM Network"
}
data "vsphere_network" "LAN" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name = "LAN"
}
