#!/usr/bin/env bash

# Brian Francisco Packages
# 22 Oct 2024

#   《˘ ͜ʖ ˘》

# Tolga Erok for Brian
# 19/4/2024

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

# Function to handle errors
handle_error() {
    echo -e "${RED}Error occurred: $1${NC}"
}

# execute a command with error handling
execute_command() {
    "$@" || handle_error "Failed to execute: $*"
}

# Continue with the rest of the script
echo -e "doing stuff..."

# read -n 1 -r -s -p $'Press enter to continue...\n'

# Define colors
ORANGE='\033[0;33m'
NC='\033[0m'

sudo pacman -Syu dialog zenity

# essantial software pckages
essential_packages=(
    acl aria2 attr autoconf automake bash-completion bc binutils btop busybox perl-mozilla-ca python-certifi cjson curl 
    dialog duf easyeffects espeak-ng fd findutils ffmpeg ffmpegthumbnailer flatpak git zstd gnupg lolcat fortune-mod ufw
    grep gum ibus iptables jq lsd make meld mpg123 nano fastfetch net-snmp nftables gum git-lfs figlet direnv un{zip,rar} 
    openssh p7zip packagekit pandoc pipewire kpipewire wget httpie wsdd xclip zip zram-generator variety font-manager zed 
    plocate powertop python3 python-setproctitle qrencode ripgrep ripgrep-all rsync rygel sassc screen socat sshpass nsxiv
    tar terminator thefuck thermald tumbler gufw 
)
# kde packages
kde_packages=(
    akonadi-import-wizard dolphin-plugins ffmpegthumbs flameshot kate kdegraphics-thumbnailers
    kdepim-addons yakuake korganizer
)

# gnome packages
gnome_packages=(
    breeze-icons breeze gnome-tweaks thunar-archive-plugin thunar thunar-volman thunar-docs thunar-shares-plugin
    numlockx spectacle kitty gnome-commander spacefm xfce4-terminal thunar-archive-plugin
)

# software packages
software_packages=(
    blender btrbk gimp krita inkscape digikam rclone rclone-browser rhythmbox shotwell simplescreenrecorder github-cli 
    discord nheko telegram-desktop deja-dup soundconverter vivaldi vivaldi-ffmpeg-codecs obs-studio scribus uget vlc
    onlyoffice-bin
)

# utilities for file system access
filesystem_utilities=(
    btrfs-progs exfatprogs f2fs-tools lvm2 reiserfsprogs udftools xfsprogs disktype
)

# utilities for file system access
shells=(
    zsh zsh-autosuggestions zsh-syntax-highlighting fish
)

# Install packages
install_packages() {
    echo -e "${ORANGE}$1${NC}"
    sudo pacman -S "${@:2}" || handle_error "Failed to install: $1"
    echo "Package installation completed."
}

# Install essential packages
install_packages "Installing Essential Software Packages" "${essential_packages[@]}"

# Install DE packages
# Pick Gnome or KDE
install_packages "Installing KDE Packages" "${kde_packages[@]}"
# install_packages "Installing Gnome Packages""${gnome_packages[@]}"

# Install Software Packages
install_packages "Installing Software Packages""${software_packages[@]}"

# Install filesystem utilities
install_packages "Installing utilities for different file system access" "${shells[@]}"

# Install Software Packages
install_packages "Installing ZSH-FISH shells and Plug-ins""${software_packages[@]}"

# Install some fonts

wget https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip
sudo unzip WPS-FONTS.zip -d /usr/share/fonts/wps-office

# Reloading Font
sudo fc-cache -vf

# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip ./WPS-FONTS.zip

	zip_file="Apple-Fonts-San-Francisco-New-York-master.zip"

	# Check if the ZIP file exists
	if [ -f "$zip_file" ]; then
		# Remove existing ZIP file
		sudo rm -f "$zip_file"
		echo "Existing ZIP file removed."
	fi

	# Download the ZIP file
	curl -LJO https://github.com/tolgaerok/Apple-Fonts-San-Francisco-New-York/archive/refs/heads/master.zip

	# Check if the download was successful
	if [ -f "$zip_file" ]; then
		# Unzip the contents to the system-wide fonts directory
		sudo unzip -o "$zip_file" -d /usr/share/fonts/

		# Update font cache
		sudo fc-cache -f -v

		# Remove the ZIP file
		rm "$zip_file"

		display_message "[${GREEN}✔${NC}] Apple fonts installed successfully."
		echo ""
		gum spin --spinner dot --title "Re-thinking... 1 sec" -- sleep 2
	else
		display_message "[${RED}✘${NC}] Download failed. Please check the URL and try again."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi

sudo systemctl start thermald.service
sudo systemctl status thermald.service

	# Audio
	[ -f /usr/bin/easyeffects ] && [ -f $HOME/.config/easyeffects/output/default.json ] && easyeffects -l default
	[ -f /usr/bin/pulseeffects ] && [ -f $HOME/.config/PulseEffects/output/default.json ] && pulseeffects -l default

	# Execute rygel to start DLNA sharing
	/usr/bin/rygel-preferences

speed-up-shutdown() {
	display_message "${YELLOW}[*]${NC} Configure shutdown of units and services to 10s .."
	sleep 1

	# Configure default timeout to stop system units
	sudo mkdir -p /etc/systemd/system.conf.d
	sudo tee /etc/systemd/system.conf.d/default-timeout.conf <<EOF
[Manager]
DefaultTimeoutStopSec=10s
EOF

	# Configure default timeout to stop user units
	sudo mkdir -p /etc/systemd/user.conf.d
	sudo tee /etc/systemd/user.conf.d/default-timeout.conf <<EOF
[Manager]
DefaultTimeoutStopSec=10s
EOF

	display_message "${GREEN}[✔]${NC} Shutdown speed configured"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
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
# sudo update-grub
pacman -Qtdq | sudo pacman -Rns 
clear_journal_logs
remove_residual_config_files

echo -e "\n\n----------------------------------------------"
echo -e "|     Let's clean up your SSD                 |"
echo -e "----------------------------------------------\n\n"
sudo fstrim -av

echo -e "\n\n----------------------------------------------"
echo -e "|                                            |"
echo -e "|               Setup Complete!              |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
