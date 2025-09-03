#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Jul 11 2025
#   《˘ ͜ʖ ˘》

# Install some software:

echo "Installing packages not in repo..."

# sublime-text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
#pikman update && pikman install sublime-text

# freeoffice
sudo su

wget -qO- https://shop.softmaker.com/repo/linux-repo-public.key | gpg --dearmor > /etc/apt/keyrings/softmaker.gpg
echo "deb [signed-by=/etc/apt/keyrings/softmaker.gpg] https://shop.softmaker.com/repo/apt stable non-free" > /etc/apt/sources.list.d/softmaker.list
# pikman update && pikman install softmaker-freeoffice-2024

# Megasync testing repo
#wget https://mega.nz/linux/repo/Debian_testing/amd64/megasync-Debian_testing_amd64.deb && pikman install "$PWD/megasync-Debian_testing_amd64.deb"

# Megasync deb 13 repo
wget https://mega.nz/linux/repo/Debian_13/amd64/megasync-Debian_13_amd64.deb && sudo apt install "$PWD/megasync-Debian_13_amd64.deb"

#Install gum : A tool for glamorous shell scripts. https://github.com/charmbracelet/gum

curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
# pikman update && pikman install gum

sudo nala  update && sudo nala install gum softmaker-freeoffice-2024 sublime-text

#fileu
# wget https://filelu.com/IO83v8fj9nbLQxAs/filelusync_amd64.zip
# unzip filelusync_amd64.zip
# cd filelusync_amd64
# chmod +x install
# ./install


sudo nala install cowsay dialog yad duf espeak espeak-ng fancontrol figlet fortune-mod fortunes fortunes-min pandoc fish aria2 hardinfo2 thefuck ocrmypdf ocrmypdf-doc pdfsandwich acl attr autoconf automake bash-completion bc binutils btop busybox ca-certificates cifs-utils libcjson1 codec2 cookietool cron curl gir1.2-dbusglib-1.0 dconf-editor direnv dnsutils  earlyoom easyeffects mbpfan fd-find ffmpeg ffmpegthumbnailer ffmpegthumbs flatpak gdebi git gnupg2 grep 

sudo nala install haveged ibus-gtk4 jq lsd make meld ublock-origin-doc webext-ublock-origin-firefox mpg123 nano neovim neovim-qt snmpd net-tools nftables openssh-{client,server} p7zip p7zip-full p7zip-rar packagekit pandoc

sudo apt install pipewire-{audio,doc} pkg-config plocate powertop qrencode ripgrep rsync rygel sassc screen socat sshpass sxiv tar terminator thefuck tumbler tumbler-plugins-extra ufw ugrep un{zip,rar} unrar-free variety wget wget2 xclip zip systemd-zram-generator zram-tools zstd gparted

sudo nala install hunspell-en-us hyphen-en-us libreoffice blender blender-data gimp gimp-help-en inkscape boomaga digikam neochat scribus scribus-template rclone rclone-browser flameshot fastfetch persepolis variety vlc simplescreenrecorder uget

echo "Package installation completed."
    sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'



sudo apt install earlyoom
sudo systemctl enable --now earlyoom

echo "Installiong Software Packages"


echo "Package installation completed."
    sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'


# Installing fonts
sudo nala install fonts-font-awesome fonts-noto-color-emoji xfonts-100dpi fonts-noto-color-emoji
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
sudo unzip FiraCode.zip -d /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
sudo unzip Meslo.zip -d /usr/share/fonts

# Reloading Font
sudo fc-cache -vf

# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

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

echo -e "\n\n----------------------------------------------"
echo -e "|                                            |"
echo -e "|        Setup Complete! Enjoy PikaOS!           |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
