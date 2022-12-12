# KIWI VMware vSphere SLES template
Use current file or:
1. Install kiwi.
```bash
sudo zypper install -y python3-kiwi
```
2. Run below command for create root password if you need root access to template VM.
```bash
openssl passwd -1 -salt 'suse' suse1234
```
and change Minimal.kiwi
3. Download SUSE SLES 15SP4 full iso.
SLE-15-SP4-Full-x86_64-GM-Media1.iso
4. Make directory /media/suse
```bash
sudo mkdir -p /media/suse
```
5. Mount the iso to the directory.
```bash
sudo mount SLE-15-SP4-Full-x86_64-GM-Media1.iso /media/suse/
```
6. Run below command for for create images:
```bash
sudo kiwi-ng  --profile VMware system build --description ./kiwi-SLES-template/ --target-dir /tmp/out
```
7. Run below command to copy image to ../tf/template/files/
```bash
cp /tmp/out/SLES15-SP4-Minimal-Rancher.x86_64-15.4.0.vmdk ./tf/template/files/
```
