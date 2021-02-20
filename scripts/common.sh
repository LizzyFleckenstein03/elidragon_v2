# common functions used by Elidragon v2 scripts

function world_lock {
	echo "/tmp/ElidragonV2_$1_lock"
}

function world_screenname {
	echo "Elidragon v2 - $1"
}

function kill_world {
	kill `cat \`world_lock $1\``
}

function is_running {
	return $(test -f `world_lock $1`)
}

function loop_worlds {
	WORLDS=`ls worlds`
	for WORLD in $WORLDS; do
		$1 $WORLD
	done
}

function assert_running {
	if ! is_running $1; then
		echo -e "\e[31mWorld $1 is not running\e[0m"
		if [ -z "$2" ]; then
			exit 1
		else
			return 1
		fi
	fi
}

function assert_not_running {
	if is_running $1; then
		echo -e "\e[31mWorld $1 is already running\e[0m"
		if [ -z "$2" ]; then
			exit 1
		else
			return 1
		fi
	fi
}

function start_world {
	echo -n "Starting $1... "
	if assert_not_running $1 "true"; then
		LOCK=`world_lock $1`

		screen -dmS `world_screenname $1` bash -c "
			while is_running $1; do
				bash -c \"
					echo \\$\\$ > $LOCK
					exec minetest --server --terminal --world worlds/$1 --config worlds/$1/minetest.conf --logfile worlds/$1/debug.txt 
				\"
			done
			rm $LOCK
		"

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

function run_one_or_all {
	if [ -z "$2" ]; then
		loop_worlds $1
	else
		$1 $2
	fi
}
