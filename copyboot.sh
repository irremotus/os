#!/bin/bash

#if [ $# -lt 1 ]; then
#	echo 'Device not given'
#	exit 1
#fi

#DEV=$1
DEV='/dev/loop0'
echo 'Copying boot sector'
sudo dd if=bin/boot of="${DEV}" bs=512 count=1 obs=512 seek=0
