#! /bin/bash
# Elidragon v2 console script
# Attach to the console of a world
# Arguments: <worldname>

source scripts/common.sh

assert_running $1
screen -r `world_screenname $1`
