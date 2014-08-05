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
	LAST_PID=`cat $SYNC_SUB_LOCK`
	if [ "`ps aux | grep sync_sub.sh | awk '{print $2}' | grep "$LAST_PID"`" != "" ] ; then
		exit 0
	fi
fi
echo $$ > $SYNC_SUB_LOCK
chmod 600 $SYNC_SUB_LOCK

trap "rm -f ${SYNC_SUB_LOCK}; exit 0" 0 1 2 3 9 15

echo `date +%Y-%m-%d\ %H:%M:%S` &>> $4
echo "$2" &>> $4
rsync -avH --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates $2 $3 &>> $4
