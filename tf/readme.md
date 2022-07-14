

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


### Deploying tagging lambda

To deploy the tagging lambda, 
* Export vSphere credentials into environment variables:
```bash
export 
```
* Apply Terraform configuration with tagging lambda:
```bash
cd SLEdsadada-TemplatE !~!!!!!!!
terraform init
terraform apply --var-file ../example.tfvars
```

### Deleting tagging lambda

To delete tagging lambda, 
* Export AWS credentials into environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
* Destroy Terraform configuration:
```bash
terraform destroy --var-file example.tfvars
```

```bash
terraform destroy --var-file example.tfvars
```
