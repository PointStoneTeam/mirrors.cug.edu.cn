#!/bin/bash
while :;
do
	rsync rsync://kali.mirror.garr.it/kali-security/ /mirrorsxgxy/kali-security/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
