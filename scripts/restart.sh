#! /bin/bash
# Elidragon v2 restart script
# Restart worlds, multiserver and mapserver

source scripts/common.sh

case $1 in
	"--all")
		loop_worlds restart_world
		restart_multiserver
		restart_mapserver
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
