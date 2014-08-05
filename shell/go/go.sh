#!/bin/bash

CURR_DIR="$(cd `dirname $0`; pwd)/"

GO_LOCK="$CURR_DIR"going.lock

if [ -e $GO_LOCK ] ; then
	LAST_PID=`cat $GO_LOCK`
	if [ "`ps aux | grep go.sh | awk '{print $2}' | grep "$LAST_PID"`" != "" ] ; then
        exit 0
    fi
fi
echo $$ > $GO_LOCK
chmod 600 $GO_LOCK

trap "rm -f ${GO_LOCK}; exit 0" 0 1 2 3 9 15

NAME_LIST=go.name.tmp
ls -l /mirrors/logs/ | grep ".access.log" | awk '{print $9}' | awk -F '.' '{print $1}' > $NAME_LIST
NUM=`cat $NAME_LIST | wc -l`
COUNT=1
while [ $COUNT -le $NUM ]
do
    NAME=`sed -n "$COUNT"p $NAME_LIST`
    GO_TMP=/tmp/goaccess/"$NAME".go.tmp
    > $GO_TMP
	goaccess -f /mirrors/logs/"$NAME".access.log -a -H -M --real-os -d > "$GO_TMP"
    COUNT=`expr $COUNT + 1`
	cp $GO_TMP /var/www/html/server/goaccess/"$NAME".html
done

rm -rf /tmp/goaccess/*
