#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Jul 11 2025
#   《˘ ͜ʖ ˘》

# Install some software:

sudo apt install nala -y

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

# Megasync
wget https://mega.nz/linux/repo/Debian_testing/amd64/megasync-Debian_testing_amd64.deb && sudo nala install "$PWD/megasync-Debian_testing_amd64.deb"

#Install gum : A tool for glamorous shell scripts. https://github.com/charmbracelet/gum

curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
# pikman update && pikman install gum

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
sudo apt update
sudo apt install gcalendar

# element
sudo apt install -y wget apt-transport-https
sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
sudo apt update
sudo apt install element-desktop

# fish shell
sudo add-apt-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish

# fish plugins
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install IlanCosman/tide@v6


sudo nala update && sudo nala install onlyoffice-desktopeditors onlyoffice-desktopeditors-help gum softmaker-freeoffice-2024 sublime-text fonts-crosextra-caladea

#fileu
# wget https://filelu.com/IO83v8fj9nbLQxAs/filelusync_amd64.zip
# unzip filelusync_amd64.zip
# cd filelusync_amd64
# chmod +x install
# ./install

sudo apt install -y yad espeak espeak-ng fancontrol figlet fortune-mod fortunes fortunes-min uget hardinfo thefuck ocrmypdf ocrmypdf-doc pdfsandwich meld acl aria2 attr autoconf automake bash-completion bc binutils btop busybox ca-certificates cifs-utils libcjson1 codec2 cookietool cowsay cron curl gir1.2-dbusglib-1.0 dconf-editor dialog direnv dnsutils duf easyeffects mbpfan fd-find ffmpeg ffmpegthumbnailer ffmpegthumbs flatpak gdebi git gnupg2 grep yaru-cinnamon-theme-{gtk,icon} sox zenity synaptic plank lolcat vnstati

sudo nala install -y  haveged ibus-gtk4 jq lsd make ublock-origin-doc webext-ublock-origin-firefox mpg123 nano neofetch neovim neovim-qt snmpd net-tools nftables openssh-{client,server} ostree p7zip p7zip-full p7zip-rar packagekit pandoc pip pipewire-{audio,doc} pkg-config plocate powertop python3 python3-pip python3-setproctitle qrencode ripgrep rsync rygel sassc screen socat sshpass sxiv tar terminator tumbler tumbler-plugins-extra ufw ugrep un{zip,rar} unrar-free variety vim webext-ublock-origin-chromium wget wget2 wsdd xclip zip systemd-zram-generator zram-tools zstd gparted kdeconnect meld #virt-manager

sudo nala install hunspell-en-us hyphen-en-us libreoffice blender blender-data gimp gimp-help-en inkscape boomaga digikam neochat scribus scribus-template rclone rclone-browser flameshot vlc simplescreenrecorder megacmd obs-studio ocrmypdf duf gum figlet kitty pandoc gum thunar thunar-gtkhash thunar-archive-plugin thunar-media-tags-plugin thunar-font-manager thunar-volman thunar-megasync thunarx-python 

echo "Package installation completed."
    sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'



sudo apt install earlyoom
sudo systemctl enable --now earlyoom

echo "Installing Software Packages"


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

echo -e "\n\n-------------------------------------------"
echo -e "|                                         |"
echo -e "|     Setup Complete! Enjoy LinuxMint     |"
echo -e "|                                         |"
echo -e "-------------------------------------------\n\n"

exit 0
