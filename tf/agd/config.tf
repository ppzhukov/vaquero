locals {
  hostname = "agd.stend.test"

  nameservers = [
    var.nodes_settings.router_ip,
    "8.8.8.8"
  ]

  registration_cmd =  "SUSEConnect -e ${var.registry.email} -r ${var.registry.key}"

  runcmd_agd = <<EOT
   - unzip -o /srv/salt.zip -d /srv/
   - salt-call --local state.apply
EOT

}

#### AGD (Air Gap Data)
data template_file "rmt_server_cnf" {
  template = file("${path.module}/templates/rmt-server.cnf")
  vars = {
    hostname    = local.hostname
    ip_address  = var.nodes_settings.agd_ip
  }
}
data template_file "rmt_init" {
  template = file("${path.module}/templates/rmt-init.sh")
  vars = {
    hostname    = local.hostname
    password    = var.nodes_settings.agd_ip
  }
}

data template_file "rmt_conf" {
  template = file("${path.module}/templates/rmt.conf")
  vars = {
    scc_username    = var.mirroring_credentials.user
    scc_password    = var.mirroring_credentials.password
    password        = var.nodes_settings.agd_ip
  }
}

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

data "archive_file" "salt" {
  type        = "zip"
  source_dir = "${path.module}/files/salt/"
  output_path = "${path.module}/files/salt.zip"
}

data template_file "userdata_agd" {
  depends_on = [data.archive_file.salt]
  template = file("${path.module}/templates/userdata.yaml")
  vars = {
    username                   = var.nodes_settings.username
    ssh_public_key             = var.ssh_public_key
    rmt_server_cnf             = data.template_file.rmt_server_cnf.rendered
    rmt_init                   = data.template_file.rmt_init.rendered
    rmt_conf                   = data.template_file.rmt_conf.rendered
    registration_cmd           = local.registration_cmd
    runcmd_agd                 = local.runcmd_agd
    salt_zip                   = filebase64("${path.module}/files/salt.zip")
  }
}

data template_file "metadata_agd" {
  template = file("${path.module}/templates/metadata.yaml")
  vars = {
    hostname    = local.hostname
    ip_address  = var.nodes_settings.agd_ip
    netmask     = var.nodes_settings.netmask
    nameservers = jsonencode(local.nameservers)
  }
}

#### End AGD