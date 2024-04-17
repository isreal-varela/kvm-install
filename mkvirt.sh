#!/bin/bash

date=$(date '+%Y-%m-%d')
base_dir="/srv/vmdisks"
vm_name="rocky9-template"
vm_backup="rocky9-${date}.qcow2"
backup="true"


function backup() {
  mv -f ${base_dir}/${vm_name}.qcow2 ${base_dir}/${vm_backup}
}

function create_virt() {
  virt-install --noreboot \
  --name ${vm_name} \
  --memory 4096 \
  --vcpus=4 \
  --os-variant rhel9.0 \
  --accelerate \
  --network bridge=br0,model=virtio \
  --disk path=/srv/vmdisks/${vm_name}.qcow2,size=40 \
  --initrd-inject=rocky9.cfg \
  --extra-args='inst.ks=file:rocky9.cfg console=tty0 console=ttyS0,9600' \
  --location /srv/iso/Rocky-9.3-x86_64-dvd.iso \
  --noautoconsole
}

if [[ -n ${backup} ]];then
  backup
  virsh undefine ${vm_name}
  create_virt
else
  virsh undefine ${vm_name}
  create_virt
fi

echo "yeah"
exit 0



