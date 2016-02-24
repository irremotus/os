#!/bin/bash

if [ ! -f .lodev ]; then
	echo 'No loop opened'
	exit 1
fi
read < .lodev

DEV=$REPLY
echo 'Copying boot sector'
set -x
# copy the first 11 bytes (jump(3) + name(8))
sudo dd if=bin/boot of="${DEV}" count=11 skip=0 seek=0 iflag=count_bytes,skip_bytes oflag=seek_bytes
# skip the BIOS Parameter Block (BPB) (51 bytes)
# copy the bootstrap portion of the MBR
sudo dd if=bin/boot of="${DEV}" count=384 skip=62 seek=62 iflag=count_bytes,skip_bytes oflag=seek_bytes
# skip the partition table (64 bytes)
# copy the boot flag "55aa" (2 bytes)
sudo dd if=bin/boot of="${DEV}" count=2 skip=510 seek=510 iflag=count_bytes,skip_bytes oflag=seek_bytes
# copy a second sector for testing purposes
#sudo dd if=bin/sector2 of="${DEV}" bs=512 count=1 obs=512 seek=1
