#!/bin/bash

source $(cd `dirname $0`; pwd)/../sync.conf

STAT_WATCHER_LOCK="$VAR_DIR"stat.watching.lock

if [ -e $STAT_WATCHER_LOCK ] ; then
        exit 0
else
        touch $STAT_WATCHER_LOCK
        chmod 600 $STAT_WATCHER_LOCK
fi

trap "rm -f ${STAT_WATCHER_LOCK}; exit 0" 0 1 2 3 9 15

while true
do
        "$SYNC_ROOT"shell/stat.sh &
        sleep 10s
done
