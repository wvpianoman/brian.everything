#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# 22 May 2024

#   《˘ ͜ʖ ˘》
#
#  ███████╗ ██████╗ ███████╗████████╗██╗    ██╗ █████╗ ██████╗ ███████╗    ██████╗ ██╗  ██╗ ██████╗ ███████╗
#  ██╔════╝██╔═══██╗██╔════╝╚══██╔══╝██║    ██║██╔══██╗██╔══██╗██╔════╝    ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
#  ███████╗██║   ██║█████╗     ██║   ██║ █╗ ██║███████║██████╔╝█████╗      ██████╔╝█████╔╝ ██║  ███╗███████╗
#  ╚════██║██║   ██║██╔══╝     ██║   ██║███╗██║██╔══██║██╔══██╗██╔══╝      ██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
#  ███████║╚██████╔╝██║        ██║   ╚███╔███╔╝██║  ██║██║  ██║███████╗    ██║     ██║  ██╗╚██████╔╝███████║
#  ╚══════╝ ╚═════╝ ╚═╝        ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Software%20Pkgs

# Tolga Erok
# for
# Brian
# 4/3/2024

# clear
# Assign a color variable based on the RANDOM number
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'

echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo

sudo yum install gum -y

display_message() {
    clear
    echo -e "\n                  UltraMArine/Fedora Updater\n"
    echo -e "\e[34m|--------------------\e[33m Currently configuring:\e[34m-------------------|"
    echo -e "|${YELLOW}==>${NC}  $1"
    echo -e "\e[34m|--------------------------------------------------------------|\e[0m"
    echo ""
    gum spin --spinner dot --title "Stand-by..." -- sleep 1
}

# Function to check if a service is active
is_service_active() {
	systemctl is-active "$1" &>/dev/null
}

# Function to check if a service is enabled
is_service_enabled() {
	systemctl is-enabled "$1" &>/dev/null
}

bash <(curl -s https://ultramarine-linux.org/migrate.sh)

# Function to print text in yellow color
print_yellow() {
	echo -e "\e[93m$1\e[0m"
}

# Function to check port 22
check_port22() {
	if pgrep sshd >/dev/null; then
		display_message "[${GREEN}✔${NC}] SSH service is running on port 22"
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	else
		display_message "${RED}[✘]${NC} SSH service is not running on port 22. Install and enable SSHD service.\n"
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
		check_error
	fi
}

echo "Installing RPM Fusion Repositories"

	# Install Apps
	sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	sudo dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
#	sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

	sudo dnf install -y dnf5

sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

echo "Installing Essential Software Packages"

sudo dnf5 install -y  codec2  gstreamer1-{libav,vaapi} gstreamer1-plugins-{bad-free,bad-free-extras,good,good-extras,ugly,ugly-free} gtk-murrine-engine gtk{2,3}-immodule-xim gtk2-engines haveged htop ibus-gtk4 intel-media-driver iptables iptables-services libffi libfreeaptx libfreeaptx-tools libgcab1 librabbitmq librabbitmq-tools librist libsodium libtool libva-intel-driver libvdpau libvdpau-va-gl libXext llvm16-libs lpcnetfreedv mesa-filesystem mesa-libEGL mesa-libGL mesa-libGL{w,U} mesa-libglapi mesa-libO{penCL,SMesa} mesa-va-drivers mesa-vulkan-drivers net-snmp net-tools nftables openssh openssh-{clients,server} ostree pip pipewire-codec-aptx pulseeffects python3 python3-pip python3-setproctitle sassc openssl sshpass

sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

echo "Package installation completed."

sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

echo "Installing Software Packages"

sudo dnf5 install -y acl aria2 attr autoconf automake bash-completion bc binutils btop busybox btrfs-assistant ca-certificates cifs-utils cjson cowsay crontabs curl dbus-glib dconf-editor dialog direnv dnf-plugins-core dnfdragora dnf5 dnf5-plugins duf earlyoom easyeffects espeak espeak-ng fancontrol-gui fastfetch fd-find ffmpegthumbnailer figlet flatpak fortune-mod git gnupg2 grep jq kernel-modules-extra krita lsd make mbedtls meld mozilla-ublock-origin mpg123 nano p7zip p7zip-gui p7zip-plugins PackageKit pandoc pkg-config plocate powertop qrencode ripgrep rsync rygel sxiv tar terminator tlp tlp-rdw tlpi tumbler tumbler-extras ufw ugrep un{zip,rar} unrar-free virt-manager wget wsdd xclip zip zram zram-generator zram-generator-defaults zstd uget vlc zsh zsh-autosuggestions zsh-syntax-highlighting zsh-lovers screen socat grub-customizer hplip zed kitty fonts-tweak-tool soundconverter

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sleep 3

sudo dnf5 install -y digikam ghostwriter gimp gimp-help gimp-data-extras gparted inkscape blender boomaga pdfarranger rclone rclone-browser scribus simplescreenrecorder variety discord fish virt-manager lolcat fortune-mod telegram-desktop virtualbox virtualbox-guest-additions

sleep 3

echo "Installing PLASMA Packages"

sudo dnf5 install -y kdepim-addons kate kate-plugins dolphin-plugins merkuro plasma-discover-{flatpak,packagekit} plasma-firewall-ufw yakuake arc-kde-yakuake materia-kde-yakuake akonadi akonadi-calendar-tools akonadi-import-wizard kdegraphics-thumbnailers yakuake fancontrol-{gui-kcm,gui-plasmoid} ffmpegthumbs flameshot korganizer hplip hplip-gui

#sleep 3

# echo "Installing Gnome Packages"

# sudo dnf group install -y "gnome-desktop"

# sudo dnf5 install -y breeze-gtk breeze-gtk-{gtk2,gtk3,gtk4} breeze-icon-theme gnome-tweaks thunar-archive-plugin Thunar thunar-volman numlockx gnome-extensions-app spectacle kitty gnome-shell-extension-appindicator gnome-shell-extension-apps-menu gnome-shell-extension-common gnome-shell-extension-gsconnect gnome-shell-extension-launch-new-instance gnome-shell-extension-places-menu gnome-shell-extension-pop-shell gnome-shell-extension-window-list gnome-shell-extension-windowsNavigator gnome-shell-extension-freon  gnome-shell-extension-just-perfection gnome-commander spacefm soundconverter xfce4-terminal thunar-archive-plugin fonts-tweak-tool

echo "Installing BTRFS Packages"
sudo dnf5 install -y  btrfs-assistant btrfs-progs btrbk btrfsmaintenance

echo "Installing utilites for different file system access"

sudo dnf5 install -y apfs-fuse btrfs-progs disktype exfatprogs f2fs-tools fuse-sshfs hfsutils hfsplus-tools jfsutils lvm2 nilfs-utils ntfs-3g udftools xfsprogs

wget https://mega.nz/linux/repo/Fedora_40/x86_64/megasync-Fedora_40.x86_64.rpm && sudo dnf install "$PWD/megasync-Fedora_40.x86_64.rpm"

echo "Package installation completed."

sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

sudo dnf5 install -y earlyoom
sudo systemctl enable --now earlyoom

sleep 3

	# Install some font tools and fonts
	display_message "[${GREEN}✔${NC}]  Installing some font tools and fonts"
sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig -y
	sudo dnf install -y fontawesome-fonts powerline-fonts 'google-roboto*' 'mozilla-fira*' fira-code-fonts
	sudo dnf install -y redhat-{mono,text,display}-fonts xorg-x11-fonts-ISO8859-1-100dpi google-noto-emoji-color-fonts
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
	sudo mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
sudo unzip FiraCode.zip -d /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
sudo unzip Meslo.zip -d /usr/share/fonts
# wget https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip
# sudo unzip WPS-FONTS.zip -d /usr/share/fonts/wps-office

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

	# Reloading Font
	sudo fc-cache -vf

	# Removing zip Files
	rm ./FiraCode.zip ./Meslo.zip ./WPS-FONTS.zip
	sudo fc-cache -f -v

	# sudo dnf install fontconfig-font-replacements -y --skip-broken && sudo dnf install fontconfig-enhanced-defaults -y --skip-broken

	# sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/San-Francisco-family/San-Francisco-family.sh)"

####################################################

	# Enable trim support
	sudo systemctl enable fstrim.timer
#################################################

	# Audio
	[ -f /usr/bin/easyeffects ] && [ -f $HOME/.config/easyeffects/output/default.json ] && easyeffects -l default
	[ -f /usr/bin/pulseeffects ] && [ -f $HOME/.config/PulseEffects/output/default.json ] && pulseeffects -l default
-----------------------------------------------

	# Configure fortune
	# If you want to display a specific fortune file or category, you can use the -e option followed by the file or category name. For example:
	# fortune -e art ascii-art bofh-excuses computers cookie definitions disclaimer drugs education fortunes humorists kernelnewbies knghtbrd law linux literature miscellaneous news people riddles science
	# or to see a list:
	# fortune -f

	# Execute rygel to start DLNA sharing
	/usr/bin/rygel-preferences

	# Install profile-sync: it to manage browser profile(s) in tmpfs and to periodically sync back to the physical disc (HDD/SSD)
	sudo dnf install -y profile-sync-daemon
	/usr/bin/profile-sync-daemon preview
	# sudo dnf remove profile-sync-daemon
	# psd profile located in $HOME/.config/psd/psd.conf


	## Make a backup of the original sysctl.conf file
	display_message "[${GREEN}✔${NC}]  Tweaking network settings"

	cp $SYS_PATH /etc/sysctl.conf.bak

	echo
	yellow_msg 'Default sysctl.conf file Saved. Directory: /etc/sysctl.conf.bak'
	echo
	gum spin --spinner dot --title "Stand-by..." -- sleep 1

function cleanup_fedora() {
	# Clean package cache
	display_message "[${GREEN}✔${NC}]  Time to clean up system..."
	sudo dnf clean all

	# Remove unnecessary dependencies
	sudo dnf autoremove -y

	# Sort the lists of installed packages and packages to keep
	display_message "[${GREEN}✔${NC}]  Sorting out list of installed packages and packages to keep..."
	comm -23 <(sudo dnf repoquery --installonly --latest-limit=-1 -q | sort) <(sudo dnf list installed | awk '{print $1}' | sort) >/tmp/orphaned-pkgs

	if [ -s /tmp/orphaned-pkgs ]; then
		sudo dnf remove $(cat /tmp/orphaned-pkgs) -y --skip-broken
	else
		display_message "[${GREEN}✔${NC}]  Congratulations, no orphaned packages found."
	fi

	# Clean up temporary files
	display_message "[${GREEN}✔${NC}]  Clean up temporary files ..."
	sudo rm -rf /tmp/orphaned-pkgs

	display_message "[${GREEN}✔${NC}]  Trimming all mount points on SSD"
	sudo fstrim -av

	echo -e "\e[1;32m[✔]\e[0m Restarting kernel tweaks...\n"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
	sudo sysctl -p

	display_message "[${GREEN}✔${NC}]  Cleanup complete, ENJOY!"
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
sudo update-grub
sudo dnf -y up
sudo dnf -y autoremove
sudo dnf -y clean all
clear_journal_logs
cleanup_fedora

echo -e "\n\n----------------------------------------------"
echo -e "|     Let's clean up your SSD                 |"
echo -e "----------------------------------------------\n\n"
sudo fstrim -av

echo -e "\n\n----------------------------------------------"
echo -e "|                                            |"
echo -e "|      Setup Complete! Enjoy Ultramarine     |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

# exit 0
