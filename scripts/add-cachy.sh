#!/bin/bash

# This executable script is an easy and convenient way to add Chaotic AUR repository without any hassles . . .

echo ""
# Importing keys from keyserver
echo -e "\033[1mImporting keys from keyserver . . ."
sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman-key --updatedb
echo ""
echo ""

# Importing server mirrors from mirrorlist
echo -e "\033[1mImporting server mirrors from mirrorlist . . ."
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
                           'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo pacman-key --populate
echo ""
echo ""

# Appending Chaotic AUR information to /etc/pacman.conf file
echo -e "\033[1mAppending Chaotic AUR information to /etc/pacman.conf file . . ."
echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -ai /etc/pacman.conf
echo ""
echo ""

# Forcing refresh of package cache file database
echo -e "\033[1mForcing refresh of package cache file database . . ."
echo ""
sudo pacman-db-upgrade
sudo pacman -Syyv --noconfirm
echo ""

# Listing enabled repositories:
echo -e "\033[1m:: List of your enabled repositories:"
sudo pacman-conf -l -v
echo ""

# Retrieving fastest possible mirrors using 'Rate Mirrors'
echo -e "\033[1mRetrieving fastest possible mirrors for Chaotic AUR repository using <Rate Mirrors> . . ."
sudo pacman -S --noconfirm rate-mirrors
sudo rate-mirrors --allow-root chaotic-aur
echo ""
echo -e "Please note that <Rate Mirrors> utility is irrelevant and may show different results each time it is run ..."
echo ""

exit 0
