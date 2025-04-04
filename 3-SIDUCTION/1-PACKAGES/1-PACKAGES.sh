#!/usr/bin/env bash

# Brian Francisco Packages
# Mar 24, 2025

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

sudo apt install dialog zenity -y

# essantial software pckages
essential_packages=(
    acl aria2 attr autoconf automake bash-completion bc binutils btop busybox ca-certificates cifs-utils libcjson1 codec2 cookietool 
    cowsay cron curl gir1.2-dbusglib-1.0 dconf-editor dialog direnv dnsutils duf earlyoom easyeffects espeak espeak-ng fancontrol 
    mbpfan fd-find figlet firmware-realtek flatpak fortune-mod fortunes fortunes-min gdebi git gnupg2 grep grub-customizer 
    gstreamer1.0-{libav,vaapi} gstreamer1.0-plugins-{bad,base,good,rtp,ugly} gtk2-engines-murrine murrine-themes uim-gtk{2.0,3} 
    uim-gtk{2.0,3}-immodule uim-qt5 uim-qt5-immodule gtk2-engines haveged ibus-gtk4 intel-media-va-driver iptables jq libavcodec-extra 
    libffi8 libffi-dev libfreeaptx0 libgc1 librabbitmq4 librabbitmq-dev librist4 libsodium23 libsodium-dev libtool libvdpau1 libvdpau-va-gl1 
    libxext6 llvm-16 lsd make libegl1-mesa libgl{u,w}1-mesa mesa-va-drivers mesa-vulkan-drivers ublock-origin-doc webext-ublock-origin-firefox 
    mpg123 snmpd net-tools nftables openssh-{client,server} ostree p7zip p7zip-full p7zip-rar packagekit pandoc pip pipewire-{audio,doc} 
    pkg-config plocate powertop python3 python3-pip python3-setproctitle qrencode ripgrep rsync rygel sassc screen socat sshpass sxiv tar 
    terminator thefuck tlp tlp-rdw tlpui tumbler tumbler-plugins-extra ufw ugrep un{zip,rar} unrar-free   webext-ublock-origin-chromium wget 
    wget2 wsdd xclip zip systemd-zram-generator zramswap-sysvinit-compat zram-tools zstd
)
# kde packages
kde_packages=(
    akonadi-import-wizard dolphin-plugins ffmpeg ffmpegthumbnailer ffmpegthumbs kate kdegraphics-thumbnailers kdepim-addons yakuake korganizer 
    plasma-discover-backend-{flatpak,fwupd} plasma-firewall kate 
)

# gnome packages
gnome_packages=(
    breeze-icons breeze gnome-tweaks thunar-archive-plugin thunar thunar-volman thunar-docs thunar-shares-plugin numlockx spectacle kitty 
    gnome-commander spacefm xfce4-terminal thunar-archive-plugin
)

# software packages
software_packages=(
    blender blender-data ghostwriter gimp gimp-help-en krita inkscape boomaga digikam flameshot rclone rclone-browser rhythmbox scribus 
    scribus-doc scribus-template shotwell simplescreenrecorder syncthing syncthing-gtk telegram-desktop uget vlc yakuake nheko nano 
    fastfetch neovim neovim-qt variety virt-manager meld vim
)

# utilities for file system access
filesystem_utilities=(
    btrfs-progs exfatprogs f2fs-tools hfsprogs hfsplus hfsutils jfsutils lvm2 nilfs-tools reiserfsprogs reiser4progs udftools xfsprogs disktype 
    apfs-dkms apfsprogs libfsapfs-utils libfsapfs1 exfat-fuse btrfs-assistant
)

# utilities for file system access
shells=(
    zsh zsh-dbginfo zsh-autosuggestions zsh-syntax-highlighting antidote powerlevel10k powerline powerline-dbginfo rcm fish
)

# Install packages
install_packages() {
    echo -e "${ORANGE}$1${NC}"
    sudo apt install -y --install-recommends "${@:2}" || handle_error "Failed to install: $1"
    echo "Package installation completed."
}

# Install essential packages
install_packages "Installing Essential Software Packages" "${essential_packages[@]}"

# Install DE packages
install_packages "Installing KDE Packages" "${kde_packages[@]}"
#install_packages "Installing KDE Packages" "${gnome_packages[@]}"

# Install Software Packages
install_packages "Installing Software Packages""${software_packages[@]}"

# Install filesystem utilities
install_packages "Installing utilities for different file system access" "${shells[@]}"

# Install Software Packages
install_packages "Installing ZSH / FISH shells and Plug-ins""${software_packages[@]}"

	# Install some fonts
sudo apt install -y fonts-font-awesome fonts-noto-color-emoji xfonts-100dpi fonts-noto-color-emoji

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
sudo unzip FiraCode.zip -d /usr/share/fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip
sudo unzip Meslo.zip -d /usr/share/fonts

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

sudo systemctl enable --now earlyoom

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

# Check GPU information
    # Install firmware for AMD GPU
    sudo apt update
    sudo apt install firmware-amd-graphics -y
    echo "AMD GPU firmware installed successfully."

# Check GPU information
gpu_info=$(lspci | grep -i 'VGA\|3D')
if [[ -z $gpu_info ]]; then
    echo "No GPU found."
    exit 1
fi

# Check if NVIDIA GPU is present
if [[ $gpu_info =~ "NVIDIA" ]]; then
    # Check if NVIDIA drivers are already installed
    if nvidia-smi &>/dev/null; then
        read -r -p "NVIDIA drivers are already installed" -t 2 -n 1 -s
        echo "."
    else
        # Install NVIDIA drivers
        sudo apt update
        sudo apt install nvidia-driver firmware-misc-nonfree -y
        sudo apt install -y nvidia-driver
        sudo bash -c 'echo -e "blacklist nouveau\noptions nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf'

        # Path to the grub configuration file
        grub_file="/etc/default/grub"

        # Comment out the existing GRUB_CMDLINE_LINUX line
        sed -i 's/^GRUB_CMDLINE_LINUX=/#&/' "$grub_file"

        # Add the new GRUB_CMDLINE_LINUX line after the commented line
        sed -i '/^#GRUB_CMDLINE_LINUX=/a GRUB_CMDLINE_LINUX="rhgb quiet rd.driver.blacklist=nouveau"' "$grub_file"

        sudo update-grub

        echo "NVIDIA drivers installed successfully."

        # Run NVIDIA settings
        sudo nvidia-settings
    fi

elif [[ $gpu_info =~ "AMD" ]]; then
    # Install firmware for AMD GPU
    sudo apt update
    sudo apt install firmware-amd-graphics -y
    echo "AMD GPU firmware installed successfully."

else
    # Install video acceleration for HD Intel i965
    sudo apt update
    sudo apt install xserver-xorg-video-intel
    sudo apt install -y i965-va-driver libva-drm2 libva-x11-2 vainfo
    echo "Video acceleration drivers installed successfully."
fi

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
echo -e "|               Setup Complete!              |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
