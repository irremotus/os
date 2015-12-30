#!/bin/bash

echo 'Formatting disk to fat12'
sudo mkfs.fat -F 12 /dev/loop0
