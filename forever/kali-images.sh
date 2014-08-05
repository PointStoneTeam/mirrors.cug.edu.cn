#!/bin/bash
while :;
do
	rsync rsync://kali.mirror.garr.it/kali-images/ /mirrorsxgxy/kali-images/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
