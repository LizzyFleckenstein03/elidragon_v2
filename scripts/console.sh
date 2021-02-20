#! /bin/bash
# Elidragon v2 console script
# Attach to the screen of a world, multiserver or mapserver

source scripts/common.sh

case $1 in
	"mapserver")
		screen -r `mapserver_screenname`
		;;
	"multiserver")
		screen -r `multiserver_screenname`
		;;
	*)
		screen -r `world_screenname $1`
		;;
esac
