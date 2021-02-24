# **Elidragon v2 Server software documentation**
---

This repositiory contains everything required to run the Elidragon v2  Minetest server. Elidragon v2 is the sequel to Elidragon Skyblock and is reusing Skycraft code to a large degree.

This documentation is meant for people who have to deal with the Elidragon v2 server in the future. I don't plan to quit the admin/developer team, but who knows what happens in the future. Maybe I change my mind or are temporary unreachable. I don't want to leave burned soil behind, like I did with the Elidragon Skyblock server. Fortunately today's admins of this server are mostly my IRL friends and therefore easily able to reach me. This documentation was not written to give people the possibility to create a Elidragon v2 ripoff. You can do that, but it is discouraged. The server software is Open Source because I believe that users should have the possibility to read and contribute to the software they are using, even if it is backend software. If you reuse parts of the code in this reop or fork it and build your own server on top of it, I am perfectly fine with that, but I ask you to not just install my software on your own server and possibly take away users from my server using my own software. It will not have any legal consequences if you do, but I politely ask you to not do it.

The goal of Elidragon v2 is to provide a server similar to popular Minecraft servers: When joining a network, you are moved to a lobby, and from there players can select which gamemode they want to play (e.g. Creative, Survival, Skyblock or Minigames) and are automatically connected to the proper server, whithout having to rejoin the server by any means. Players can get anything they want within one network and can easily switch between gamemodes and make progress in different worlds.

Minetest does not support "server-hopping" natively; therefore the multiserver proxy (https://github.com/HimbeerserverDE/multiserver) written in Go by HimbeerserverDE is used. multiserver depends on mt rudp (https://github.com/anon55555/mt) by anon55555.

For the creative map, minetest mapserver is used.

Elidragon v2 runs on top of the latest git version of MineClone2, and the lastest stable release of minetest.


### Quick guide for installation and running
---

Elidragon v2 requires a GNU/Linux x86_64 system to run. The setup and update scripts rely on apt and sudo. Go 1.15 or higher is required. The ports 33000, 30030, 30031, 30032, 30033 and 8080 need to be open.

1. Create a new user using adduser and switch to it. The user should be able to use sudo.
1. git clone this repository into that user's home directory and rename it to .minetest
1. cd into .minetest
1. run scripts/setup.sh - this will automatically install minetest and screen. Also, it initialized the submodules - all external mods and MineClone2 are installed automatically. It will also install multiserver and its dependencies.
1. run scripts/start.sh --all - this will automatically start all worlds, multiserver and mapserver. If one world or multiserver / mapserver crashes or shuts down it will automatically restarted.

To update, run scripts/update.sh, to restart all worlds run scripts/restart.sh --worlds and to stop all worlds and multiserver run scripts/stop.sh --all.

### Organisation structure
---

The idea is that once the repository is clones onto the server, it contains all code and configuration files needed to run. Even the worlds are part of the repo, but the only files that get tracked by git are the world.mt and minetest.conf (every world has its own minetest.conf and debug.txt). All other files in each world directory will simply be ignored (.gitignore), so none of the databases etc. can be found in the git repository. You are not meant to change ANYTHING in the repo directly (except of course e.g. databases, if it is needed - basically you should only change files that are not tracked by git). If you want to change anything, including configuations, change it in your local installation of Elidragon v2, test and commit it, then push it to the github repository. Afterwards run git pull --recurse-submodules on the server and restart all worlds. (The latter two tasks are automated; See the Scripts section). It is recommended to just use the repository as the .minetest directory. If not used as .minetest directory it will run fine as well, but you'll have to install MineClone2 seperately. However, you are not meant to manually start any worlds; if you have to, you HAVE to, make sure you hand the minetestserver worldpath (worlds/<world>), logfile (worlds/<world>/debug.txt) and configuration file (worlds/<world>/minetest.conf). Usually the start script should be used to start one or all worlds.


### Scripts
---

For many tasks it is recommended to use the scripts from the scripts/ directory. All scripts need to be run from the root path of this repository.

scripts/setup.sh: This will install minetest and screen using sudo apt. For minetest a apt repository is added that is up to date (the official repos are often one or two versions behind). It will use go to install multiserver and mapserver, also it will init and update the submodules, which is very important because all external mods are added as submodules.

scripts/update.sh: This will pull the repository including all submodules. Also, it will update minetest, screen and multiserver.

scripts/start.sh <worldname> | multiserver | mapserver | --all | --worlds: You can use this to start one or all worlds from the worlds folder, or the mapserver / multiserver. When --all is used it will start everything, --worlds starts all worlds. You can use --all or --world even if some tasks that would be started by it are already running. All tasks will be started in a hidden screen and restarted when killed, shut down using /shutdown or they crash. Any started task will have a lock file in the /tmp directory that contains the PID of the current process. When the task is stopped, the lock file is deleted.

scripts/stop.sh <worldname> | multiserver | mapserver | --all | --worlds: You can use this to stop one or all worlds from the worlds folder or the mapserver / multiserver started using the start script. When --all is used it will stop everything, --worlds stops all worlds. You can use --all or --world even if some tasks that would be stopped by it are not running.

scripts/restart.sh <worldname> | multiserver | mapserver | --all | --worlds: You can use this to restart one or all worlds from the worlds folder or the mapserver / multiserver started using the start script. When --all is used it will restart everything, --worlds restarts all worlds. You can use --all or --world even if some tasks that would be restarted by it are not running - only the running tasks will be restarted.

scripts/console.sh <worldname> | multiserver | mapserver: You can used this to access the console of the world specified in the argument (minetest --terminal running in a screen). If multiserver / mapserver is used, the multiserver / mapserver output will be shown (in real-time).

scripts/common.sh: This script should not be started, it contains common functions imported by other scripts. You can modify it to e.g. change the paths of lock files or screen names.

### Creating new mods
---

If you create a new mod, create a folder mods/elidragon_<name>. It should have a mod.conf containing its name, a small description and your name. It should depend on the elidragon mod and all other mods it needs. Any dependenency (that is not already in the repo or in MineClone2) needs to be added as submodule. It should add a <name> table to the elidragon namespace e.g.

```lua
local testing = {}
   
function testing.test()
   print("test")
end

elidragon.testing = testing
```

When using more than one function from the same other elidragon_ mod, you should import it by doing local othermod = elidragon.othermod at the beginning of the file. All code should be inside init.lua, and don't be scared of creating multiple mods at once - the system is meant to be as modular as possible. After you created the mod, you have to complete the steps for Adding existing mods (except adding the submodule ofc).

### Adding existing mods
---

If you want to add an external mod, cd to the mods directory and type git submodule add <git repo of external mod>.
For any new mod an entry needs to be added to all world.mt files, saying load_mod_xy = true / false. This is important because if you do not specify load_mod_xy, Minetest will automatically add it, and we do not want minetest to mess with files added to git.

### Adding new worlds
---

If you want to add a new world, add a folder to the worlds/directory. Then, create .gitignore, world.mt and minetest.conf in that directory. .gitignore needs to contain * to ignore everything, and !minetest.conf and !world.mt to include these two. minetest.conf and world.mt need to be created and filled, world.mt needs to contain load_mod_xy = true / false for every added mod, see the Adding existing mods section for that. Also, world.mt needs to contain database settings for map, players and auth data and settings to enable / disable creative mode and damage. Each world also has it's own configuration file. The concept for worlds and mods is that some mods are for one world only e.g. the skyblock mod for the skyblock world, and some are shared. Make sure that each world has the mods enabled that the enabled mods depend on. Every world needs to have a port specified in the config file and needs to be added to the multiserver configuration. Only the lobby server is supposed to announce to the server list and should announce the port multiserver is running on.
