#!/bin/bash
while :;
do
	rsync rsync://download1.rpmfusion.org/rpmfusion /mirrorswlzx/rpmfusion/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
