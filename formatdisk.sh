#!/bin/bash

echo 'Formatting disk to fat12'
sudo mkfs.fat -I -F 12 -s 1 -S 512 -R 1 -r 512 -f 2 /dev/loop0 512
