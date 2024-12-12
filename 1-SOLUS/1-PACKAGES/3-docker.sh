#!/usr/bin/env bash

# Brian Francisco Packages
# 22 Oct 2024

#   《˘ ͜ʖ ˘》

# Assign a color variable based on the RANDOM number
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'

# Cache sudo credentials to avoid repeated password prompts
sudo -v

# Install docker:
sudo eopkg it docker
sudo systemctl start docker.service
sudo systemctl enable docker.service

 ### Install distrobox without root:
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local

#  Create docker user group and add current user to it:
sudo groupadd docker
sudo usermod -aG docker $USER

#  Add these lines to .bashrc so DIstrobox will be in your path and you can run graphical applications:
echo "export PATH="$PATH:$HOME/local/bin"" >> ~/.bashrc
echo "xhost +si:localuser:$USER" >> ~/.bashrc

flatpak install boxbuddy

echo -e "\n\n----------------------------------------------"
echo -e "|                                            |"
echo -e "|               Setup Complete!              |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
