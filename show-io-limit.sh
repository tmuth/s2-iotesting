#!/bin/bash
systemctl show --property IOWriteBandwidthMax Splunkd.service

systemctl show --property IOReadBandwidthMax Splunkd.service
