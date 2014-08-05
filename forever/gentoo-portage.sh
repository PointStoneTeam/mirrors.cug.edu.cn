#!/bin/bash
while :;
do
	rsync rsync://ftp.ussg.iu.edu/gentoo-portage/ /mirrorswlzx/gentoo-portage/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
