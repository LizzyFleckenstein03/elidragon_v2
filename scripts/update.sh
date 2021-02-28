#! /bin/bash
# Elidragon v2 update script
# Update all software used by the server

# Pull repository
git pull

# Update submodules
git submodule init
git submodule update
git submodule foreach "git fetch origin; git checkout $(git rev-parse --abbrev-ref HEAD); git reset --hard origin/$(git rev-parse --abbrev-ref HEAD); git submodule update --recursive; git clean -dfx"

# Update minetest and screen
sudo apt-get update -y
sudo apt-get install minetest screen -y

# Update multiserver
go get -u github.com/HimbeerserverDE/multiserver
