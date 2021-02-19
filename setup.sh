#! /bin/bash
# Setup script for the Elidragon v2 server

# Install latest minetest release
add-apt-repository ppa:minetestdevs/stable
apt-get update
apt install minetestserver

# Install multiserver
go get github.com/HimbeerserverDE/multiserver
