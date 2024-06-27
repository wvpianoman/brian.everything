#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Feb 9 2024

#   《˘ ͜ʖ ˘》
#
#  ███████╗ ██████╗ ██╗     ██╗   ██╗███████╗    ██████╗ ██╗  ██╗ ██████╗ ███████╗
#  ██╔════╝██╔═══██╗██║     ██║   ██║██╔════╝    ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
#  ███████╗██║   ██║██║     ██║   ██║███████╗    ██████╔╝█████╔╝ ██║  ███╗███████╗
#  ╚════██║██║   ██║██║     ██║   ██║╚════██║    ██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
#  ███████║╚██████╔╝███████╗╚██████╔╝███████║    ██║     ██║  ██╗╚██████╔╝███████║
#  ╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Solus%20Pkgs

    echo "Installing the packages..."

# sudo eopkh install -y gstreamer-1.0-libav gstreamer-1.0-plugins-{bad,base,good,opencv,ugly} gtk-engines gtk2-engine-murrine intel-media-driver libffi6 libffi-devel libfreeaptx librist libsodium libsodium-devel libtool libvdpau libvdpau-va-gl libxext llvm-15 

sudo eopkg install -y acl aria2 attr autoconf automake bash-completion bc binutils btop busybox perl-mozilla-ca python-certifi cjson curl dialog duf easyeffects espeak-ng fd findutils ffmpeg ffmpegthumbnailer rtl8852bu flatpak git zstd fan2go

sudo eopkg install -y gnupg noto-sans-ttf grep gum ibus iptables jq lsd make meld libglu mpg123 nano fastfetch net-snmp nftables openssh-server openssh p7zip packagekit pandoc pip pipewire kpipewire wget httpie wsdd xclip zip zram-generator zram-generator-defaults

sudo eopkg install -y plocate powertop python3 python-setproctitle qrencode ripgrep ripgrep-all rsync rygel sassc screen socat sshpass sxiv tar terminator thefuck tlp thermald tumbler ufw gufw un{zip,rar} variety virt-manager 

echo "Package installation completed."
    sleep 3

# echo "KDE Package Installation"

# sudo eopkg install -y akonadi-import-wizard dolphin-plugins ffmpegthumbs ghostwriter flameshot neochat kate kdegraphics-thumbnailers kdepim-addons merkuro yakuake

# echo "Package installation completed."
#    sleep 3

echo "Installing Gnome Packages"

 sudo dnf5 install -y breeze-gtk breeze-gtk-{gtk2,gtk3,gtk4} breeze-icon-theme gnome-tweaks thunar-archive-plugin Thunar thunar-volman numlockx gnome-extensions-app spectacle kitty gnome-shell-extension-appindicator gnome-shell-extension-apps-menu gnome-shell-extension-common gnome-shell-extension-gsconnect gnome-shell-extension-launch-new-instance gnome-shell-extension-places-menu gnome-shell-extension-pop-shell gnome-shell-extension-window-list gnome-shell-extension-windowsNavigator gnome-shell-extension-freon  gnome-shell-extension-just-perfection gnome-commander spacefm xfce4-terminal element

echo "Package installation completed."
     sleep 3
# read -n 1 -r -s -p $'Press enter to continue...\n'

echo "Installing Software Packages"

sudo eopkg install -y  blender btrbk gimp gimp-help gimp-docs krita inkscape inkscape-docs boomaga digikam  rclone rclone-browser rhythmbox scribus scribus-docs shotwell simplescreenrecorder syncthing syncthing-gtk uget vlc thunar thunar-volman thunar-archive-plugin thunar-shares-plugin thunar-docs megacmd github-cli

echo "Package installation completed."
    sleep 3

echo "Installing utilites for different file system access"
# Support for additional file systems:

    sudo eopkg install -y  btrfs-progs exfatprogs f2fs-tools lvm2 reiserfsprogs udftools xfsprogs disktype

echo "Installation completed."
    sleep 3

echo "Installing ZSH / FISH shells and Plug-ins"

	sudo eopkg install -y zsh zsh-dbginfo zsh-autosuggestions zsh-syntax-highlighting antidote powerlevel10k powerline powerline-dbginfo rcm fish

echo "Installation completed."
    sleep 3

sudo systemctl start thermald.service
sudo systemctl status thermald.service


	# Audio
	[ -f /usr/bin/easyeffects ] && [ -f $HOME/.config/easyeffects/output/default.json ] && easyeffects -l default
	[ -f /usr/bin/pulseeffects ] && [ -f $HOME/.config/PulseEffects/output/default.json ] && pulseeffects -l default



	# Execute rygel to start DLNA sharing
	/usr/bin/rygel-preferences

#	# Install profile-sync: it to manage browser profile(s) in tmpfs and to periodically sync back to the physical disc (HDD/SSD)
#	sudo dnf install profile-sync-daemon
#	/usr/bin/profile-sync-daemon preview
#	# sudo dnf remove profile-sync-daemon
#	# psd profile located in $HOME/.config/psd/psd.conf


	# Install some fonts
sudo eopkg install -y font-fira-ttf font-firacode-ttf
sudo eopkg install -y font-awesome-ttf noto-sans-ttf font-adobe-100dpi

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
sudo unzip FiraCode.zip -d /usr/share/fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
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


	sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/San-Francisco-family/San-Francisco-family.sh)"



	display_message "[${GREEN}✔${NC}]  Trimming all mount points on SSD"
	sudo fstrim -av



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

# install eopkg 3rd aprty
echo -e "\n\n----------------------------------------------"
echo -e "|     Installing a couple 3rd party apps     |"
echo -e "----------------------------------------------\n\n"
sudo pip3 install eopkg3p

# install 3rd party apps
eopkg3p install gitkraken sublime-text teamviewer

echo -e "\n\n----------------------------------------------"
echo -e "|     Let's clean up your SSD                 |"
echo -e "----------------------------------------------\n\n"
sudo fstrim -av

echo -e "\n\n----------------------------------------------"
echo -e "|                                            |"
echo -e "|        Setup Complete! Enjoy Solus!       |"
echo -e "|       Please run ___________.sh            |"
echo -e "|    to back up your APT packages and more   |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"
