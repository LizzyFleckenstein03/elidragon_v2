# common functions used by Elidragon v2 scripts

function world_lock {
	echo "/tmp/ElidragonV2_$1_lock"
}

function multiserver_lock {
	echo "/tmp/ElidragonV2_Multiserver_lock"
}

function world_screenname {
	echo "Elidragon v2 - $1"
}

function multiserver_screenname {
	echo "Elidragon v2 - Multiserver"
}

function kill_world {
	kill `cat \`world_lock $1\``
}

function kill_multiserver {
	kill -2 `cat \`multiserver_lock\``
}

function world_running {
	return $([ -f `world_lock $1` ])
}

function multiserver_running {
	return $([ -f `multiserver_lock` ])
}

function assert_running {
	if ! world_running $1; then
		echo -e "\e[31mWorld $1 is not running\e[0m"
		if [ -z $2 ]; then
			exit 1
		else
			return 1
		fi
	fi
}

function assert_not_running {
	if world_running $1; then
		echo -e "\e[31mWorld $1 is already running\e[0m"
		if [ -z $2 ]; then
			exit 1
		else
			return 1
		fi
	fi
}

function loop_worlds {
	WORLDS=`ls worlds`
	for WORLD in $WORLDS; do
		$1 $WORLD
	done
}

function run_one_or_all {
	if [ -z $2 ]; then
		loop_worlds $1
		return 0
	else
		$1 $2
		return 1
	fi
}

function run_in_screen {
	screen -dmS $1 bash -c "
		touch $2
		while [ -f $2; ] do
			bash -c \"
				echo \\$\\$ > $2
				exec $3
			\"
		done
	"
}

function start_multiserver {
	echo -n "Starting Multiserver... "
	if multiserver_running; then
		echo -e "\e[31mMultiserver is already running\e[0m"
	else
		run_in_screen `multiserver_screenname` `multiserver_lock` "~/go/bin/multiserver"
		echo -e "\e[32mDone\e[0m"
	fi
}

function stop_multiserver {
	echo -n "Stopping Multiserver... "
	if multiserver_running; then
		kill_multiserver
		rm `multiserver_lock`

		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mMultiserver is not running\e[0m"
	fi
}

function restart_multiserver {
	echo -n "Multiserver..."
	if multiserver_running; then
		kill_multiserver

		echo -e "\e[32mDone\e[0m"
	else
		echo -e "\e[31mMultiserver is not running\e[0m"
	fi
}

function start_world {
	echo -n "Starting $1... "
	if assert_not_running $1 "true"; then
		run_in_screen `world_screenname $1` `world_lock $1` "minetest --server --terminal --world worlds/$1 --config worlds/$1/minetest.conf --logfile worlds/$1/debug.txt"
		echo -e "\e[32mDone\e[0m"
	fi
}

function stop_world {
	echo -n "Stopping $1..."
	if assert_running $1 "true"; then
		kill_world $1
		rm `world_lock $1`

		echo -e "\e[32mDone\e[0m"
	fi
}

function restart_world {
	echo -n "Restarting $1..."
	if assert_running $1 "true"; then
		kill_world $1

		echo -e "\e[32mDone\e[0m"
	fi
}
