#!/bin/bash
while :;
do
	rsync rsync://mirrors.hust.edu.cn/sagemath/ /mirrorswlzx/sagemath/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
