#!/bin/bash
while :;
do
	rsync rsync://sourceware.org/cygwin-ftp/ /mirrorswlzx/cygwin/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
