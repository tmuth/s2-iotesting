#!/bin/bash
systemctl set-property Splunkd.service IOWriteBandwidthMax=
systemctl show --property IOWriteBandwidthMax Splunkd.service

systemctl set-property Splunkd.service IOReadBandwidthMax=
systemctl show --property IOReadBandwidthMax Splunkd.service
