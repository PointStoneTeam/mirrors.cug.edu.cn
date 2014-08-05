#!/bin/bash
while :;
do
	rsync rsync://ftp.cn.debian.org/debian-cd/ /mirrorsxgxy/debian-cd/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
