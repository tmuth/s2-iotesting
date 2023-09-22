#!/bin/sh

mkfs.ext4  /dev/nvme4n1
mkdir -p /mnt/io2
mount /dev/nvme4n1 /mnt/io2
