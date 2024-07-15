#!/bin/bash +x
#
# Script is used "shrink" the generated qcow2 image file.
# The script is INTENDED to be run after ./mkvirt.sh and will
#  check to ensure that the named KVM is "shut off" in "virsh list"
#  output.  If the KVM is instead "running", this script will
#  re-check every 3 seconds UNTIL either:
#   - the KVM State changes to "shut off" -or-
#   - the duration (in seconds) exceeds the TIMEOUT value

date

timeout=360
end=$((SECONDS+timeout))
base_dir="/srv/vmdisks"
retval=1

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

if [[ -n ${1} ]]; then
	vm_name=${1}
else
	vm_name="rocky9-template"
fi

echo "KVM name: ${vm_name}"
echo "Max time allowed: ${end}s"

while [ $SECONDS -lt $end ]; do
	kvm_state=`virsh list --all | grep "${vm_name}" | tr -s " " | cut -d " " -f 4-`
	echo ${vm_name} ... ${kvm_state} ... ${SECONDS}s/${end}s
	if [[ ${kvm_state} = 'shut off' ]]; then
		retval=0
		break
	fi
	sleep 3
done

#echo "retval = ${retval}"
if [ $retval -eq 0 ]; then
	echo "Switching to '${base_dir}'..."
	cd ${base_dir}
	echo "Launching virt-sparsify to process ${vm_name}.qcow2..."
	virt-sparsify --check-tmpdir warn ${vm_name}.qcow2 sparsified.qcow2
	ls -l ${vm_name}.qcow2 sparsified.qcow2
	rm ${vm_name}.qcow2
	mv sparsified.qcow2 ${vm_name}.qcow2
else
	echo "Surpassed timeout and KVM not 'shut off'. Bypassing 'virt-sparsify'"
fi

date
exit ${retval}
