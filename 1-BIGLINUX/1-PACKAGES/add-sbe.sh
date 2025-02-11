#!/bin/bash

#This scippt adds Sierra Breeze Enhanced windows decorations to Plasma 6

git clone https://aur.archlinux.org/kwin-decoration-sierra-breeze-enhanced-git.git
cd kwin-decoration-sierra-breeze-enhanced-git
makepkg -si
cd ..
rm -rf kwin-decoration-sierra-breeze-enhanced-git
