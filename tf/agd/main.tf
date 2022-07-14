provider "vsphere" {
  vsphere_server = var.vsphere_credetial.server
  user           = var.vsphere_credetial.user
  password       = var.vsphere_credetial.password
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module "get_ids" {
    source        = "../modules/get_ids"
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
## Deploy AGD Node

module "agd" {
  depends_on = [module.get_ids]

  source        = "../modules/vm"

  vm_common_parameters = local.vm_common_parameters
  stend_environment = local.stend_environment
  
  vm_parameters = {
    name             = "agd"
    enable_wan       = true
    disk_size        = 240
    cpu              = 1
    memory           = 1024
    metadata         = data.template_file.metadata_agd.rendered
    userdata         = data.template_file.userdata_agd.rendered
    network_map      = [ module.get_ids.vsphere_ids.wan_id, module.get_ids.vsphere_ids.wan_id ]
  }
}
