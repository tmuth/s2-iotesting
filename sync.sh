#!/bin/sh

DEST_BASE=/root/s2-iotesting


rsync -avzh /opt/splunk/etc/system/local /root/s2-iotesting/splunk/system
rsync -avzh /opt/splunk/etc/apps/s2_io_testing /root/s2-iotesting/splunk/apps

chown -R ec2-user:ec2-user $DEST_BASE/*