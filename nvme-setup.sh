#!/bin/sh
# Script to detect AWS "Instance Storage" drives, create a RAID0 array of them,
# then mount the array

MOUNT_POINT=/mnt/nvme
DEVICE_NAME=/dev/md0

sudo mkdir -p ${MOUNT_POINT}

EPHEMERAL_DISK=$(sudo nvme list | grep 'Amazon EC2 NVMe Instance Storage' | awk '{ printf "%s ", $1  }')

echo "Devices: ${EPHEMERAL_DISK}"
# Convert the string into an array
eval "DISK_ARRAY=($EPHEMERAL_DISK)"
DISK_COUNT=${#DISK_ARRAY[@]}
echo "Number of Devices: ${DISK_COUNT}"
mdadm --create --verbose --auto=yes ${DEVICE_NAME} --level=0 --raid-devices="${DISK_COUNT}" ${EPHEMERAL_DISK}
mkfs.ext4  ${DEVICE_NAME}
mkdir -p ${MOUNT_POINT}
mount ${DEVICE_NAME} ${MOUNT_POINT}