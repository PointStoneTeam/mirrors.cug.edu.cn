#!/bin/bash

source $(cd `dirname $0`; pwd)/../sync.conf

STAT_LOCK="$VAR_DIR"stating.lock

if [ -e $STAT_LOCK ] ; then
        exit 0
else
        touch $STAT_LOCK
        chmod 600 $STAT_LOCK
fi

trap "rm -f ${STAT_LOCK}; exit 0" 0 1 2 3 9 15

STAT_FILE="$VAR_DIR"stat
STAT_BUFFER="$TMP_DIR"stat.tmp

LAST_STAT=`cat $STAT_FILE`
> $STAT_BUFFER
NAME_LIST="$TMP_DIR"name.tmp
grep -v "^#\|^$" "$SYNC_ROOT"sync.conf | grep "(){" | awk -F '(' '{print $1}' > $NAME_LIST
NUM=`cat $NAME_LIST | wc -l`
COUNT=1
while [ $COUNT -le $NUM ]
do
        NAME=`sed -n "$COUNT"p $NAME_LIST`
        alias=""
	$NAME
	if [ "$alias" == "" ] ; then
		ALIAS=$NAME
	else
		ALIAS=$alias
	fi
	LOG_FILE=$LOG_DIR`ls -l $LOG_DIR | grep "\.$NAME\." | tail -1 | awk '{print $9}'`
	if [ "$LOG_FILE" == "$LOG_DIR" ] ; then
                COUNT=`expr $COUNT + 1`
                continue
        fi
	SOURCE=`sed -n 2p $LOG_FILE`
        START_TIME=`head -1 $LOG_FILE`
        END_TIME=`stat -c %y $LOG_FILE | awk -F '.' '{print $1}'`
        TAIL=`tail -1 $LOG_FILE`
        SYNC_LOCK="$VAR_DIR""$NAME".syncing.sub.lock
	if [ "`echo $TAIL | grep "total size"`" != "" ] ; then
                STATUS=finished
                SIZE=`echo $TAIL | awk '{print $4}'`
        elif [ "`echo $TAIL | grep "rsync error"`" != "" ] ; then
                STATUS=error
                SIZE=`echo $LAST_STAT | grep "^$NAME\|" | awk -F '|' '{print $2}'`
        elif [ -e $SYNC_LOCK ] ; then
                STATUS=syncing
                SIZE=`echo $LAST_STAT | grep "^$NAME\|" | awk -F '|' '{print $2}'`
        else
                STATUS=error
                SIZE=`echo $LAST_STAT | grep "^$NAME\|" | awk -F '|' '{print $2}'`
        fi
        echo "$NAME|$SIZE|$SOURCE|$START_TIME|$END_TIME|$STATUS" &>> $STAT_BUFFER
        COUNT=`expr $COUNT + 1`
done

cp $STAT_BUFFER $STAT_FILE
