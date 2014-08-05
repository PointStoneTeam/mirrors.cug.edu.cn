#!/bin/bash

source $(cd `dirname $0`; pwd)/../sync.conf

check_times()
{
	if [ -e "$VAR_DIR"times ] ; then
		TIMES=$((`cat "$VAR_DIR"times`+1))
	else
		TIMES=1
	fi
	echo $TIMES > "$VAR_DIR"times
}

check_log()
{
        while [ $MAX_LOG_FILE -lt `ls -l $LOG_DIR | wc -l` ]
        do
                rm "$LOG_DIR`ls -l $LOG_DIR | sed -n 2p | awk '{print $9}'`"
        done
}

check_times
REAL_TIME=`date +%Y-%m-%d-%H-%M-%S`
echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[32mInit\033[0m]Initializing" | tee -a $MAIN_LOG
if [ ! -d "$LOG_DIR" ] ; then
	echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[33mInit\033[0m]Making directory \033[31m\"$LOG_DIR\"\033[0m" | tee -a $MAIN_LOG
	mkdir $LOG_DIR
fi
if [ ! -d "$VAR_DIR" ] ; then
	echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[33mInit\033[0m]Making directory \033[31m\"$VAR_DIR\"\033[0m" | tee -a $MAIN_LOG
	mkdir $VAR_DIR
fi
if [ ! -d "$TMP_DIR" ] ; then
	echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[33mInit\033[0m]Making directory \033[31m\"$TMP_DIR\"\033[0m" | tee -a $MAIN_LOG
	mkdir $TMP_DIR
fi

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mInit\033[0m]Checking for logs" | tee -a $MAIN_LOG
check_log

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mInit\033[0m]Obtaining mirror list" | tee -a $MAIN_LOG
NAME_LIST="$TMP_DIR"name."$TIMES".tmp
if [ $# -eq 0 ] ; then
	grep -v "^#\|^$" "$SYNC_ROOT"sync.conf | grep "(){" | awk -F '(' '{print $1}' > $NAME_LIST
else
	echo $* | sed 's/ /\n/g' > $NAME_LIST
fi
COUNT=1
NUM=`cat $NAME_LIST | wc -l`

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mInit\033[0m]Ready for syncing \033[31m$NUM\033[0m mirror(s)" | tee -a $MAIN_LOG
while [ $COUNT -le $NUM ]
do
	NAME=`sed -n "$COUNT"p $NAME_LIST`
		
	echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mStart\033[0m]Syncing mirror named \033[31m\"$NAME\" $COUNT/$NUM\033[0m" | tee -a $MAIN_LOG
	
	echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mSyncing\033[0m]Logging in \033[31m$LOG_DIR$REAL_TIME.$NAME.log\033[0m" | tee -a $MAIN_LOG
	"$SYNC_ROOT"shell/sync_single.sh $NAME $LOG_DIR$REAL_TIME.$NAME $TIMES
	
	echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mFinished\033[0m]Mirror named \033[31m\"$NAME\"\033[0m has been synced" | tee -a $MAIN_LOG
	COUNT=$(($COUNT+1))
done

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mChecking\033[0m]Terminating" | tee -a $MAIN_LOG
