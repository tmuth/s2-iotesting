#!/bin/bash
DEVICE=${1:-md0}
echo "iostats for device: ${DEVICE}"

red='\033[01;31m'
none='\033[0m' 

# Use the following block to find the column numbers:
# iostat ${DEVICE} -xd -m 1 1 | \
# awk 'BEGIN{ FS=" " }
#      { if ( $1 ~ /Device/ ) {for(fn=1;fn<=NF;fn++) {print fn" = "$fn;}; exit;} }'

# writes: $1,$8,$9,$12,$13,$23
# reads: $1,$2,$3,$6,$7,$23
iostat ${DEVICE} -xd -m 1 | \
 gawk -v r="$red" -v n="$none" -v dev="${DEVICE}" '  { if ( ($1 ~ dev && NR >= 5) || ( NR==3 && $1 ~ /Device/ ) ) { sub("Device"," ",$1) ;  sub(dev,strftime("[%Y-%m-%d %H:%M:%S]"),$1) ; \
    printf("%-25s %10s " r "%10s" n "%12s %9s %6s\n",$1,$2,$3,$6,$7,$23)}}'

