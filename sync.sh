#!/bin/sh

DEST_BASE=~/s2-iotesting
HOSTNAME=`hostname`
if [ "$HOSTNAME" = i3en6xl ]; then
    printf '%s\n' "Running on $HOSTNAME"
    sudo rsync -avzh /opt/splunk/etc/system/local ~/s2-iotesting/splunk/system
    sudo rsync -avzh /opt/splunk/etc/apps/search/lookups/*.csv ~/s2-iotesting/splunk/lookups/
    sudo chown -R ec2-user:ec2-user $DEST_BASE/*
fi

if [ "$HOSTNAME" = mini-splunk ]; then
    printf '%s\n' "Running on $HOSTNAME"
    sudo rsync -avzh ~/s2-iotesting/splunk/lookups/*.csv /opt/splunk/etc/apps/s2_io_testing/lookups/
    sudo rsync -avzh /opt/splunk/etc/apps/s2_io_testing ~/s2-iotesting/splunk/apps
    sudo chown -R ec2-user:ec2-user $DEST_BASE/*
fi


if [ "$HOSTNAME" = azure-s2-test1 ]; then
    printf '%s\n' "Running on $HOSTNAME"
    sudo rsync -avzh /opt/splunk/etc/apps/search/lookups/azure*.csv ~/s2-iotesting/splunk/lookups/
    sudo chown -R azureuser:azureuser $DEST_BASE/*
fi

if [ "$HOSTNAME" = azure-s2-test2-l32s-v2 ]; then
    printf '%s\n' "Running on $HOSTNAME"
    sudo rsync -avzh /opt/splunk/etc/apps/search/lookups/azure*.csv ~/s2-iotesting/splunk/lookups/
    sudo chown -R azureuser:azureuser $DEST_BASE/*
fi

echo "$HOSTNAME"
