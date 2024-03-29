# common functions used by Elidragon v2 scripts

function world_lock {
	echo "/tmp/ElidragonV2_$1_lock"
}

function multiserver_lock {
	echo "/tmp/ElidragonV2_multiserver_lock"
}

function mapserver_lock {
	echo "/tmp/ElidragonV2_mapserver_lock"
}

function world_screenname {
	echo "ElidragonV2_$1"
}

function multiserver_screenname {
	echo "ElidragonV2_multiserver"
}

function mapserver_screenname {
	echo "ElidragonV2_mapserver"
}

function kill_world {
	kill `cat \`world_lock $1\``
}

function kill_multiserver {
	kill -2 `cat \`multiserver_lock\``
}

function kill_mapserver {
	kill `cat \`mapserver_lock\``
}

function world_running {
	return $([ -f `world_lock $1` ])
}

function multiserver_running {
	return $([ -f `multiserver_lock` ])
}

function mapserver_running {
	return $([ -f `mapserver_lock` ])
}

function loop_worlds {
	WORLDS=`ls worlds`
	for WORLD in $WORLDS; do
		$1 $WORLD
	done
}

function run_in_screen {
	screen -dmS $1 bash -c "
		touch $2
		while [ -f $2 ]; do
			bash -c \"
				echo \\$\\$ > $2
				exec $3
			\"
		done
	"
}

function start_mapserver {
	echo -n "Starting mapserver... "
	if ! mapserver_running; then
		cd worlds/creative
		while ! [ -f map.sqlite ]; do
			sleep 0.1
		done
		run_in_screen `mapserver_screenname` `mapserver_lock` "./mapserver-linux-x86_64"
		cd ../..
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mmapserver is already running\e[0m"
	fi
}

function stop_mapserver {
	echo -n "Stopping mapserver... "
	if mapserver_running; then
		kill_mapserver
		rm `mapserver_lock`
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mmapserver is not running\e[0m"
	fi
}

function restart_mapserver {
	echo -n "Restarting mapserver... "
	if mapserver_running; then
		kill_mapserver
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mmapserver is not running\e[0m"
	fi
}

function start_multiserver {
	echo -n "Starting multiserver... "
	if ! multiserver_running; then
		run_in_screen `multiserver_screenname` `multiserver_lock` "~/go/bin/multiserver"
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mmultiserver is already running\e[0m"
	fi
}

function stop_multiserver {
	echo -n "Stopping multiserver... "
	if multiserver_running; then
		kill_multiserver
		rm `multiserver_lock`
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mmultiserver is not running\e[0m"
	fi
}

function restart_multiserver {
	echo -n "Restarting multiserver... "
	if multiserver_running; then
		kill_multiserver
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mmultiserver is not running\e[0m"
	fi
}

function start_world {
	echo -n "Starting $1... "
	if ! world_running $1; then
		run_in_screen `world_screenname $1` `world_lock $1` "minetest --server --terminal --world worlds/$1 --config worlds/$1/minetest.conf --logfile worlds/$1/debug.txt"
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31m$1 is already running\e[0m"
	fi
}

function stop_world {
	echo -n "Stopping $1... "
	if world_running $1; then
		kill_world $1
		rm `world_lock $1`
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31m$1 is not running\e[0m"
	fi
}

function restart_world {
	echo -n "Restarting $1... "
	if world_running $1; then
		kill_world $1
		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31m$1 is not running\e[0m"
	fi
}
