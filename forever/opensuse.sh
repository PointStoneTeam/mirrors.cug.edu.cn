#!/bin/bash
while :;
do
	rsync rsync://mirrors.hustunique.com/opensuse/ /mirrorswlzx/opensuse/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
