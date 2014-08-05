#!/bin/bash
while :;
do
	rsync rsync://packages.linuxmint.com/packages/ /mirrorsxgxy/linuxmint/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
