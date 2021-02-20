#! /bin/bash
# Elidragon v2 stop script
# Stop one or all worlds, or if --multiserver is used, the multiserver. If all worlds are stopped, multiserver is stopped as well
# Arguments: [<worldname>]

source scripts/common.sh

if [[ $1 == "--multiserver" || run_one_or_all stop_world $1 ]]; then
	stop_multiserver
fi
