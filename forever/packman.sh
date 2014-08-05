#!/bin/bash
while :;
do
	rsync rsync://mirrors.hust.edu.cn/packman/ /mirrorswlzx/packman/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
