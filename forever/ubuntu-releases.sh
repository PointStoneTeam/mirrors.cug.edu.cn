#!/bin/bash
while :;
do
	rsync rsync://rsync.releases.ubuntu.com/releases/ /mirrorswlzx/ubuntu-releases/ -aHvh --delete --delete-delay --links --safe-links --stats --times --hard-links --delay-updates
done
