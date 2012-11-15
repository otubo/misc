#!/bin/sh

if [ $# != 3 ]; then
    echo Usage:
    echo     ./bso.sh <hostname> <username> <password>
    echo
    exit 1;
fi

HOST="$1"
USER="$2"
PASSWD="$3"
wget --no-check-certificate https://"$HOST":443/ --post-data="au_pxytimetag=1396696820&uname=$USER&pwd=$PASSWD&ok=OK" -O - 2>/dev/null  | sed -e 's:.*<H1>::g' -e 's:</H1>.*::g' -e 's:<[^>]*>:\n:g' |head -n 3
