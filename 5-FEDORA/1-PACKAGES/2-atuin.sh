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

### Install Atuin - Shell History Replacement
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# 1st run register acct with this line
# atuin register
# run on another machine, use this to login
atuin login
atuin import auto
atuin sync
