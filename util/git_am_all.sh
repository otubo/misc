#!/usr/bin/env bash
#
# Apply a series of patches in a local reposiotory, please
# change ACTION as your wish.
#
# Usage:
#  $ ./git_am.sh 0001 0010 /path/to/patchset
#

if [ $# != 3 ]; then
    echo Usage:
    echo     ./git_am.sh 0001 0010 /path/to/patchset
    echo
    exit 1;
fi

SEQ=`which seq`;
GIT=`which git`;
FIRST=$1;
LAST=$2;
PATCHES=$3;
ACTION="$GIT am --skip"

for i in `$SEQ -w $FIRST $LAST`; do 
    patch=`ls $PATCHES$i*`;
    echo -n ">> $i -- ";

    $GIT am $patch;

    if [ $? == 0 ]; then 
        continue;
    else 
        `$ACTION`;
    fi
done
