#! /bin/bash
# Elidragon v2 start script
# Start worlds, multiserver and mapserver

source source scripts/common.sh

case $1 in
	"--all"
		start_mapserver
		start_multiserver
		loop_worlds start_world
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
