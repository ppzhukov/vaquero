# vaquero
Creating VMware vSphere environment, VM template, and VMs to run SUSE Rancher.

- Download SLES 15SP4 iso
- Download Terraform CLI [mirror](https://hashicorp-releases.yandexcloud.net/terraform/)
- Run the kiwi and crete a template.
- Add the template to vSphere
- Add AGD (Air-Gap Data, RMT + Registry) node to vSphere
- Change registry address in tf/rancher/salt/salt/registration.sls
- Add Rancher nodes to vSphere

touch files/salt.zip
