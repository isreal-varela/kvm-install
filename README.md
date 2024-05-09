# kvm-install
Simple script to create kvm and automate the install of Rocky 9 with a kickstart file.
Script will back up the current template appending the date to the name and spin up a new template.



## How It's Made:
**Tech used:** bash, kvm, kickstart

## Example:

Get up and running:
```
./mkvirt.sh test
```

You can run it without the vm name and the script will build the default template. 
This is helpful if you need to test a one off solution or develop a feature without impacting the production template.
