#!/usr/bin/env bash

# Brian's Packages
# Dec 30 2024
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

# add Cachy Repo to BigLinux
echo -e "This script is about to run another script."
# sh ./add-cachy.sh
echo -e "This script has just run another script."

# add sublime text repo and install sublime text 4
# curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
# echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

sudo pacman -Syu sublime-text

# essantial software pckages
essential=(
    acl aria2 attr autoconf automake bash-completion bc binutils btop busybox perl-mozilla-ca python-certifi cjson curl dialog duf easyeffects espeak-ng fd findutils ffmpeg ffmpegthumbnailer flatpak git zstd gnupg lolcat fortune-mod ufw grep gum ibus iptables jq lsd make meld mpg123 nano fastfetch net-snmp nftables gum git-lfs figlet direnv un{zip,rar} openssh p7zip packagekit pandoc pipewire kpipewire wget httpie wsdd xclip zip zram-generator variety font-manager zed plocate powertop python3 python-setproctitle qrencode ripgrep ripgrep-all rsync rygel sassc screen socat sshpass nsxiv tar terminator thefuck thermald tumbler gufw zenity hardinfo2 manjaro-pacnew-checker python-pyqt6 sed yad tldr yay
)

# software packages
software=(
    akonadi-import-wizard dolphin-plugins ffmpegthumbs flameshot kate kdegraphics-thumbnailers kdepim-addons yakuake korganizer packagekit blender btrbk gimp krita inkscape digikam rclone rclone-browser rhythmbox shotwell simplescreenrecorder github-cli telegram-desktop deja-dup soundconverter obs-studio scribus uget vlc onlyoffice-bin masterpdfeditor-free pdfarranger firefox-adblock-plus firefox-dark-reader hblock freeoffice gitkraken gimagereader-qt hblock xournalpp gpu-screen-recorder lact diffuse impression mission-center cherrytree ocrfeeder ghostwriter paperwork micro gparted google-chrome waveterm waterfox-bin firefox helix 
)

# utilities for file system access
filesystem=(
    btrfs-progs dosfstools e2fsprogs exfatprogs f2fs-tools hfsprogs jfsutils lvm2 nilfs-utils ntfs-3g udftools xfsprogs
)

# utilities for file system access
shells=(
    zsh zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete find-the-command bash-complete-alias fish oh-my-posh
)

# AUR specific packages
aur_packages=(
    boomaga fresh-editor
)

# print formatted headers
print_header() {
 # clear
  echo -e "\n\033[94m=============================\033[0m"
  echo -e "\033[1;94m$1\033[0m"
  echo -e "\033[94m=============================\033[0m\n"
}

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
    yay "$package"
  done
  echo
}

# Install essential packages
install_packages "Installing Essential Software Packages" "${essential[@]}"

# Install Software Packages
install_packages "Installing Software Packages""${software[@]}"

# Install filesystem utilities
install_packages "Installing utilities for different file system access" "${filesystem[@]}"

# Install Software Packages
install_packages "Installing shells and Plug-ins""${shells[@]}"

# Install packages from the AUR
install_aur "Installing AUR specific packages""${aur_packages[@]}"

# Install some fonts

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
    yay "$package"
  done
  echo
}

# Main script
print_header "Installing Recommended Fonts"
install_packages "Recommended fonts for comprehensive coverage:" \
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

print_header "Optional but Highly Recommended Fonts"
install_packages "Adding optional but highly recommended fonts for broader compatibility:" \
  ttf-liberation ttf-dejavu ttf-roboto ttf-symbola

print_header "Fonts Available on the AUR"
install_aur "Installing fonts available on the Arch User Repository:" \
  redhat-fonts times-newer-roman ttf-times-new-roman

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
