variable "vsphere_server" {
  description = "vSphere/vCenter server IP address."
  type = string
}
variable "vsphere_username" {
  description = "vSphere/vCenter server SSO username."
  type = string
}
variable "vsphere_password" {
  description = "vSphere/vCenter server SSO password."
  type = string
}
variable "vsphere_esxi_host" {
  description = "vSphere/vCenter server ESXi host IP address."
  type = string
}
variable "vsphere_datacenter" {
  description = "The vSphere datacenter name (i.e. Datacenter)"
  type = string
}
variable "vsphere_datastore" {
  description = "vSphere/vCenter server Datastore name (i.e. datastore1)"
  type = string
}
variable "vsphere_iso_folder" {
  description = "vSphere/vCenter server Datastore folder containing ISO files (i.e. images)"
  type        = string
}
variable "http_file_host" {
  description = "The IP address of your provisioning machine (i.e. 192.168.1.x)"
  type        = string
}
variable "pfsense_iso_filename" {
  description = "Filename for the pfSense ISO."
  type        = string
}
variable "ubuntu_iso_filename" {
  description = "Filename for the Ubuntu ISO."
  type        = string
}
variable "server2019_iso_filename" {
  description = "Filename for the Windows Server 2019 ISO."
  type        = string
}
variable "server2016_iso_filename" {
  description = "Filename for the Windows Server 2016 ISO."
  type        = string
}
variable "tailscale_preauth_key" {
  description = "The Tailscale pre-auth key used to connect the lab for remote use."
  type        = string
}
