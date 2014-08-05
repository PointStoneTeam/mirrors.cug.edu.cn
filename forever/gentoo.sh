#!/bin/bash
while :;
do
	rsync rsync://rsync.cn.gentoo.org/gentoo/ /mirrorswlzx/gentoo/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
