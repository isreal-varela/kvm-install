# kvm-install
Simple script to create kvm and automate the install of Rocky 9 with a kickstart file.
Script will back up the current template appending the date to the name and spin up a new template.

## How It's Made:
**Tech used:** bash, kvm, kickstart, virt-sparsify

## Example:

Get up and running:
```
./mkvirt.sh test
```

Optionally, the QCOW2 file generated as a result of above can be "shrunk/sparsified" once the
kickstart processing is completed by running the following:
```
sudo ./shrinkit.sh test
```

Both shell scripts ("mkvirt" and "shrinkit"), will default to use "rocky9-template" as the KVM
when a parameter is NOT passed upon execution.  This is helpful if you need to test a one-off
solution or develop a feature without impacting the production template.

Average total duration for executing both SCRIPTS in sequence during unit testing: 37m45s
  Comprised of roughly 5m for "mkvirt.sh" and 32m45s for "shrinkit.sh".

Restrictions:
- Not intended to have multiple simulataneous executions for either script on a single host.
- As noted with "sudo" above, the "shrinkit.sh" script MUST be run as "root" user.  "mkvirt.sh"
  script, however, can be run by non-root as long as the QEMU user has access to the designated
  folder(s). 
