#!/bin/bash

systemctl set-property Splunkd.service IOWriteBandwidthMax="/mnt/nvme 100M"
systemctl show --property IOWriteBandwidthMax Splunkd.service

systemctl set-property Splunkd.service IOReadBandwidthMax="/mnt/nvme 100M"
systemctl show --property IOReadBandwidthMax Splunkd.service



SPLUNK_HOST=localhost:8089
AUTH_TOKEN=eyJraWQiOiJzcGx1bmsuc2VjcmV0IiwiYWxnIjoiSFM1MTIiLCJ2ZXIiOiJ2MiIsInR0eXAiOiJzdGF0aWMifQ.eyJpc3MiOiJhZG1pbiBmcm9tIGlwLTE3Mi0zMS0xNS0xNzguZWMyLmludGVybmFsIiwic3ViIjoiYWRtaW4iLCJhdWQiOiJiYXNoIiwiaWRwIjoiU3BsdW5rIiwianRpIjoiNjg5N2JlZWJjNjkzZDU0MGYzZTgxY2NiMjVmMjY5OWQ1NDdlMzEzOGU0NTU3NzA1Yjg2YTdlN2Q4ZGI4MjBkYSIsImlhdCI6MTY5MDkzMjcxNCwiZXhwIjoxNzIyNTU1MTE0LCJuYnIiOjE2OTA5MzI3MTR9.au2gO-9Bi6nL_c43IradkeTw1raWdcm1rekm0MC4mTr-jTv6hGR566iCwmu2QO32x2bA9GfpFyI9UzaPo7YxCg
# Token authentication is the preferred method over username/password and is documented here:
# https://docs.splunk.com/Documentation/Splunk/latest/Security/EnableTokenAuth
SPLUNK_USERNAME=admin

CLI_AUTH_OPTION=()
AUTH_OPTION=()
if [ ! -z "$AUTH_TOKEN" ]; then
    CLI_AUTH_OPTION+=( -token ${AUTH_TOKEN} )
    AUTH_OPTION+=( -H "Authorization: Bearer ${AUTH_TOKEN}" )
    #echo "Using Token Auth"
else
    CLI_AUTH_OPTION+=( -auth "${SPLUNK_USERNAME}:${SPLUNK_PASS}" )
    AUTH_OPTION+=( -u ${SPLUNK_USERNAME}:${SPLUNK_PASS} )
    #echo "Using User:Pass Auth"
fi

function splunk_search_polling {
    SEARCH_LEVEL=${2:-verbose} 
    curl_opts_common=( -s -k -d adhoc_search_level=${SEARCH_LEVEL} )
    
    curl_opts=( "${curl_opts_common[@]}"  "${AUTH_OPTION[@]}" -d search="${1}" )
    #echo ${curl_opts[@]}

    RESULTS=`curl "${curl_opts[@]}"  -X POST https://${SPLUNK_HOST}/services/search/jobs`
 
    SID=`echo $RESULTS | sed -e 's,.*<sid>\([^<]*\)<\/sid>.*,\1,g' ` 
    printf "\n"
    echo "SID: $SID"

    SEARCH_STATUS=""
    counter=1000 # will check for status=DONE this many times, every ${wait_seconds}
    wait_seconds=5
    while [ $counter -gt 0 ]
    do
        curl_opts=( "${curl_opts_common[@]}"  "${AUTH_OPTION[@]}"  )
        OUTPUT=`curl "${curl_opts[@]}" -X POST https://${SPLUNK_HOST}/services/search/jobs/${SID}`
        #echo "$OUTPUT"
        STATUS=`echo $OUTPUT | sed -e 's,.*<s:key name=\"dispatchState\">\([^<]*\)<\/s\:key>.*,\1,g' `
        #echo "$STATUS"
        if [[ "$STATUS" = "DONE" ]]; then
            SEARCH_STATUS="DONE"
            #echo "Leaving status loop"
            break 1
        fi
        counter=$(( $counter - 1 ))
        sleep ${wait_seconds}
    done

    if [[ "$SEARCH_STATUS" = "DONE" ]]; then
        curl_opts=( "${curl_opts_common[@]}"  "${AUTH_OPTION[@]}" -d output_mode=csv  )
        SEARCH_RESULTS=`curl "${curl_opts[@]}" -X GET https://${SPLUNK_HOST}/services/search/jobs/${SID}/results`
        echo "$SEARCH_RESULTS" | sed 's/,/ ,/g' | column -t -s, \
        | awk 'NR == 1 {print $0;print $0}; NR > 1 {print $0}' \
        | sed '2 s/[^[:space:]]/-/g'
    fi
}

function build_lookup_search {
    LOOKUP_SEARCH="| rest /services/search/jobs/$1 splunk_server=local
| fields - eai* date_* _raw fieldMetadata*
| rename performance.command.* as *
| rename performance.* as *
| rename request.search as request_search
| fields - request.*s timeliner* workload*
| eval io_limit=\"$2\", search_type=\"$3\", cached=\"$4\"
| table * 
| outputlookup ${5} append=true"

}

function clear_lookup_file {
    splunk_search_polling " search | stats count | where 1==2 | outputlookup ${LOOKUP_FILE} "
}

SID=""
LOOKUP_SEARCH=""

./evict-cache.sh
# DENSE_SEARCH="search index=git earliest=\"01/18/2023:06:00:00\" latest=\"01/18/2023:06:10:00\"
DENSE_SEARCH="search index=git earliest=\"01/18/2023:06:00:00\" latest=\"01/18/2023:22:00:00\"
| spath \"actor.display_login\" 
| stats count by actor.display_login "

SPARSE_SEARCH="search index=git earliest=\"01/18/2023:06:00:00\" latest=\"01/18/2023:22:00:00\" TERM(abcdef) "
#SPARSE_SEARCH="search index=git earliest=\"01/18/2023:06:00:00\" latest=\"01/18/2023:06:10:00\" TERM(abcdef) "


TEST_NAME="100M"
LOOKUP_FILE="search_tests_${TEST_NAME}.csv"

#clear_lookup_file

splunk_search_polling "$DENSE_SEARCH"
echo $SID
build_lookup_search $SID $TEST_NAME dense false $LOOKUP_FILE
echo $LOOKUP_SEARCH
splunk_search_polling "$LOOKUP_SEARCH"

splunk_search_polling "$DENSE_SEARCH"
echo $SID
build_lookup_search $SID $TEST_NAME dense true $LOOKUP_FILE
echo $LOOKUP_SEARCH
splunk_search_polling "$LOOKUP_SEARCH"

#./evict-cache.sh

# splunk_search_polling "$SPARSE_SEARCH"
# echo $SID
# build_lookup_search $SID $TEST_NAME sparse false $LOOKUP_FILE
# echo $LOOKUP_SEARCH
# splunk_search_polling "$LOOKUP_SEARCH"

# splunk_search_polling "$SPARSE_SEARCH"
# echo $SID
# build_lookup_search $SID $TEST_NAME sparse true $LOOKUP_FILE
# echo $LOOKUP_SEARCH
# splunk_search_polling "$LOOKUP_SEARCH"