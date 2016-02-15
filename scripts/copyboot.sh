#!/bin/bash

if [ ! -f .lodev ]; then
	echo 'No loop opened'
	exit 1
fi
read < .lodev

DEV=$REPLY
echo 'Copying boot sector'
sudo dd if=bin/boot of="${DEV}" bs=512 count=1 obs=512 seek=0
sudo dd if=bin/sector2 of="${DEV}" bs=512 count=1 obs=512 seek=1
