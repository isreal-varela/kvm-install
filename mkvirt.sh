#!/bin/bash +x
#
# Script is used to build kvm image.
# It will back up the vm template adding the current date and then delete the qcow2 image as well as remove the kvm from inventory before attempting to rebuild.


date=$(date '+%Y-%m-%d')
base_dir="/srv/vmdisks"
backup="true"
vm_name="rocky9-template"

if_dev="br_int"
cfg_name="rocky9"
iso_path="/srv/iso"
iso_name="Rocky-9.4-x86_64-dvd.iso"
os_variant="rocky9"

function create_virt() {
  echo "cmd:  virt-install --noreboot \ "
  echo "      --name '${vm_name}' \ "
  echo "      --memory 4096 \ "
  echo "      --vcpus=4 \ "
  echo "      --os-variant ${os_variant} \ "
  echo "      --accelerate \ "
  echo "      --network bridge=${if_dev},model=virtio \ "
  echo "      --disk path=${base_dir}/${vm_name}.qcow2,size=70 \ "
  echo "      --initrd-inject=${cfg_name}.cfg \ "
  echo "      --extra-args='inst.ks=file:${cfg_name}.cfg fips=1 console=tty0 console=ttyS0,9600' \ "
  echo "      --location ${iso_path}/${iso_name} \ "
  echo "      --noautoconsole"

  echo
  read -N 3 -p "Pausing 5 secs ... Ctrl-C to abort ..." -t 5
  echo

  virt-install --noreboot \
  --name "${vm_name}" \
  --memory 4096 \
  --vcpus=4 \
  --os-variant ${os_variant} \
  --accelerate \
  --network bridge=${if_dev},model=virtio \
  --disk path=${base_dir}/${vm_name}.qcow2,size=70 \
  --initrd-inject=${cfg_name}.cfg \
  --extra-args="inst.ks=file:${cfg_name}.cfg fips=1 console=tty0 console=ttyS0,9600" \
  --location ${iso_path}/${iso_name} \
  --noautoconsole
}

function clean_vm() {

  tmp=$(virsh list --all | grep " ${vm_name} " | awk '{print $3}')
  if ! ([ "x$tmp" == "x" ] );then
    virsh undefine ${vm_name}
  fi

  if [ -f "$base_dir/$vm_name.qcow2" ];then
    vm_backup="${vm_name}-${date}.qcow2"
    mv -f "${base_dir}"/"${vm_name}".qcow2 "${base_dir}"/"${vm_backup}"
  fi

}

if [[ -n ${1} ]];then
	vm_name=${1}
fi

if [[ -n ${2} ]];then
	cfg_name=${2}
fi
if [ $cfg_name == 'rhel8' ];then
  iso_name="rhel-8.10-x86_64-dvd.iso"
  os_variant="rhel8-unknown"
fi

echo -n "Checking ISO file: ${iso_path}/${iso_name}..."
if ! [ -f "$iso_path/$iso_name" ];then
  echo "!! NOT FOUND - Aborting !!"
  exit -1
else
  echo "Ok"
fi

echo "Using the following parameters in attempt:"
echo "     vm_name = ${vm_name}"
echo "    base_dir = ${base_dir}"
echo "      if_dev = ${if_dev}"
echo "    cfg_name = ${cfg_name}"
echo "    iso_path = ${iso_path}"
echo "    iso_name = ${iso_name}"
echo "  os_variant = ${os_variant}"
echo

clean_vm
create_virt

exit 0
