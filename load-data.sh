#
for i in `ls -1 2023-01-0*`;   do splunk add oneshot $i -index $1 -sourcetype $2 -auth 'admin:welcome1'; done
