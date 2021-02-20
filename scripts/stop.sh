#! /bin/bash
# Elidragon v2 stop script
# Stop worlds, multiserver and mapserver

source scripts/common.sh

case $1 in
	"--all")
		stop_mapserver
		stop_multiserver
		loop_worlds stop_world
		;;
	"--worlds")
		loop_worlds stop_world
		;;
	"mapserver")
		stop_mapserver
		;;
	"multiserver")
		stop_multiserver
		;;
	*)
		stop_world $1
		;;
esac
