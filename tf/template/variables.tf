variable "vsphere_credetial" {
  type = object({
    server   = string
    user     = string
    password = string
  })
  sensitive = true
}

variable "vsphere_environment" {
  type = object({
    datacenter = string
    datastore = string
    cluster = string
    host = string
    dvs = string
    dpg = string
    dpg_vlan_id = string
    wan = string
    folder = string
  })
}

variable "template_name" {
  description = "Node template name"
  type = string
}

variable template {
  type = object({
    vmdk_file_name = string
    network_name = string
    folder = string
  })
}
