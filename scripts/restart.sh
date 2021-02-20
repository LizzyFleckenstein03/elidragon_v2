#! /bin/bash
# Elidragon v2 restart script
# Restart worlds, multiserver and mapserver

source scripts/common.sh

case $1 in
	"--all")
		restart_mapserver
		restart_multiserver
		loop_worlds restart_world
		;;
	"--worlds")
		loop_worlds restart_world
		;;
	"mapserver")
		restart_mapserver
		;;
	"multiserver")
		restart_multiserver
		;;
	*)
		restart_world $1
		;;
esac
