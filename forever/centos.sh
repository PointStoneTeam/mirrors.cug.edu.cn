#!/bin/bash
while :;
do
	rsync rsync://us-msync.centos.org/CentOS/ /mirrorswlzx/centos/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
