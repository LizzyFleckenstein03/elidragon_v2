#! /bin/bash
# Elidragon v2 start script
# Start worlds, multiserver and mapserver

source scripts/common.sh

case $1 in
	"--all")
		loop_worlds start_world
		start_multiserver
		start_mapserver
		;;
	"--worlds")
		loop_worlds start_world
		;;
	"mapserver")
		start_mapserver
		;;
	"multiserver")
		start_multiserver
		;;
	*)
		start_world $1
		;;
esac
