#!/usr/bin/env bash

# Brian Francisco Packages
# 16 Jan 2025

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

echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo

sudo yum install gum -y

display_message() {
    clear
    echo -e "\n                  UltraMarine/Fedora Updater\n"
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

sleep 2

# read -n 1 -r -s -p $'Press enter to continue...\n'

# essantial software pckages
essential_packages=(
	acl aria2 attr autoconf automake bash-completion bc binutils btop busybox ca-certificates cifs-utils cjson codec2 cowsay crontabs curl dbus-glib dconf-editor dialog direnv dnf dnf-plugins-core dnfdragora duf earlyoom easyeffects espeak espeak-ng fancontrol-gui fastfetch fd-find ffmpegthumbnailer figlet flatpak fonts-tweak-tool fortune-mod git gnupg2 grep gstreamer1-plugins-{bad-free,bad-free-extras,good,good-extras,ugly,ugly-free} gstreamer1-{libav,vaapi} gtk-murrine-engine gtk2-engines gtk{2,3}-immodule-xim haveged hplip hplip-gui htop ibus-gtk4 intel-media-driver iptables iptables-services jq kernel-modules-extra kitty libXext libffi libfreeaptx libfreeaptx-tools libgcab1 librabbitmq librabbitmq-tools librist libsodium libtool libva-intel-driver libvdpau libvdpau-va-gl llvm18-libs lpcnetfreedv lsd make mbedtls meld mesa-filesystem mesa-libEGL mesa-libGL mesa-libGL{w,U} mesa-libO{penCL,SMesa} mesa-vulkan-drivers mozilla-ublock-origin mpg123 nano net-snmp net-tools nftables openssh openssh-{clients,server} openssl ostree p7zip p7zip-gui p7zip-plugins pandoc pip pipewire-codec-aptx pkg-config plocate powertop pulseeffects python3 python3-pip python3-setproctitle qrencode ripgrep rsync rygel sassc screen socat soundconverter sshpass sxiv tar terminator tumbler tumbler-extras ufw uget ugrep unrar-free un{zip,rar} vlc wget wsdd xclip zed zip zram zram-generator zram-generator-defaults zstd PackageKit yad
)

# kde packages
kde_packages=(
    akonadi akonadi-calendar-tools akonadi-import-wizard arc-kde-yakuake dolphin-plugins fancontrol-{gui-kcm,gui-plasmoid} ffmpegthumbs flameshot kate kate-plugins kdegraphics-thumbnailers kdepim-addons korganizer materia-kde-yakuake plasma-discover-{flatpak,packagekit} plasma-firewall-ufw yakuake neochat 
)

# gnome packages
gnome_packages=(
    breeze-icons breeze gnome-tweaks thunar-archive-plugin thunar thunar-volman thunar-docs thunar-shares-plugin numlockx spectacle kitty gnome-commander spacefm xfce4-terminal thunar-archive-plugin
)

# software packages
software_packages=(
    blender boomaga digikam discord flameshot ghostwriter gimp gimp-data-extras gimp-help gparted inkscape krita ocrmypdf ocrmypdf+watcher ocrmypdf-doc tesseract pdfarranger rclone rclone-browser scribus simplescreenrecorder telegram-desktop uget variety vlc
)

# home only packages
home_only=(
	virt-manager discord virtualbox virtualbox-guest-additions 
)

# utilities for file system access
filesystem_utilities=(
	btrfs-assistant btrfs-progs btrbk btrfsmaintenance apfs-fuse disktype exfatprogs f2fs-tools fuse-sshfs hfsutils hfsplus-tools jfsutils lvm2 nilfs-utils ntfs-3g udftools xfsprogs timeshift
)

# system Shells
shells=(
    zsh zsh-autosuggestions zsh-lovers zsh-syntax-highlighting fish
)

# Install packages
install_packages() {
    echo -e "${ORANGE}$1${NC}"
    sudo dnf5 install -y  "${@:2}" || handle_error "Failed to install: $1"
    echo "Package installation completed."
}

# Install essential packages
install_packages "Installing Essential Packages" "${essential_packages[@]}"

# Install DE packages
install_packages "Installing KDE Packages" "${kde_packages[@]}"
#install_packages "Installing Gnome Packages" "${gnome_packages[@]}"

# Install Software Packages
install_packages "Installing Software Packages""${software_packages[@]}"

# Install filesystem utilities
install_packages "Installing utilities for different file system access" "${shells[@]}"

# Install Software Packages
install_packages "Installing ZSH / FISH shells and Plug-ins""${filesystem_utilities[@]}"

## Install Packages for home only
install_packages "Installing packages for use at home only" "${home_only[@]}"

# Install Sublime Text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf install sublime-text -y

# Install Klassy Global Theme plugin
# sudo dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:paul4us/Fedora_42/home:paul4us.repo
# sudo dnf install klassy -y

# Install Megasync
wget https://mega.nz/linux/repo/Fedora_42/x86_64/megasync-Fedora_42.x86_64.rpm && sudo dnf install "$PWD/megasync-Fedora_42.x86_64.rpm" -y

# Install Softmaker FreeOffice
sudo wget -qO /etc/yum.repos.d/softmaker.repo https://shop.softmaker.com/repo/softmaker.repo
sudo dnf update
sudo dnf install softmaker-freeoffice-2024 -y

echo "Package installation completed."

sleep 2

sudo systemctl enable --now earlyoom

sleep 2

	# Install some font tools and fonts
	display_message "[${GREEN}✔${NC}]  Installing some font tools and fonts"
sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig -y
	sudo dnf install -y fontawesome-fonts powerline-fonts 'google-roboto*' 'mozilla-fira*' fira-code-fonts meslo-nerd-fonts firacode-nerd-fonts
	sudo dnf install -y redhat-{mono,text,display}-{fonts,vf-fonts} xorg-x11-fonts-ISO8859-1-100dpi google-noto-emoji-color-fonts droidsansmono-nerd-fonts
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
	sudo mkdir -p ~/.local/share/fonts

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

		# Remove the ZIP file
		rm "$zip_file"

		display_message "[${GREEN}✔${NC}] Apple fonts installed successfully."
		echo ""
		gum spin --spinner dot --title "Re-thinking... 1 sec" -- sleep 2
	else
		display_message "[${RED}✘${NC}] Download failed. Please check the URL and try again."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi

	# Removing zip Files & recache fonts
#	rm ./WPS-FONTS.zip
	sudo fc-cache -f -v

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
	print_yellow 'Default sysctl.conf file Saved. Directory: /etc/sysctl.conf.bak'
	echo
	gum spin --spinner dot --title "Stand-by..." -- sleep 1

function cleanup_fedora() {
	# Clean package cache
	display_message "[${GREEN}✔${NC}]  Time to clean up system..."
	sudo dnf clean all

	# Remove unnecessary dependencies
	sudo dnf autoremove -y

	### Install Atuin - Shell History Replacement
#curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# 1st run register acct with this line
# atuin register
# run on another machine, use this to login
#atuin login
#atuin import auto
#atuin sync

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
echo -e "|--------------------------------------------|"
echo -e "|                                            |"
echo -e "|      Open a new temrinal window and type   |"
echo -e "|    	the following to setup Atuin         |"
echo -e "|          atuin login                       |"
echo -e "|          atuin import auto                 |"
echo -e "|          atuin sync                        |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

# exit 0

# exit 0
