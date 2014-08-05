#!/bin/bash
while :;
do
	rsync rsync://archive.ubuntu.com/ubuntu/ /mirrorswlzx/ubuntu/ -aHvh --delete --delete-delay --links --safe-links --stats --times --hard-links --delay-updates
done
