#!/bin/bash
echo "Press [CTRL+C] to stop.."
while :
do
	sync; echo 3 > /proc/sys/vm/drop_caches 
	sleep 1
done