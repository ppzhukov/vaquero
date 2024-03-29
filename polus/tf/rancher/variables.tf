variable "vsphere_credetial" {
  type = object({
    server = string
    user = string
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

variable "rancher_nodes_ip" {
  type = list(string)
  description = "Rancher Nodes IP adress"
}

variable "nodes_settings" {
  type = object({
    nodes_hostname = string
    vm_node_name = string
    wan_router_ip = string
    wan_netmask = string
    wan_gateway = string
    wan_nameservers = list(string)
    master_ip = string
    agd_ip = string
    username = string
    domain = string
    netmask = string
    network = string
  }) 
}

variable "ssh_public_key" {
  type    = string
  default = ""
  sensitive = true
}

/*variable "mirroring_credentials" {
  type = object({
    server = string
    user = string
    password = string
  })
  sensitive = true
}*/

variable template {
  type = object({
    folder = string
    template_name = string
  })
}

variable "tf_ssh_public_key" {
  type    = string
  default = ""
  sensitive = true
}

variable "tf_ssh_private_key" {
  type    = string
  default = ""
  sensitive = true
}

