#!/bin/bash
systemctl set-property Splunkd.service IOWriteIOPSMax=
systemctl show --property IOWriteIOPSMax Splunkd.service

systemctl set-property Splunkd.service IOReadBandwidthMax=
systemctl show --property IOReadBandwidthMax Splunkd.service
