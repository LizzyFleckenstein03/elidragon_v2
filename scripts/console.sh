#! /bin/bash
# Elidragon v2 console script
# Attach to the console of a world or multiserver
# Arguments: <worldname>

source scripts/common.sh

if [[ $1 == "--multiserver" ]]; then
	screen -r `multiserver_sceenname`
else
	assert_running $1
	screen -r `world_screenname $1`
fi
