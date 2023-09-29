#!/bin/sh

mkfs.ext4  /dev/nvme3n1
mkdir -p /mnt/gp3
mount /dev/nvme3n1 /mnt/gp3
