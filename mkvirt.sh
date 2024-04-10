#!/bin/bash

virt-install --noreboot \
	--name rocky9-template \
	--memory 4096 \
	--vcpus=4 \
        --os-variant rhel9.0 \
       	--accelerate \
	--import \
	--network default,model=virtio \
	--disk size=40 \
	--initrd-inject=/home/yo_sup/workspace/kickstart/rocky9.cfg \
	--extra-args='inst.ks=file:rocky9.cfg console=tty0 console=ttyS0,9600' \
	--location /home/yo_sup/Downloads/Rocky-9.3-x86_64-dvd.iso
