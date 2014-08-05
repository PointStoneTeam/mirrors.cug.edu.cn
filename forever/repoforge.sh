#!/bin/bash
while :;
do
	rsync rsync://ftp.riken.jp/repoforge/ /mirrorswlzx/repoforge/ -aHvh --delete --delete-delay --stats --safe-links --timeout=120 --contimeout=120 --delay-updates
done
