#!/bin/sh

DEST_BASE=/root/s2-iotesting


rsync -avzh /opt/splunk/etc/system/local /root/s2-iotesting/splunk/system
rsync -avzh /opt/splunk/etc/apps/s2_io_testing /root/s2-iotesting/splunk/apps
rsync -avzh /opt/splunk/etc/apps/search/lookups/test*.csv /root/s2-iotesting/splunk/lookups/

chown -R ec2-user:ec2-user $DEST_BASE/*