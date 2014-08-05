#!/bin/bash
while :;
do
	rsync rsync://ftp.heanet.ie/pub/linuxmint.com/ /mirrorsxgxy/linuxmint-cd/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
