#!/bin/bash
while :;
do
	rsync rsync://mirrors.hustunique.com/remi/ /mirrorswlzx/remi/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
