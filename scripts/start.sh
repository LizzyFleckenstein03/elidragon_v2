#! /bin/bash
# Elidragon v2 start script
# Start one or all worlds, or if --multiserver is used, the multiserver. If all worlds are started, multiserver is started as well
# Arguments: [<worldname>]

source source scripts/common.sh

if [ $1 = "--multiserver" ] || run_one_or_all start_world $1; then
	start_multiserver
fi
