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

sudo eopkg it dialog zenity -y

# essantial software pckages
essential_packages=(
    acl aria2 attr autoconf automake bash-completion bc binutils btop busybox perl-mozilla-ca python-certifi cjson curl 
    dialog duf easyeffects espeak-ng fd findutils ffmpeg ffmpegthumbnailer rtl8852bu flatpak git zstd fan2go gnupg 
    noto-sans-ttf grep gum ibus iptables jq lsd make meld libglu mpg123 nano fastfetch net-snmp nftables openssh-server 
    openssh p7zip packagekit pandoc pip pipewire kpipewire wget httpie wsdd xclip zip zram-generator zram-generator-defaults 
    plocate powertop python3 python-setproctitle qrencode ripgrep ripgrep-all rsync rygel sassc screen socat sshpass nsxiv
    tar terminator thefuck tlp thermald tumbler ufw gufw un{zip,rar} variety virt-manager font-manager zed lolcat fortune-mod
    gum fan2go fan2go-dbginfo qt5ct git-lfs figlet starship yad 
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

# budgie packages
budgie_packages=(
	sudo eopkg it budgie-desktop budgie-extras-daemon budgie-desktop-branding budgie-applications-menu budgie-window-shuffler budgie-desktop-devel budgie-screensaver mojave-gtk-theme vala-panel-appmenu budgie-previews budgie-quicknote-applet budgie-weathershow-applet budgie-shutdown-timer xrdp-budgie-integration budgie-calendar-applet budgie-user-indicator-redux-applet budgie-cputemp-applet menulibre budgie-control-center  budgie-haste-applet vala-panel-appmenu-budgie-desktop budgie-visualspace-applet pocillo-gtk-theme budgie-restart-applet pocillo-gtk-theme-slim materia-gtk-theme-dark budgie-calendar-applet budgie-session budgie-extras budgie-applications-menu materia-gtk-theme-light materia-gtk-theme-dark-compact budgie-backgrounds budgie-showtime-applet budgie-showtime-applet materia-gtk-theme-compact mojave-gtk-theme-alt materia-gtk-theme celtic-magic-button budgie-hotcorners-applet budgie-desktop-view budgie-kangaroo-applet budgie-takeabreak-applet budgie-screenshot-applet budgie-countdown-applet materia-gtk-theme-light-compact budgie-brightness-controller-applet
	)

# software packages
software_packages=(
    blender btrbk gimp gimp-help gimp-docs krita inkscape inkscape-docs boomaga digikam rclone rclone-browser rhythmbox
    scribus-docs shotwell simplescreenrecorder uget vlc github-cli discord nheko telegram deja-dup
    soundconverter vivaldi-stable obs-studio scribus baobab 
)

# utilities for file system access
filesystem_utilities=(
    btrfs-progs exfatprogs f2fs-tools lvm2 reiserfsprogs udftools xfsprogs disktype
)

# utilities for file system access
shells=(
    zsh zsh-dbginfo zsh-autosuggestions zsh-syntax-highlighting antidote powerlevel10k powerline powerline-dbginfo rcm fish
)

# Install packages
install_packages() {
    echo -e "${ORANGE}$1${NC}"
    sudo eopkg it -y "${@:2}" || handle_error "Failed to install: $1"
    echo "Package installation completed."
}

# Install essential packages
install_packages "Installing Essential Software Packages" "${essential_packages[@]}"

# Install DE packages
# Pick Budgie, Gnome or KDE
install_packages "Installing KDE Packages" "${kde_packages[@]}"
# install_packages "Installing Gnome Packages""${gnome_packages[@]}"
# install_packages "Installing Budgie Packages""${budgie_packages|@|}"

# Install Software Packages
install_packages "Installing Software Packages""${software_packages[@]}"

# Install filesystem utilities
install_packages "Installing utilities for different file system access" "${shells[@]}"

# Install Software Packages
install_packages "Installing ZSH / FISH shells and Plug-ins""${software_packages[@]}"

# Install direnv for Visual Studio Code
curl -sfL https://direnv.net/install.sh | sudo bash

	# Install some fonts
sudo eopkg install -y font-fira-ttf font-firacode-ttf font-awesome-ttf noto-sans-ttf

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
gpu_info=$(lspci | grep -i 'VGA\|3D')
if [[ -z $gpu_info ]]; then
    echo "No GPU found."
    exit 1
fi

# Check GPU is present
if [[ $gpu_info =~ "AMD" ]]; then

    # Install firmware for AMD GPU
    sudo eopkg update
    sudo eopkg install -y linux-firmware xorg-driver-video-amdgpu
    echo "AMD GPU firmware installed successfully."

else
    # Install video acceleration for HD Intel i965
    sudo eopkg update
    sudo eopkg install xorg-driver-video-intel
    sudo eopkg install -y libva-intel-driver
    echo "Video acceleration drivers installed successfully."
fi

echo "alias cake='interface=\$(ip link show | awk -F: '\''\$0 ~ \"wlp|wlo|wlx\" && \$0 !~ \"NO-CARRIER\" {gsub(/^[ \\t]+|[ \\t]+$/, \"\", \$2); print \$2; getline}'\''); sudo tc -s qdisc show dev \$interface && sudo systemctl status apply-cake-qdisc.service'" >> ~/.bashrc

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
sudo eopkg remove-orphans -y
sudo eopkg clean -y
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
