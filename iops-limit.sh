#!/bin/bash
systemctl set-property Splunkd.service IOWriteIOPSMax="/mnt/nvme $1"
systemctl show --property IOWriteIOPSMax Splunkd.service

systemctl set-property Splunkd.service IOReadBandwidthMax="/mnt/nvme $1"
systemctl show --property IOReadBandwidthMax Splunkd.service
