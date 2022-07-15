provider "vsphere" {
  vsphere_server = var.vsphere_credetial.server
  user           = var.vsphere_credetial.user
  password       = var.vsphere_credetial.password
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module "get_ids" {
    source        = "../terraform-vsphere-vaquero-modules/get_ids"
    vsphere_environment = var.vsphere_environment
}

## Template data

data "vsphere_virtual_machine" "template" {
  name          = "${var.template_name}"
  datacenter_id = module.get_ids.vsphere_ids.datacenter_id
}

locals {
vm_common_parameters = {
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  firmware         = data.vsphere_virtual_machine.template.firmware
  template_id      = data.vsphere_virtual_machine.template.id
}

stend_environment = {
  host_system_id   = module.get_ids.vsphere_ids.vsphere_host_id
  resource_pool_id = module.get_ids.vsphere_ids.resource_pool_id  
  datastore_id     = module.get_ids.vsphere_ids.datastore_id
  folder           = var.template.folder
}
}

module "stend_environment" {
    depends_on       = [module.get_ids]
    source        = "../terraform-vsphere-vaquero-modules/stend_environment"
    stend_environment = var.vsphere_environment
}

## Deploy Router
module "router" {
  depends_on = [module.get_ids, module.stend_environment]
  source        = "../terraform-vsphere-vaquero-modules/vm"

  vm_common_parameters = local.vm_common_parameters
  stend_environment = local.stend_environment
  
  vm_parameters = {
    name             = "${var.nodes_settings.vm_node_name}-router"
    enable_wan       = true
    disk_size        = 24
    cpu              = 1
    memory           = 1024
    metadata         = data.template_file.metadata_router.rendered
    userdata         = data.template_file.userdata_router.rendered
    network_map      = [ module.stend_environment.stend_ids.lan_id, module.get_ids.vsphere_ids.wan_id ]
  }
}
## Deploy Rancher Nodes
module "rancher" {
  count = length(var.rancher_nodes_ip)
  
  depends_on = [module.get_ids, module.stend_environment]
  source        = "../terraform-vsphere-vaquero-modules/vm"

  vm_common_parameters = local.vm_common_parameters
  stend_environment = local.stend_environment
  
  vm_parameters = {
    name             = "${var.nodes_settings.vm_node_name}-rancher-${count.index}"
    enable_wan       = true
    disk_size        = 64
    cpu              = 4
    memory           = 8192
    metadata         = data.template_file.metadata_rancher[count.index].rendered
    userdata         = data.template_file.userdata_rancher.rendered
    network_map      = [ module.stend_environment.stend_ids.lan_id ]
  }
}

## Deploy Master Node
module "master" {  
  depends_on = [module.get_ids, module.stend_environment]
  source        = "../terraform-vsphere-vaquero-modules/vm"

  vm_common_parameters = local.vm_common_parameters
  stend_environment = local.stend_environment
  
  vm_parameters = {
    name             = "${var.nodes_settings.vm_node_name}-master"
    enable_wan       = true
    disk_size        = 64
    cpu              = 1
    memory           = 1024
    metadata         = data.template_file.metadata_master.rendered
    userdata         = data.template_file.userdata_master.rendered
    network_map      = [ module.stend_environment.stend_ids.lan_id ]
    
  }
}
