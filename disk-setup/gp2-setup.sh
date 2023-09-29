#!/bin/sh

mkfs.ext4  /dev/nvme5n1
mkdir -p /mnt/gp2
mount /dev/nvme5n1 /mnt/gp2
