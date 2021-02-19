#! /bin/bash
# Elidragon v2 stop script
# Stop one or all worlds
# Arguments: [<worldname>]

source scripts/internal.sh

run_one_or_all stop_world $1
