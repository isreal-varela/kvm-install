# kvm-install
Simple script to create kvm and automate the install of Rocky 9/RHEL 8 with a kickstart file.
Script will back up the current template appending the date to the name and spin up a new template.

## How It's Made:
**Tech used:** bash, kvm, kickstart

## Example:

Get up and running:
```
./mkvirt.sh <optional kvm name>
```

You can run it without the vm name and the script will build the default template (currently 'rocky9-template'). 
This is helpful if you need to test a one off solution or develop a feature without impacting the production template.

Once the KVM is **successfully** provisioned and gracefully shutdown, it is possible to force the relevant QCOW2 file to be reduced in size to the minimal required by eliminating the store "blank/empty" space.  This is done by running:
```
sudo ./shrinkit.sh <optional kvm name>
```
