#!/bin/bash
#splunk _internal call /services/admin/cacheman/_evict -post:mb 1000000000 -post:path /mnt/nvme/splunk/git3 -method POST -auth 'admin:welcome1'
#splunk _internal call /services/admin/cacheman/_evict -post:mb 1000000000 -post:path /mnt/nvme/splunk/git7 -method POST -auth 'admin:welcome1'
splunk _internal call /services/admin/cacheman/_evict -post:mb 1000000000 -post:path /mnt/nvme/splunk/test_high_cardinality_compressed1 -method POST -auth 'admin:welcome1'
du -sh /mnt/nvme/splunk/* | grep --color=never compressed | grep -E "^\S*"
