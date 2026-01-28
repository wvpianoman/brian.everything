#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# 27 Jan 2026
#   《˘ ͜ʖ ˘》

# taken from here     https://xanmod.org/#apt_repository

# register PGP Key
wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg

# add the repo
echo "deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/xanmod-release.list

# install dependencies to build external modules (if necessary)
sudo apt install --no-install-recommends dkms libdw-dev clang lld llvm

# update and install
sudo apt update && sudo apt install linux-xanmod-x64v3

# Available kernels
# MAIN 	→ 	linux-xanmod-x64v2 	      linux-xanmod-x64v3
# EDGE 	→ 	linux-xanmod-edge-x64v2   linux-xanmod-edge-x64v3
# LTS 	→   linux-xanmod-lts-x64v1 	  linux-xanmod-lts-x64v2 	 linux-xanmod-lts-x64v3
# RT 	→ 	linux-xanmod-rt-x64v2 	  linux-xanmod-rt-x64v3