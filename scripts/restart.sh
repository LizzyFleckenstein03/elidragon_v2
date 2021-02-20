#! /bin/bash
# Elidragon v2 restart script
# Restart one or all worlds, or if --multiserver is used, the multiserver. If all worlds are restarted, multiserver is restarted as well
# Arguments: [<worldname> | --multiserver]

source source scripts/common.sh

if [[ $1 == "--multiserver" || run_one_or_all restart_world $1 ]]; then
	restart_multiserver
fi
