#!/bin/bash
while :;
do
	rsync rsync://rsync.apache.org/apache-dist/ /mirrorswlzx/apache/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
