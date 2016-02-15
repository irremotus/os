#!/bin/bash

if [ ! -f .lodev ]; then
	echo 'No loop opened'
	exit 1
fi
read < .lodev

echo 'Formatting disk to fat12'
sudo mkfs.fat -I -F 12 -s 1 -S 512 -R 1 -r 512 -f 2 $REPLY 512
