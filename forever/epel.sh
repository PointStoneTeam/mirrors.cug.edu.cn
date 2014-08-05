#!/bin/bash
while :;
do
	rsync rsync://dl.fedoraproject.org/fedora-epel/ /mirrorswlzx/epel/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
