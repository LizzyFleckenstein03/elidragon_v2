#! /bin/bash
# Update script for the Elidragon v2 server

# Update this repo, also update submodules
git pull --recurse-submodules

# Update minetest and screen
apt-get update -y
apt-get upgrade minetest screen -y

# Update multiserver
go get -u github.com/HimbeerserverDE/multiserver
