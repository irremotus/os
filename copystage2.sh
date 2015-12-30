#!/bin/bash

echo 'Copying stage2 boot'
sudo mount /dev/loop0 /media/lo
sudo cp bin/stage2 /media/lo/stage2.sys
sudo umount /media/lo
