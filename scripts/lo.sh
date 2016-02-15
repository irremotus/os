#!/bin/bash

sudo modprobe loop
LODEV=`sudo losetup -f`
echo "Set up loop device: ${LODEV}"
name="disk.img"
if [ $# -ge 1 ]; then
	name=$1
fi
sudo losetup ${LODEV} ${name}
echo "${LODEV}" > .lodev
