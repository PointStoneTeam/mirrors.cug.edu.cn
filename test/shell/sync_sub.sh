#!/bin/bash
#$1=NAME
#$2=SOURCE
#$3=TARGET
#$4=LOG

source $(cd `dirname $0`; pwd)/../sync.conf

if [ $# != 4 ] ; then
	exit 0
fi

SYNC_SUB_LOCK="$VAR_DIR$1".syncing.sub.lock

if [ -e $SYNC_SUB_LOCK ] ; then
        exit 0
else
        touch $SYNC_SUB_LOCK
        chmod 600 $SYNC_SUB_LOCK
fi

trap "rm -f ${SYNC_SUB_LOCK}; exit 0" 0 1 2 3 9 15

echo `date +%Y-%m-%d\ %H:%M:%S` &>> $4
echo "$2" &>> $4
rsync -avH --delete $2 $3 &>> $4
