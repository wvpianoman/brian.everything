#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Jul 11 2025
#   《˘ ͜ʖ ˘》

# Install some software:

sudo apt install nala -y

echo -e "Installing packages not in repo..."
sleep 3

# sublime-text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources

#plank-reloaded
# Add the repository
curl -fsSL https://zquestz.github.io/ppa/ubuntu/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/zquestz-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/zquestz-archive-keyring.gpg] https://zquestz.github.io/ppa/ubuntu ./" | sudo tee /etc/apt/sources.list.d/zquestz.list
sudo apt update && sudo nala update

# GhostWriter
sudo add-apt-repository ppa:wereturtle/ppa
sudo apt update && sudo nala update

#Install gum : A tool for glamorous shell scripts. https://github.com/charmbracelet/gum

curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

# onlyoffice
mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg

echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list

# grub-customizer
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt-get update
sudo apt-get install grub-customizer

# gcalendar
sudo add-apt-repository ppa:slgobinath/gcalendar
sudo apt update && sudo nala update

# fish shell
sudo add-apt-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish

sudo apt update && sudo nala update && sudo nala install -y onlyoffice-desktopeditors onlyoffice-desktopeditors-help gum sublime-text fonts-crosextra-caladea plank-reloaded ghostwriter gcalendar 

echo -e "Installing Packages in Repo"
sleep 3

sudo nala install -y yad espeak espeak-ng fancontrol figlet fortune-mod fortunes fortunes-min uget hardinfo thefuck ocrmypdf ocrmypdf-doc pdfsandwich meld acl aria2 attr autoconf automake bash-completion bc binutils btop ca-certificates cifs-utils libcjson1 codec2 cookietool cowsay cron curl gir1.2-dbusglib-1.0 dconf-editor dialog direnv dnsutils duf easyeffects mbpfan fd-find ffmpeg ffmpegthumbnailer ffmpegthumbs flatpak gdebi git gnupg2 grep yaru-cinnamon-theme-{gtk,icon} sox zenity synaptic lolcat vnstati

sudo nala install -y haveged ibus-gtk4 jq lsd make ublock-origin-doc webext-ublock-origin-firefox mpg123 nano snmpd net-tools nftables openssh-{client,server} ostree p7zip p7zip-full p7zip-rar packagekit pandoc pip pkg-config plocate powertop python3 python3-pip python3-setproctitle qrencode ripgrep rsync rygel sassc screen socat sshpass sxiv tar terminator tumbler tumbler-plugins-extra ufw ugrep un{zip,rar} unrar-free variety webext-ublock-origin-chromium wget wget2 wsdd xclip zip systemd-zram-generator zram-tools zstd gparted kdeconnect meld

sudo nala install -y hunspell-en-us hyphen-en-us libreoffice blender blender-data boomaga digikam scribus scribus-template rclone rclone-browser flameshot vlc inkscape krita gimp simplescreenrecorder obs-studio ocrmypdf duf figlet kitty pandoc thunar thunar-gtkhash thunar-archive-plugin thunar-media-tags-plugin thunar-font-manager thunar-volman thunarx-python yakuake micro ocrfeeder tesseract-ocr tesseract-ocr-eng plank-reloaded

sudo apt install -y busybox 

# IF you would rather use cairo-dock, uncomment the following lines to install it
#sudo nala remove -y pipewire
#sudo apt install -y cairo-dock cairo-dock-plug-ins 

# UNcomment to install virt-manager
sudo nala install -y virt-manager

echo -e "Package installation completed."
sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

sudo apt install earlyoom
sudo systemctl enable --now earlyoom

# Installing fonts
sudo nala install -y fonts-font-awesome xfonts-100dpi fonts-noto-color-emoji fonts-crosextra-caladea fonts-crosextra-carlito fonts-firacode fonts-noto-unhinted fonts-ubuntu-classic fonts-noto-mono

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip
sudo unzip Meslo.zip -d /usr/share/fonts

# Reloading Font
sudo fc-cache -vf

# Removing zip Files
rm ./Meslo.zip

# Function to remove residual configuration files
function remove_residual_config_files() {
    packages=$(dpkg -l | awk '/^rc/ { print $2 }')
    if [ -n "$packages" ]; then
        sudo dpkg -P $packages
        echo "Residual configuration files removed."
    else
        echo "No residual configuration files found."
    fi
}

# Function to clear systemd journal logs
function clear_journal_logs() {
    sudo journalctl --vacuum-time=7d
    echo "Systemd journal logs cleared."
}

# Lets clean up
echo -e "\n\n----------------------------------------------"
echo -e "|     Let's clean up                         |"
echo -e "----------------------------------------------\n\n"
sudo update-grub
sudo apt-get autoremove -y
sudo apt-get autoclean -y
clear_journal_logs
remove_residual_config_files

echo -e "\n\n----------------------------------------------"
echo -e "|     Let's clean up your SSD                 |"
echo -e "----------------------------------------------\n\n"
sudo fstrim -av

echo -e "\n\n-------------------------------------------"
echo -e "|                                         |"
echo -e "|     Setup Complete! Enjoy LinuxMint     |"
echo -e "|                                         |"
echo -e "-------------------------------------------\n\n"

exit 0
