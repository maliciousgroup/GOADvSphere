data "external" "os" {
  working_dir = path.module
  program = ["..\\scripts\\printf", "{\"os\": \"Linux\"}"]
}
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_host" "esxi" {
  name          = var.vsphere_esxi_host
  datacenter_id = data.vsphere_datacenter.dc.id
}
