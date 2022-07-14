locals {
  nameservers = [
    var.nodes_settings.router_ip,
    "8.8.8.8"
  ]

}

#### AGD (Air Gap Data)
 data "template_cloudinit_config" "userdata_agd" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.userdata_agd.rendered
  }
}

 data "template_cloudinit_config" "metadata_agd" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.metadata_agd.rendered
  }
}

data template_file "userdata_agd" {
  template = file("${path.module}/templates/userdata.yaml")
  
  vars = {
    username                   = var.nodes_settings.username
    ssh_public_key             = var.ssh_public_key
  }
}

data template_file "metadata_agd" {
  template = file("${path.module}/templates/metadata.yaml")
  vars = {
    hostname    = "agd"
    ip_address  = var.nodes_settings.agd_ip
    netmask     = var.nodes_settings.netmask
    nameservers = jsonencode(local.nameservers)
  }
}

#### End AGD