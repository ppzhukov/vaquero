
1. Install Terraform cli
2. Configure Terraform Mirror for Terraform Registry if you need.


3. Export secret variable
```bash
  export TF_VAR_ssh_public_key="ssh-rsa base64_data user@host-name"
  export TF_VAR_registry='{ key="AA-BB-CC", email="my_name@my-domain.com" }'
  export TF_VAR_vsphere_credetial='{ user="administrator", password="password", server="vsphere.stend.test" }'
  export TF_VAR_mirroring_credentials='{ user="12345678", password="secret"}'
  export TF_VAR_password="linux"
```
4. Run
```bash
cd ./tf
terraform -chdir=./template init
terraform -chdir=./template plan -var-file ../your.tfvars
terraform -chdir=./template apply -auto-approve -var-file ../your.tfvars
```
5. Wait creating VM and automatic switch off.
6. Run
```bash
cd ./tf
terraform -chdir=./agd init
terraform -chdir=./agd plan -var-file ../your.tfvars
terraform -chdir=./agd apply -auto-approve -var-file ../your.tfvars
```
add nginx server to agd
chmod 666  /etc/rmt/ssl/rmt-ca.crt













## 

- [Main](#main)
    - [Using as standalone Terraform configuration](#using-as-standalone-terraform-configuration)


# Main

## Using as standalone Terraform configuration

The configuration is done through Terraform variables. Example *tfvars* file is part of this repo and is named `example.tfvars`. Change the variables to match your environment / requirements before running `terraform apply ...`.

| Option | Explanation | Example |
|--------|-------------|---------|
|**vsphere_environment**|vSphere Environment Object|-|
|datacenter|Name of the Data Center|DC01_Local|
|datastore|Name of the Data Store|vhost01_Datastore_02|
|cluster|Name of the Cluster|Cluster|
|#pool|Name of the Pool *if you use them*|Office|
|host|Name of the Host|172.29.192.21|
|dvs|Name of the Distributed Virtual Switch for the stand|DSwitch 01|
|dpg|Name of the Distributed Port Group|DPG_PZhukov_Ranchers_TF_LAB_VLAN1302|
|dpg_vlan_id|VLAN ID|1302|
|wan|Name of the Distributed Virtual Switch for WAN|DPG_Zhukov_Lab_VLAN13|
|folder|Name of the Folder|PZhukov/pzhukov-rancher-tf|

