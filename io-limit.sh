#!/bin/bash
systemctl set-property Splunkd.service IOWriteBandwidthMax="/mnt/nvme $1"
systemctl show --property IOWriteBandwidthMax Splunkd.service

systemctl set-property Splunkd.service IOReadBandwidthMax="/mnt/nvme $1"
systemctl show --property IOReadBandwidthMax Splunkd.service
