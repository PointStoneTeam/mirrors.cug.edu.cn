#!/bin/bash
while :;
do
	rsync rsync://archive.raspbian.org/archive/ /mirrorswlzx/raspbian/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
