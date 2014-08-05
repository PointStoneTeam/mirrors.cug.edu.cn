#!/bin/bash

source $(cd `dirname $0`; pwd)/sync.conf

kill -9 `ps aux | grep sync_main.sh | grep -v "grep sync_main.sh" | awk '{print $2}' | awk '{printf "%s ",$0}'`
kill -9 `ps aux | grep sync_single.sh | grep -v "grep sync_single.sh" | awk '{print $2}' | awk '{printf "%s ",$0}'`
rm -f "$VAR_DIR"*.lock
