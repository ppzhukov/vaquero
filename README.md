# vaquero
Concept creating VMware vSphere environment, VM template, and VMs for run SUSE Rancher witch Terraform.

[https://github.com/dff1980/2021-2.PoC](https://github.com/dff1980/2021-2.PoC)

## Requirements
- Download SLES 15SP4 iso
- Download Terraform CLI [mirror](https://hashicorp-releases.yandexcloud.net/terraform/)

## Run the kiwi and crete a template
Read more info in [kiwi-SLES-template](https://github.com/ppzhukov/vaquero/tree/main/kiwi-SLES-template)
- Add the template to vSphere

## Use Terraform for install nodes
Read more info in [tf](https://github.com/ppzhukov/vaquero/tree/main/tf)
- Add AGD (Air-Gap Data, RMT) node to vSphere
- Add and mirror (RMT) products at AGD Server
- Change registry address in tf/rancher/salt/salt/registration.sls
- Add Rancher nodes to vSphere

touch files/salt.zip
