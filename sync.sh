#!/bin/sh

DEST_BASE=/root/s2-iotesting


#rsync -avzh /opt/splunk/etc/system/local /root/s2-iotesting/splunk/system
#rsync -avzh /opt/splunk/etc/apps/s2_io_testing /root/s2-iotesting/splunk/apps
<<<<<<< HEAD
rsync -avzh /opt/splunk/etc/apps/search/lookups/aws*.csv /root/s2-iotesting/splunk/lookups/
=======
rsync -avzh /opt/splunk/etc/apps/search/lookups/*.csv /root/s2-iotesting/splunk/lookups/
>>>>>>> 16f40564067ffd78830c738cc16edd7bb6f7cec3

chown -R ec2-user:ec2-user $DEST_BASE/*
