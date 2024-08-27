#!/bin/bash
#
# Script is used to build kvm image.
# It will back up the vm template adding the current date and then delete the qcow2 image as well as remove the kvm from inventory before attempting to rebuild.


date=$(date '+%Y-%m-%d')
base_dir="/srv/vmdisks"
backup="true"


function backup() {
  mv -f "${base_dir}"/"${vm_name}".qcow2 "${base_dir}"/"${vm_backup}"
}

function create_virt() {
  virt-install --noreboot \
  --name "${vm_name}" \
  --memory 4096 \
  --vcpus=4 \
  --os-variant rocky9 \
  --accelerate \
  --network bridge=br0,model=virtio \
  --disk path=/srv/vmdisks/"${vm_name}".qcow2,size=70 \
  --initrd-inject=rocky9.cfg \
  --extra-args='inst.ks=file:rocky9.cfg fips=1 console=tty0 console=ttyS0,9600' \
  --location /srv/iso/Rocky-9.4-x86_64-dvd.iso \
  --noautoconsole
}

if [[ -n ${1} ]];then
	vm_name=${1}
else
	vm_name="rocky9-template"
fi

vm_backup="${vm_name}-${date}.qcow2"

if [[ -n ${backup} ]];then
  backup
  virsh undefine "${vm_name}"
  create_virt
else
  virsh undefine "${vm_name}"
  create_virt
fi

exit 0



