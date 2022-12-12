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
    router_ip = string
    master_ip = string
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

variable "mirroring_credentials" {
  type = object({
    user = string
    password = string
  })
  sensitive = true
}

variable template {
  type = object({
    folder = string
    template_name = string
  })
}

variable "agd" {
  description = "AGD data"
  type = object({
    password  = string
    hostname  = string
    ip       = string
    netmask  = string
    gateway  = string
    nameservers = list(string)
  })
  sensitive   = true
}
variable "registry" {
  description = "SLES Registry Key"
  type = object({
    key   = string
    email = string
  })
  sensitive   = true
}