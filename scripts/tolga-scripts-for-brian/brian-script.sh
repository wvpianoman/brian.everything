#!/usr/bin/env bash
# brian francisco packages
# tolga erok
# 《˘ ͜ʖ ˘》

# colours
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
cyan="\e[1;36m"
white="\e[1;37m"
orange="\e[1;93m"
nc="\e[0m"

clear 

# cache sudo
sudo -v

# charm repo
echo "[charm]
name=charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key" | sudo tee /etc/yum.repos.d/charm.repo

sudo dnf install -y gum openssh

display_message() {
  clear
  echo -e "\n ultramarine fedora updater\n"
  echo -e "${blue}|---------------- current task ----------------|${nc}"
  echo -e "${yellow}==>${nc} $1"
  echo -e "${blue}|----------------------------------------------|${nc}"
  gum spin --spinner dot --title "stand by..." -- sleep 1
}

is_service_active() {
  systemctl is-active "$1" &>/dev/null
}

print_yellow() {
  echo -e "${yellow}$1${nc}"
}

check_ssh() {
  if is_service_active sshd && ss -tnlp | grep -q ":22 "; then
    display_message "[${green}ok${nc}] ssh is running on port 22"
  else
    display_message "[${red}fail${nc}] ssh not active on port 22"
    sleep 2
  fi
}

# migration brians ultramarine
ultramarine() {
  bash <(curl -s https://ultramarine-linux.org/migrate.sh)
}

# check_ssh

# rpm fusion
sudo dnf install -y \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
  rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted

sudo dnf --repo=rpmfusion-nonfree-tainted install -y "*-firmware"

# terra repo fyralabs
sudo dnf install -y --repofrompath "terra,https://repos.fyralabs.com/terra\$releasever" \
  --setopt="terra.gpgkey=https://repos.fyralabs.com/terra\$releasever/key.asc" \
  terra-release

# essential packages
essential_packages=(
  acl aria2 attr autoconf automake bash-completion bc binutils btop busybox ca-certificates
  cifs-utils cjson codec2 cowsay crontabs curl dbus-glib dconf-editor dialog direnv
  dnf-plugins-core dnfdragora duf earlyoom easyeffects espeak espeak-ng fancontrol-gui
  fastfetch fd-find ffmpegthumbnailer figlet flatpak fonts-tweak-tool fortune-mod fuse
  fuse-libs git gnupg2 grep haveged hplip hplip-gui htop ibus-gtk4 iptables iptables-services
  jq kernel-modules-extra lsd make mbedtls meld mesa-filesystem mozilla-ublock-origin mpg123
  nano net-snmp net-tools nftables openssh openssh-clients openssh-server openssl ostree
  p7zip p7zip-gui p7zip-plugins pandoc python3 python3-pip python3-setproctitle qrencode
  ripgrep rsync rygel sassc screen socat soundconverter sshpass sxiv tar terminator tlp tlp-rdw
  tlpi tumbler tumbler-extras ugrep unrar-free unzip wget wsdd xclip zip zram zram-generator
  zram-generator-defaults zstd packagekit megacmd intel-media-driver pipewire-codec-aptx
)

kde_packages=(
  akonadi akonadi-calendar-tools akonadi-import-wizard arc-kde-yakuake dolphin-plugins
  fancontrol-gui-kcm fancontrol-gui-plasmoid ffmpegthumbs flameshot kate kate-plugins
  kdegraphics-thumbnailers kdepim-addons korganizer materia-kde-yakuake plasma-discover-flatpak
  plasma-discover-packagekit plasma-firewall-ufw yakuake neochat
)

gnome_packages=(
  breeze-icons breeze gnome-tweaks thunar-archive-plugin thunar thunar-volman
  thunar-shares-plugin spectacle kitty gnome-commander spacefm xfce4-terminal
)

cinnamon_packages=(
  numlockx cairo-dock cairo-dock-plugins
)

software_packages=(
  blender boomaga digikam flameshot ghostwriter gimp gimp-data-extras gimp-help
  gparted inkscape kitty krita ocrmypdf ocrmypdf-watcher ocrmypdf-doc tesseract pdfarranger
  rclone rclone-browser scribus soundconverter ufw uget variety vlc yad zed simplescreenrecorder
  telegram-desktop helix
)

home_only=(
  virt-manager virtualbox virtualbox-guest-additions
)

filesystem_utilities=(
  btrfs-assistant btrfs-progs btrbk btrfsmaintenance apfs-fuse disktype exfatprogs
  f2fs-tools fuse-sshfs hfsutils hfsplus-tools jfsutils lvm2 nilfs-utils ntfs-3g udftools
  xfsprogs timeshift
)

menu() {
    echo
    echo " Choose what you want to install brother"
    echo " ---------------------------------------"
    echo "  1 essential packages"
    echo "  2 kde packages"
    echo "  3 gnome packages"
    echo "  4 software packages"
    echo "  5 home packages"
    echo "  6 filesystem utilities"
    echo "  7 install everything"
    echo "  8 Install ultramarine migration"
    echo "  0 exit"
    echo " ---------------------------------------"  
    echo
    read -r -p "select option: " choice
}

while true; do
    clear
    menu

    case "$choice" in
        1)
            display_message "installing essential packages"
            sudo dnf install -y "${essential_packages[@]}"
            ;;
        2)
            display_message "installing kde packages"
            sudo dnf install -y "${kde_packages[@]}"
            ;;
        3)
            display_message "installing gnome packages"
            sudo dnf install -y "${gnome_packages[@]}"
            ;;
        4)
            display_message "installing software packages"
            sudo dnf install -y "${software_packages[@]}"
            ;;
        5)
            display_message "installing home packages"
            sudo dnf install -y "${home_only[@]}"
            ;;
        6)
            display_message "installing filesystem utilities"
            sudo dnf install -y "${filesystem_utilities[@]}"
            ;;
        7)
            display_message "installing everything"
            sudo dnf install -y \
                "${essential_packages[@]}" \
                "${kde_packages[@]}" \
                "${gnome_packages[@]}" \
                "${software_packages[@]}" \
                "${home_only[@]}" \
                "${filesystem_utilities[@]}"
            ;;
        8)
            display_message "Installing ultramarine"
            ultramarine
            ;;
        0)
            print_yellow "exiting setup"
            break
            ;;
        *)
            echo "invalid option try again"
            ;;
    esac
done

print_yellow "setup complete."
