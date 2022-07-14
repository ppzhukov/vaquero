 vsphere_environment = {
    datacenter         = "DC01_Local"
    datastore          = "vhost01_Datastore_02"
    cluster            = "Cluster"
    host               = "172.29.192.21"
    dvs                = "DSwitch 01"
    dpg                = "DPG_Ranchers_TF_LAB_VLAN1302"
    dpg_vlan_id        = "1302"
    wan                = "DPG_Zhukov_Lab_VLAN13"
    folder             = "rancher/rancher-tf"
}

nodes_settings = {
    nodes_hostname         = "rancher-tf"
    vm_node_name           = "rancher-tf"
    router_ip              = "192.168.14.1"
    master_ip              = "192.168.14.10"
    agd_ip                 = "192.168.14.11"
    username               = "sles"
    domain                 = "stend.test"
    network                = "192.168.14"
    netmask                = "24"
}

rancher_nodes_ip = [
    "21",
    "22",
    "23",
]


template_name = "SLES15SP4-minimal"

template = {
    vmdk_file_name      = "SLES15-SP4-Minimal-Rancher.x86_64-15.4.0.vmdk"
    network_name        = "VM Network"
    folder              = "rancher"
}
