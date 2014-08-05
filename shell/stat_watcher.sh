#!/bin/bash

source $(cd `dirname $0`; pwd)/../sync.conf

STAT_WATCHER_LOCK="$VAR_DIR"stat.watching.lock

if [ -e $STAT_WATCHER_LOCK ] ; then
	LAST_PID=`cat $STAT_WATCHER_LOCK`
	if [ "`ps aux | grep stat_watcher.sh | awk '{print $2}' | grep "$LAST_PID"`" != "" ] ; then
		exit 0
	fi
fi
echo $$ > $STAT_WATCHER_LOCK
chmod 600 $STAT_WATCHER_LOCK

trap "rm -f ${STAT_WATCHER_LOCK}; exit 0" 0 1 2 3 9 15

while true
do
        "$SYNC_ROOT"shell/stat.sh &
        sleep 10s
	if [ "`ps aux | grep sync_main.sh | grep -v "grep sync_main.sh"`" == "" ] ; then
		exit 0
	fi
done
