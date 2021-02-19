#! /bin/bash
# Elidragon v2 restart script
# Restart one or all worlds
# Arguments: [<worldname>]

source source scripts/common.sh

run_one_or_all restart_world $1
