#!/bin/bash
while :;
do
	rsync rsync://rsync.osuosl.org/eclipse/ /mirrorsxgxy/eclipse/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
