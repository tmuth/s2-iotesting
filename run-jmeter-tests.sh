#!/bin/bash

INDEX_NAME=test_s2_gp2
HOME_PATH_PREFIX=/mnt/gp2/splunk
EARLIEST="01/01/2023:06:00:00"
LATEST="01/02/2023:22:00:00"
NAME_PREFIX="test_gp2_c"

IO_READ_LIMIT_BYTES=""
IO_READ_LIMIT_MB=""


function set_io_limit {
    systemctl set-property Splunkd.service IOWriteBandwidthMax="/mnt/nvme $1"
    systemctl show --property IOWriteBandwidthMax Splunkd.service

    systemctl set-property Splunkd.service IOReadBandwidthMax="/mnt/nvme $1"
    systemctl show --property IOReadBandwidthMax Splunkd.service

    IO_READ_LIMIT_BYTES=$(systemctl show --property IOReadBandwidthMax Splunkd.service | awk -F ' ' '{print $2}')
    IO_READ_LIMIT_MB=$(expr $IO_READ_LIMIT_BYTES / 1000 / 1000)
    echo "IO_READ_LIMIT_MB: ${IO_READ_LIMIT_MB}"
}

function drop_system_cache {
    echo 3 > /proc/sys/vm/drop_caches
}

function evict_cache {
    echo "evict cache for ${INDEX_NAME} "
    splunk _internal call /services/admin/cacheman/_evict -post:mb 1000000000 -post:path ${HOME_PATH_PREFIX}/${INDEX_NAME} -method POST -auth 'admin:welcome1'
    du -sh ${HOME_PATH_PREFIX}/* | grep ${INDEX_NAME}
}

function run_jmeter {
    # $1 : IO_LIMIT
    # $2 : CACHED
    # $3 : RECREATE_LOOKUP
    echo "Runnig run_jemeter"
    echo "${1} ${2} ${3}"
    jmeter -n -t jmeter-s2-searches.jmx -JINDEX_NAME=${INDEX_NAME} -JOUTPUT_LOOKUP_FILE=${NAME_PREFIX}${1}.csv -JIO_LIMIT=${1} -JCACHED=${2} -JRECREATE_LOOKUP=${3} -JEARLIEST=${EARLIEST} -JLATEST=${LATEST} -l jmeter-logs/${NAME_PREFIX}${1}.jtl
}



#for i in 100M 200M 400M 700M 3000M
# for i in 100M 400M 3000M
for i in 5000M
do
   echo "About to run ${i}"
   #set_io_limit ${i}
   evict_cache
   drop_system_cache
   run_jmeter "${i}" "uncached" "true"
   run_jmeter "${i}" "cached" "false"
done
