# internal functions used by Elidragon v2 scripts

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
		echo "Error: World $1 is not running"
		exit 1
	fi
}

function assert_not_running {
	if is_running $1; then
		echo "Error: World $1 is already running"
		exit 1
	fi
}

function start_world {
	echo "Starting $1..."
	assert_not_running $1

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
}

function stop_world {
	echo "Stopping $1..."
	assert_running $1

	kill_world $1
	rm `world_lock $1`
}

function restart_world {
	echo "Restarting $1..."
	assert_running $1

	kill_world $1
}

function run_one_or_all {
	if [ -z "$2" ]; then
		loop_worlds $1
	else
		$1 $2
	fi
}
