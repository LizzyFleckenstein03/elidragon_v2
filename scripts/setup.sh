#! /bin/bash
# Elidragon v2 setup script
# Install everything needed by the server

# Initialize submodules
git submodule init
git submodule update

# Add apt repo to always get the lastest MT release
sudo add-apt-repository ppa:minetestdevs/stable
sudo apt-get update -y

# Install minetest and screen
sudo apt install minetest screen -y

# Install multiserver and its dependencies
go get github.com/HimbeerserverDE/multiserver

# Download & install mapserver (disabled for now)
# cd worlds/creative/
# curl -s https://api.github.com/repos/minetest-mapserver/mapserver/releases/latest | grep "mapserver-linux-x86_64" | cut -d : -f 2,3 | tr -d \" | wget -qi -
# chmod +x mapserver-linux-x86_64
# cd ../..
