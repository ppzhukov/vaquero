locals {

  runcmd_master = <<EOT
   - unzip /srv/salt/salt.zip
   - salt-call --local state.apply
EOT

  runcmd_minion = <<EOT
   - systemctl enable salt-minion --now
EOT

  minion_conf = file("${path.module}/salt/minion/minion.conf")

  minion_conf_master  =  "${local.minion_conf} \n      roles: master"
  minion_conf_router  =  "${local.minion_conf} \n      roles: router"
  minion_conf_rancher =  "${local.minion_conf} \n      roles: rancher"
  minion_conf_agd     =  "${local.minion_conf} \n      roles: agd"
  
  gateway = var.nodes_settings.router_ip

  nameservers = [
    var.nodes_settings.router_ip
  ]

}

#### Router
 data "template_cloudinit_config" "userdata_router" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.userdata_router.rendered
  }
}

 data "template_cloudinit_config" "metadata_router" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.metadata_router.rendered
  }
}

data template_file "userdata_router" {
  template = file("${path.module}/templates/userdata_node.yaml")
  
  vars = {
    username                   = var.nodes_settings.username
    ssh_public_key             = var.ssh_public_key
    runcmd                     = local.runcmd_minion
    salt_conf                  = base64encode(local.minion_conf_rancher)
    salt_autosign_grains_conf  = filebase64("${path.module}/salt/minion/autosign-grains.conf")
  }
}

data template_file "metadata_router" {
  template = file("${path.module}/templates/metadata_router.yaml")
  vars = {
    hostname    = "router"
    ip_address  = var.nodes_settings.router_ip
    netmask     = var.nodes_settings.netmask
    nameservers = jsonencode(local.nameservers)
  }
}

#### End Router


#### Master
 data "template_cloudinit_config" "userdata_master" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.userdata_master.rendered
  }
}

 data "template_cloudinit_config" "metadata_master" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.metadata_master.rendered
  }
}

data "archive_file" "salt" {
  type        = "zip"
  source_dir = "${path.module}/salt/salt/"
  output_path = "${path.module}/files/salt.zip"
}


data template_file "userdata_master" {
  depends_on = [data.archive_file.salt]
  template = file("${path.module}/templates/userdata_master.yaml")

  vars = {
    username                   = var.nodes_settings.username
    ssh_public_key             = var.ssh_public_key
    runcmd                     = local.runcmd_master
    salt_minion_conf           = base64encode(local.minion_conf_master)
    salt_autosign_grains_conf  = filebase64("${path.module}/salt/minion/autosign-grains.conf")
    
    salt_zip                   = filebase64("${path.module}/files/salt.zip")
    
    salt_reactor_start         = filebase64("${path.module}/salt/reactor/start.sls")
    salt_reactor_delkey        = filebase64("${path.module}/salt/reactor/delkey.sls")
    salt_master_conf           = filebase64("${path.module}/salt/master/master.conf")
    salt_autosign_key          = filebase64("${path.module}/salt/master/autosign_key")
    
  }
}

data template_file "metadata_master" {
  template = file("${path.module}/templates/metadata_node.yaml")
  vars = {
    hostname    = "master"
    ip_address  = var.nodes_settings.master_ip
    netmask     = var.nodes_settings.netmask
    nameservers = jsonencode(local.nameservers)
    gateway     = local.gateway
  }
}

#### End Master

#### Rancher
 data "template_cloudinit_config" "userdata_rancher" {

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.userdata_rancher.rendered
  }
}

 data "template_cloudinit_config" "metadata_rancher" {
  count = length(var.rancher_nodes_ip)

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.metadata_rancher[count.index].rendered
  }
}

data template_file "userdata_rancher" {
  template = file("${path.module}/templates/userdata_node.yaml")
  
  vars = {
    username                   = var.nodes_settings.username
    ssh_public_key             = var.ssh_public_key
    router_ip                  = var.nodes_settings.router_ip
    runcmd                     = local.runcmd_minion
    salt_conf                  = base64encode(local.minion_conf_rancher)
    salt_autosign_grains_conf  = filebase64("${path.module}/salt/minion/autosign-grains.conf")
  }
}

data template_file "metadata_rancher" {
  count = length(var.rancher_nodes_ip)
  template = file("${path.module}/templates/metadata_node.yaml")
  vars = {
    hostname    = "${var.nodes_settings.nodes_hostname}-rancher-${count.index}"
    ip_address  = "${var.nodes_settings.network}.${var.rancher_nodes_ip[count.index]}"
    netmask     = var.nodes_settings.netmask
    nameservers = jsonencode(local.nameservers)
    gateway     = local.gateway
  }
}
#### End Rancher
