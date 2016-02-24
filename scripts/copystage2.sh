#!/bin/bash

if [ ! -f .lodev ]; then
	echo 'No loop opened'
	exit 1
fi
read < .lodev

echo 'Copying stage2 boot'
mkdir -p /media/oslo
sudo mount $REPLY /media/oslo
sudo cp bin/stage2 /media/oslo/STAGE2.SYS
sudo umount /media/oslo
