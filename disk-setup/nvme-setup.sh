#!/bin/sh

mdadm --create --verbose --auto=yes /dev/md0 --level=0 --raid-devices=2 /dev/nvme3n1 /dev/nvme4n1
mkfs.ext4  /dev/md0
mkdir -p /mnt/nvme
mount /dev/md0 /mnt/nvme
