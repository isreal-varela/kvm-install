#!/bin/bash

date=$(date '+%Y-%m-%d')

virt-install --noreboot \
  --name rocky9-${date} \
  --memory 4096 \
  --vcpus=4 \
  --os-variant rhel9.0 \
  --os-type linux \
  --accelerate \
  --network bridge=br0,model=virtio \
  --disk path=/srv/vmdisks/rocky9-${date}.qcow2,size=40 \
  --initrd-inject=rocky9.cfg \
  --extra-args='inst.ks=file:rocky9.cfg console=tty0 console=ttyS0,9600' \
  --location /srv/iso/Rocky-9.3-x86_64-dvd.iso \
  --noautoconsole

