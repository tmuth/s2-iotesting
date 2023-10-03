red='\033[01;31m'
none='\033[0m' 
 # gawk '{if($1 ~ /xvda/) {printf("%s","foo")} else printf("%s","bar")} {if((NR==3 && $1 ~ /Device/) || $1 ~ /xvda/ ) printf("%-25s %-10s %-10s %-8s %-9s %-6s\n",strftime("[%Y-%m-%d %H:%M:%S]"),$8,$9,$12,$13,$23)}'
 #
 iostat xvda -xd -m 1 | \
 gawk -v r="$red" -v n="$none" '  { if ( $1 ~ /xvda/ || ( NR==3 && $1 ~ /Device/ ) ) { sub("Device"," ",$1) ;  sub("xvda",strftime("[%Y-%m-%d %H:%M:%S]"),$1) ; \
    printf("%-25s %10s " r "%10s" n "%12s %9s %6s\n",$1,$8,$9,$12,$13,$23)}}'