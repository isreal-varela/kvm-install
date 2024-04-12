#!/bin/bash

virt-install --noreboot \
	--name rocky9-template \
	--memory 4096 \
	--vcpus=4 \
        --os-variant rhel9.0 \
       	--accelerate \
	--import \
	--network default,model=virtio \
	--disk path=/srv/vmdisks/rocky9-template.img,size=40 \
	--initrd-inject=rocky9.cfg \
	--extra-args='inst.ks=file:rocky9.cfg console=tty0 console=ttyS0,9600' \
	--location /srv/iso/Rocky-9.3-x86_64-minimal.iso
