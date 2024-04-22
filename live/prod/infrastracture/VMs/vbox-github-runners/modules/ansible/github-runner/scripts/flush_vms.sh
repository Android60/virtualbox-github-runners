#!/bin/bash
# Script for cleaning frozen VMs
for f in $(vboxmanage list vms | cut -d " " -f 2 )
do
	echo "Removing VM $f"
	VBoxManage unregistervm --delete $f
done