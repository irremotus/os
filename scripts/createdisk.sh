#!/bin/bash

echo "Creating disk"
dd if=/dev/zero of=disk.img bs=512 count=1024
