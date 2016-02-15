#!/bin/bash

if [ ! -f .lodev ]; then
	echo 'No loop opened'
	exit 1
fi
read < .lodev
rm .lodev
sudo losetup -d $REPLY
echo 'Detached loop device'
