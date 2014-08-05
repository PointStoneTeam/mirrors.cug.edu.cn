#!/bin/bash
#$1=NAME
#$2=LOG_PREFIX
#$3=TIMES

source $(cd `dirname $0`; pwd)/../sync.conf

if [ $# != 3 ] ; then
        exit 0
fi

SYNC_SINGLE_LOCK="$VAR_DIR$1".syncing.single.lock

if [ -e $SYNC_SINGLE_LOCK ] ; then
	LAST_PID=`cat $SYNC_SINGLE_LOCK`
	if [ "`ps aux | grep sync_single.sh | awk '{print $2}' | grep "$LAST_PID"`" != "" ] ; then
		exit 0
	fi
fi
echo $$ > $SYNC_SINGLE_LOCK
chmod 600 $SYNC_SINGLE_LOCK

trap "rm -f ${SYNC_SINGLE_LOCK}; exit 0" 0 1 2 3 9 15

$1
TARGET=$destination
NUM=${#source[@]}
COUNT=0
while [ $COUNT -lt $NUM ]
do
	RETRY=1
	while [ $RETRY -le $EACH_SOURCE_MAX_RETRY ]
	do
		LOG=$2.$(($COUNT+1)).$RETRY.log
		"$SYNC_ROOT"shell/sync_sub.sh $1 ${source[$COUNT]} $TARGET $2.$(($COUNT+1)).$RETRY.log &
		SUB_PID=$!
		sleep 3s
		
		echo -e "[\033[33m$3\033[0m][\033[32m`date +%Y-%m-%d\ %H:%M:%S`\033[0m][Source $(($COUNT+1))][Trying $RETRY][From ${source[$COUNT]}][To $TARGET]" | tee -a $MAIN_LOG
		
		TIME=0
		MAX_TIMEOUT=$(($EACH_SOURCE_TIMEOUT*60))
		PRE_STRING=`tail -1 $LOG`
		while [ "`ps aux | grep "$SUB_PID" | grep /sync_sub.sh`" != "" ]
		do
			sleep 5s
			TIME=$(($TIME+5))
			if [ $TIME -ge $MAX_TIMEOUT ] ; then
				CUR_STRING=`tail -1 $LOG`
				if [ "$PRE_STRING" == "$CUR_STRING" ] ; then
					kill -9 $SUB_PID
					rm -f "$VAR_DIR$1".syncing.sub.lock
				else
					PRE_STRING=$CUR_STRING
				fi
				TIME=0
			fi
		done
		"$SYNC_ROOT"shell/stat.sh
		STATUS=`cat "$VAR_DIR"stat | grep ^$1\| | awk -F '|' '{print $6}'`
		if [ "$STATUS" == "finished" ] ; then
			RETRY=$EACH_SOURCE_MAX_RETRY
			echo -e "[\033[33m$3\033[0m][\033[32m`date +%Y-%m-%d\ %H:%M:%S`\033[0m]The result is \033[32mfinished\033[0m" | tee -a $MAIN_LOG
		else
                        echo -e "[\033[33m$3\033[0m][\033[32m`date +%Y-%m-%d\ %H:%M:%S`\033[0m]The result is \033[33mNOT finished yet\033[0m" | tee -a $MAIN_LOG
		fi
		ERR_NUM=${#SKIP_ERRORS[@]}
		TEST_COUNT=0
		while [ $TEST_COUNT -lt $ERR_NUM ]
		do
			if [ "`tail -1 $LOG | grep "${SKIP_ERRORS[$TEST_COUNT]}"`" != "" ] ; then
				RETRY=$EACH_SOURCE_MAX_RETRY
				break
			else
				TEST_COUNT=$(($TEST_COUNT+1))
			fi
		done
		RETRY=$(($RETRY+1))
	done
	if [ "$STATUS" == "finished" ] ; then
		COUNT=$NUM
	fi
	COUNT=$(($COUNT+1))
done
