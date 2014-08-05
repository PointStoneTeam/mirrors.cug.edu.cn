#!/bin/bash
while :;
do
	rsync rsync://mirror.team-cymru.org/gnu/ /mirrorswlzx/gnu/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
