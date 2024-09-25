#!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# 08 May 2024

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

# Initialize the variable skip_arco to false
skip_arco=false

# Ask the user if they want to install ArcoLinux Tools
while true; do
    read -p "Do you want to install ArcoLinux keys and packages? (y/n): " yn

    case $yn in
        [yY] ) echo "Ok, we will proceed."; break;;
        [nN] ) echo "Skipping ArcoLinux keys and packages installation..."; skip_arco=true; break;;
        * ) echo "Invalid response. Please enter y or n.";;
    esac
done

# If the user chooses not to install ArcoLinux keys and packages, skip related commands
if [ "$skip_arco" = true ]; then
    echo "Continuing without installing ArcoLinux keys and packages..."
else
    # Download ArcoLinux keys and packages
    execute_command wget bit.ly/get-arcolinux-keys
    execute_command chmod +x ./get-arcolinux-keys
    execute_command sudo ./get-arcolinux-keys
    execute_command sudo pacman -Syu --needed archlinux-tweak-tool-git
    execute_command sudo pacman -Sy --needed  aarcolinux-meta-utilities arcolinux-meta-log arcolinux-meta-fun arcolinux-meta-samba arcolinux-teamviewer sofirem-git arcolinux-meta-wine || continue #arcolinux-meta-btrfs-snapper
fi

# Continue with the rest of the script
echo "doing stuff..."



read -n 1 -r -s -p $'Press enter to continue...\n'

# Define colors
ORANGE='\033[0;33m'
NC='\033[0m'

# essantial software pckages
 essential_packages=(
    ca-certificates ca-certificates-mozilla ca-certificates-utils cifs-utils cjson codec2 gstreamer-vaapi gstreamer
    gtk-engine-murrine gtk-engines intel-media-driver iptables jq libffi libfreeaptx rabbitmq librist libsodium libtool
    libva-intel-driver libvdpau libvdpau-va-gl libxext mpg123 net-snmp net-tools nftables nsxiv openssh python sxiv
    python-pip python-setproctitle qrencode sassc socat openssl sshpass yay-git
    #grub-customizer pamac-aur
)

# optional software packages
optional_packages=(
    acl acpi aria2 attr autoconf automake bash-completion 
    bc binutils btop busybox appimagelauncher baobab blender cowsay curl dbus-glib dconf-editor dialog direnv discover wget vim zip
    dolphin-plugins duf earlyoom easyeffects espeak-ng fancontrol-gui-git fastfetch-git fd ffmpeg ffmpegthumbnailer ffmpegthumbs 
    figlet flatpak fortune-mod git github-cli grsync gnupg gparted grep debtap digikam discord etcher-bin find-the-command-git vlc
    ghostwriter gimp gimp-help-en gitkraken gparted gum haveged htop imagewriter inkscape wps-office telegram-desktop pdfarranger
    krita libreoffice-fresh megasync-bin lsd make mbedtls meld p7zip xournalpp font-manager the_platinum_searcher vscodium yt-dlp
    packagekit pkgconf mlocate powertop make mbedtls meld  mpg123 nano neovim uget zram-generator ventoy-bin zstd xclip scribus
    neovim-qt merkuro neochat octopi onlyoffice-bin rclone rhythmbox ripgrep ripgrep-all rsync rygel shotwell nano-syntax-highlighting 
    simplescreenrecorder-git sublime-text-4 screen tar terminator thermald tumbler ufw ufw-extras ugrep un{zip,rar} unrar-free variety 
)

# KDE Plamsa Pkgs
plasma_pkgs=(
    arcolinux-plasma-keybindings-git arcolinux-plasma-servicemenus-git akonadi akonadi-calendar-tools akonadi-calendar 
    akonadi-import-wizard kate kcalc kdegraphics-thumbnailers kdepim-addons flameshot-git plasma-firewall 
)

# Gnome Packages
gnome_pkgs+(
    )
# yay packages
yay_packages=(
    rclone-browser gimp-extras betterbird boomaga profile-sync-daemon
)

# utilities for file system access
filesystem_utilities=(
    btrfs-progs exfatprogs f2fs-tools jfsutils nilfs-utils ntfs-3g udftools xfsprogs
    #btrfs-assistant grub-btrfs btrfsmaintenance
)

# Terminal Shells
terminal_shells=(
    zsh zsh-autosuggestions-git zsh-completions zsh-fast-syntax-highlighting zsh-history-substring-search-git
    zsh-syntax-highlighting-git zsh-theme-powerlevel10k-git oh-my-zsh-git oh-my-zsh-powerline-theme-git bash
    bash-completion fish arcolinux-fish-git #bash-complete-alias oh-my-posh-bin
)

# Install packages
install_packages() {
    echo -e "${ORANGE}$1${NC}"
    sudo pacman -Sy --needed "${@:2}" || handle_error "Failed to install: $1"
    echo "Package installation completed."
}

# Install essential packages
install_packages "Installing Essential Software Packages" "${essential_packages[@]}"

# Install Terminal Shells
install_packages "Install Terminal Shells" "${terminal_shells[@]}"

# Install optional packages
install_packages "Installing Software Packages" "${optional_packages[@]}"
yay -Sy --needed "${yay_packages[@]}"

# Install filesystem utilities
install_packages "Installing utilities for different file system access" "${filesystem_utilities[@]}"

# Install some fonts
execute_command sudo pacman -Sy --needed ttf-font-awesome awesome-terminal-fonts powerline-fonts ttf-wps-fonts ttf-fira-code ttf-meslo-nerd || continue
yay -Sy --needed redhat-fonts || continue

sudo mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf || continue
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/San-Francisco-family/San-Francisco-family.sh)" || continue

sudo fc-cache -vf || continue

# Enable trim support
sudo systemctl enable fstrim.timer || continue

# Clear systemd journal logs
sudo journalctl --vacuum-time=7d || continue
echo "Systemd journal logs cleared."

# Clean up SSD
sudo fstrim -av || continue

echo -e "\n\n----------------------------------------------"
echo -e "|                                            |"
echo -e "|               Setup Complete!              |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
