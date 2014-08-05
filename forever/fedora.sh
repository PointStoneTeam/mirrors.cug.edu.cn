#!/bin/bash
while :;
do
	rsync rsync://dl.fedoraproject.org/fedora-enchilada/linux/ /mirrorsxgxy/fedora/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
