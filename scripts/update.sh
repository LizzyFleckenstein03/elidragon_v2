#! /bin/bash
# Elidragon v2 update script
# Update all software used by the server

# Pull repository
git pull --recurse-submodules

# Update minetest and screen
sudo apt-get update -y
sudo apt-get install minetest screen -y

# Update multiserver
go get -u github.com/HimbeerserverDE/multiserver
