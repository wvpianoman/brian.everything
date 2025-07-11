#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Jan 20 2024
#   《˘ ͜ʖ ˘》

# Install some software:

echo "Installing essential packages..."

# sublime-text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
sudo nala update && sudo nala install sublime-text

# freeoffice
sudo su
mkdir -p /etc/apt/keyrings
wget -qO- https://shop.softmaker.com/repo/linux-repo-public.key | gpg --dearmor > /etc/apt/keyrings/softmaker.gpg
echo "deb [signed-by=/etc/apt/keyrings/softmaker.gpg] https://shop.softmaker.com/repo/apt stable non-free" > /etc/apt/sources.list.d/softmaker.list
nala update && nala install softmaker-freeoffice-2024

# Megasync
wget https://mega.nz/linux/repo/Debian_testing/amd64/megasync-Debian_testing_amd64.deb && sudo apt install "$PWD/megasync-Debian_testing_amd64.deb"

#Install gum : A tool for glamorous shell scripts. https://github.com/charmbracelet/gum
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo nala update && sudo nala install gum

# onlyoffice
mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg

echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list
sudo nala update && sudo nala install onlyoffice-desktopeditors onlyoffice-desktopeditors-help

#fileu
wget https://filelu.com/IO83v8fj9nbLQxAs/filelusync_amd64.zip
unzip filelusync_amd64.zip
cd filelusync_amd64
chmod +x install
./install

pikman install blender blender-data gimp gimp-help-en inkscape boomaga digikam neochat telegram-desktop scribus scribus-template rclone rclone-browser flameshot fastfetch persepolis variety

pikman install cowsay dialog yad duf espeak espeak-ng fancontrol figlet fortune-mod fortunes fortunes-min pandoc fish uget aria2 hardinfo2 thefuck ocrmypdf ocrmypdf-doc pdfsandwich meld

pikman install zsh zplug zsh-antidote zsh-antigen zsh-autosuggestions zsh-doc zsh-syntax-highlighting zsh-theme-powerlevel9k fizsh kitty


echo "Package installation completed."
    sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'



pikmana install earlyoom
sudo systemctl enable --now earlyoom


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
echo -e "|        Setup Complete! Enjoy MX!           |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
