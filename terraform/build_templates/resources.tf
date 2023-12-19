//noinspection MissingProperty
resource "vsphere_host_virtual_switch" "vswitch_LAN" {
  host_system_id      = data.vsphere_host.esxi.id
  name                = "vSwitch LAN"
  network_adapters    = ["vmnic1"]
  active_nics         = ["vmnic1"]
}
resource "vsphere_host_port_group" "portgroup_LAN" {
  name                = "LAN"
  host_system_id      = data.vsphere_host.esxi.id
  virtual_switch_name = vsphere_host_virtual_switch.vswitch_LAN.name
  depends_on          = [vsphere_host_virtual_switch.vswitch_LAN]
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name                = "cluster"
  datacenter_id       = data.vsphere_datacenter.dc.id
}

resource "null_resource" "pfsense_builder" {
  triggers = {
    vsphere_server   = var.vsphere_server
    vsphere_username = var.vsphere_username
    vsphere_password = var.vsphere_password
  }
  depends_on = [
    vsphere_host_port_group.portgroup_LAN,
  ]
  provisioner "local-exec" {
    command = local.build_pfsense_windows
  }
}

resource "null_resource" "ubuntu_builder" {
    triggers = {
    vsphere_server   = var.vsphere_server
    vsphere_username = var.vsphere_username
    vsphere_password = var.vsphere_password
  }
  depends_on = [
    vsphere_host_port_group.portgroup_LAN,
  ]
  provisioner "local-exec" {
    command = local.build_ubuntu_windows
  }
}

resource "null_resource" "windows_2016_builder" {
  triggers = {
    vsphere_server   = var.vsphere_server
    vsphere_username = var.vsphere_username
    vsphere_password = var.vsphere_password
  }
  depends_on = [
    vsphere_host_port_group.portgroup_LAN,
  ]
  provisioner "local-exec" {
    command = local.build_windows2016_windows
  }
}

resource "null_resource" "windows_2019_builder" {
  triggers = {
    vsphere_server   = var.vsphere_server
    vsphere_username = var.vsphere_username
    vsphere_password = var.vsphere_password
  }
  depends_on = [
    vsphere_host_port_group.portgroup_LAN,
  ]
  provisioner "local-exec" {
    command = local.build_windows2019_windows
  }
}
