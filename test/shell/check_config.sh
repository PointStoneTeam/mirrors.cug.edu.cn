#!/bin/bash

source $(cd `dirname $0`; pwd)/../sync.conf

CHECK_LOCK="$VAR_DIR"checking.lock

if [ -e $CHECK_LOCK ] ; then
        exit 0
else
        touch $CHECK_LOCK
        chmod 600 $CHECK_LOCK
fi

trap "rm -f ${CHECK_LOCK}; exit 0" 0 1 2 3 9 15

CONF=$(cd `dirname $0`; pwd)/../sync.conf
KEYWORDS=$(cd `dirname $0`; pwd)/keywords

NUM=`cat $KEYWORDS | wc -l`
COUNT=1
while [ $COUNT -le $NUM ]
do
	WORD=`sed -n "$COUNT"p $KEYWORDS`
	DETAIL=`grep ^$WORD $CONF | grep -v =$`
	if [ "$DETAIL" == "" ] ; then
		echo -e "[Check Config][\033[31mError\033[0m][Parameter \033[31m\"$WORD\"\033[0m undefined]"
	else
		echo -e "[Check Config][\033[32mPass\033[0m][Parameter defined \033[32m\"$DETAIL\"\033[0m]"
	fi
	COUNT=$(($COUNT+1))
done
