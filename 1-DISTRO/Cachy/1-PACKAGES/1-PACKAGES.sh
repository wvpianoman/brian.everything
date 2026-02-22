#!/usr/bin/env bash
# Brian Francisco Packages
# 21 Feb 2026
#   《˘ ͜ʖ ˘》

# Inpiration and guidance from Tolga Erok 

# Assign a color variable based on the RANDOM number
BLUE='\e[1;34m'
CYAN='\e[1;36m'
GREEN='\e[1;32m'
NC='\033[0m'
ORANGE='\033[0;33m'
RED='\e[1;31m'
WHITE='\e[1;37m'
YELLOW='\e[1;33m'

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

# add chaotic AUR mirrorlist & keys
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf

#add sublime text repo and install sublime text 4
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

sudo pacman -Syu sublime-text

# essantial software pckages
essential_packages=(
    acl aria2 attr autoconf automake bash-completion bc binutils btop busybox cjson curl dialog duf easyeffects espeak-ng fd ffmpeg ffmpegthumbnailer findutils flatpak font-manager fortune-mod git gnupg gufw hardinfo2 httpie kpipewire libappimage lolcat nsxiv openssh p7zip pandoc perl-mozilla-ca pipewire plocate powertop python-certifi python-pyqt6 python-setproctitle python3 qrencode ripgrep ripgrep-all rsync rygel sassc screen socat sshpass tar terminator thefuck thermald tumbler ufw variety wget wsdd xclip yad yay zed zip zram-generator zstd
)

# cinnamon packages
cinnamon_packages=(
    numlockx cairo-dock cairo-dock-plug-ins kitty fuse gedit xarchiver pcmanfm thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin tumbler ark thunar-vcs-plugin thunar-shares-plugin gtkhash-thunar plank-reloaded-git
)

# kde packages
kde_packages=(
    akonadi-import-wizard dolphin-plugins ffmpegthumbs flameshot kate kdegraphics-thumbnailers kdepim-addons yakuake korganizer packagekit print-manager
)

# software packages
software_packages=(
    blender btrbk cherrytree deja-dup diffuse digikam firefox-adblock-plus firefox-adblock-plus firefox-dark-reader firefox-dark-reader freeoffice ghostwriter gimagereader-qt gimp github-cli gitkraken google-chrome gparted gpu-screen-recorder hblock hblock impression inkscape krita lact masterpdfeditor-free mission-center obs-studio ocrfeeder octopi onlyoffice-bin paperwork pdfarranger pdfarranger rclone rclone-browser rhythmbox scribus shotwell soundconverter telegram-desktop uget xournalpp helix fresh-editor bleachbit
)

# utilities for file system access
filesystem_utilities=(
    btrfs-progs dosfstools e2fsprogs exfatprogs exfat-utils f2fs-tools hfsprogs jfsutils lvm2 nilfs-utils ntfs-3g udftools xfsprogs
)

# utilities for file system access
shells=(
    zsh zsh-autosuggestions zsh-syntax-highlighting fish oh-my-posh
)

# AUR specific packages
aur_packages=(
    tlrc boomaga
)

# Install packages
install_packages() {
    echo -e "${ORANGE}$1${NC}"
    sudo pacman -Sy --noconfirm --needed "${@:2}" || handle_error "Failed to install: $1"
    echo "Package installation completed."
}

# AUR installations with a message
install_aur() {
  local msg="$1"
  shift
  echo -e "\033[92m$msg\033[0m"
  for package in "$@"; do
    echo -e "  - Installing \033[93m$package\033[0m from AUR..."
    paru -S "$package"
  done
  echo
}

# Install essential packages
install_packages "Installing Essential Software Packages" "${essential_packages[@]}"

# Install DE packages
# Pick Cinnamon or KDE
# install_packages "Installing Cinnamon Packages" "${cinnamon_packages[@]}"
install_packages "Installing KDE Packages" "${kde_packages[@]}"

# Install Software Packages
install_packages "Installing Software Packages""${software_packages[@]}"

# Install filesystem utilities
install_packages "Installing utilities for different file system access" "${filesystem_utilities[@]}"

# Install Software Packages
install_packages "Installing shells and Plug-ins""${shells[@]}"

# install fisher pluh-in manager for fish shell
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# install tide prompt
fisher install IlanCosman/tide@v6

# Install packages from the AUR
install_aur "Installing AUR specific packages""${aur_packages[@]}"

# Configuration to install custom fonts
# ----------------------------------------------------------------------------

# print formatted headers
print_header() {
 # clear
  echo -e "\n\033[94m=============================\033[0m"
  echo -e "\033[1;94m$1\033[0m"
  echo -e "\033[94m=============================\033[0m\n"
}

# install packages with a message
install_packages() {
  local msg="$1"
  shift
  echo -e "\033[92m$msg\033[0m"
  for package in "$@"; do
    echo -e "  - Installing \033[93m$package\033[0m..."
    sudo pacman -Sy --noconfirm --needed "$package"
  done
  echo
}

# AUR installations with a message
install_aur() {
  local msg="$1"
  shift
  echo -e "\033[92m$msg\033[0m"
  for package in "$@"; do
    echo -e "  - Installing \033[93m$package\033[0m from AUR..."
    paru -S "$package"
  done
  echo
}

print_header "Installing Recommended Fonts"
install_packages "Recommended fonts for comprehensive coverage:" \
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

print_header "Optional but Highly Recommended Fonts"
install_packages "Adding optional but highly recommended fonts for broader compatibility:" \
  ttf-liberation ttf-dejavu ttf-roboto times-newer-roman ttf-times-new-roman ttf-symbola

print_header "Fonts Available on the AUR"
install_aur "Installing fonts available on the Arch User Repository:" \
  redhat-fonts times-newer-roman #ttf-times-new-roman

print_header "Popular Monospaced Fonts"
install_packages "Enhancing your experience with popular monospaced fonts:" \
  ttf-jetbrains-mono ttf-fira-code ttf-hack adobe-source-code-pro-fonts

print_header "Apple Fonts"
install_packages "Adding Apple fonts:" \
  apple-fonts
  
echo -e "\033[92mFont installation complete!\033[0m"

# Reloading Font
sudo fc-cache -vf

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

