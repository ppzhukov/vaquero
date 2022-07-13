# QIWI VMware vSphere SLES template
1. Run below command for create root password 
```bash
openssl passwd -1 -salt 'suse' suse1234
```
and change Minimal.kiwi
2. Run below command for for create images:
```bash
sudo kiwi-ng  --profile VMware system build --description ./suse-SLE15-Enterprise-Minimal/ --target-dir /tmp/out
```
3. Run below command to copy image to ../tf/template/files/
```bash
cp /tmp/out/SLES15-SP4-Minimal-Rancher.x86_64-15.4.0.vmdk ../tf/template/files/
```
