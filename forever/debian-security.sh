#!/bin/bash
while :;
do
	rsync rsync://security.debian.org/debian-security/ /mirrorsxgxy/debian-security/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
