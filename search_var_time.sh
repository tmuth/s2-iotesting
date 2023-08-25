#!/usr/bin/env bash

LATEST_BASE=9

for i in {1..9}
do
   LATEST_BASE=$(expr $LATEST_BASE + 1)
   LATEST="01/${LATEST_BASE}/2023:22:00:00"
   echo $LATEST
   splunk _internal call /services/admin/cacheman/_evict -post:mb 1000000000 -post:path /mnt/nvme/splunk/git -method POST -auth 'admin:welcome1'
   du -sh /mnt/nvme/splunk/*
   jmeter -n -t jmeter-s2-single-search.jmx -JINDEX_NAME=git -JOUTPUT_LOOKUP_FILE=test_azure_single_c.csv -JLATEST=${LATEST} -l jmeter-logs/test_azure_single_b_${i}.jtl
done