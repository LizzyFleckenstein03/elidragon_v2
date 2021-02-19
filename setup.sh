#! /bin/bash
# Setup script for the Elidragon v2 server

# Initialize submodules
git submodule update --recursive --remote

# Add apt repo to always get the lastest MT release
add-apt-repository ppa:minetestdevs/stable
apt-get update -y

# Install minetest and screen
apt install minetest screen -y

# Install multiserver
go get github.com/HimbeerserverDE/multiserver
