# KIWI VMware vSphere SLES template
Use current file or:
1. Install SLES 15SP4 kiwi-templates-Minimal
```bash
sudo zypper in -y kiwi-templates-Minimal
```
2. Copy kiwi teamplate to working directory and edit Minimal.kiwi
Create template image
1. Install kiwi
```bash
sudo zypper in -y kiwi-templates-Minimal
sudo zypper in -y kiwi-image-oem-requires # ??
sudo zypper in -y kiwi-image-vmx # ??
```
2. Run below command for create root password 
```bash
openssl passwd -1 -salt 'suse' suse1234
```
and change Minimal.kiwi
3. Run below command for for create images:
```bash
sudo kiwi-ng  --profile VMware system build --description ./suse-SLE15-Enterprise-Minimal/ --target-dir /tmp/out
```
4. Run below command to copy image to ../tf/template/files/
```bash
cp /tmp/out/SLES15-SP4-Minimal-Rancher.x86_64-15.4.0.vmdk ../tf/template/files/
```
