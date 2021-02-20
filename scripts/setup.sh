#! /bin/bash
# Elidragon v2 setup script
# Install everything needed by the server

# Initialize submodules
git submodule update --recursive --remote

# Add apt repo to always get the lastest MT release
sudo add-apt-repository ppa:minetestdevs/stable
sudo apt-get update -y

# Install minetest and screen
apt install minetest screen -y

# Install multiserver and its dependencies
go get github.com/HimbeerserverDE/multiserver
