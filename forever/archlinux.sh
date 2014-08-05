#!/bin/bash
while :;
do
	rsync rsync://mirrors.hustunique.com/archlinux/ /mirrorswlzx/archlinux/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
