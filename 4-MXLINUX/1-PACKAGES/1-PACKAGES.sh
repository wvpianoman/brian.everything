#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Jan 20 2024
#   《˘ ͜ʖ ˘》

# Install some software:

    echo "Installing essential packages..."

sudo apt install -y --install-recommends acl akonadi-import-wizard aria2 attr autoconf automake bash-completion bc binutils btop busybox ca-certificates cifs-utils libcjson1 codec2 cookietool cowsay cron curl gir1.2-dbusglib-1.0 dconf-editor dialog direnv

sudo apt install -y --install-recommends dnsutils dolphin-plugins duf earlyoom easyeffects espeak espeak-ng fancontrol mbpfan fd-find ffmpeg ffmpegthumbnailer ffmpegthumbs figlet firmware-realtek flatpak fortune-mod fortunes fortunes-min gdebi git gnupg2 grep grub-customizer

sudo apt install -y --install-recommends gstreamer1.0-{libav,vaapi} gstreamer1.0-plugins-{bad,base,good,rtp,ugly} gtk2-engines-murrine murrine-themes uim-gtk{2.0,3} uim-gtk{2.0,3}-immodule uim-qt5 uim-qt5-immodule gtk2-engines haveged ibus-gtk4 intel-media-va-driver iptables jq

sudo apt install -y --install-recommends kate kdegraphics-thumbnailers kdepim libavcodec-extra libffi8 libffi-dev libfreeaptx0 libgc1 librabbitmq4 librabbitmq-dev librist4 libsodium23 libsodium-dev libtool libvdpau1 libvdpau-va-gl1 libxext6 llvm-16 lsd make meld libegl1-mesa

sudo apt install -y --install-recommends libgl{u,w}1-mesa mesa-va-drivers mesa-vulkan-drivers ublock-origin-doc webext-ublock-origin-firefox mpg123 nano neofetch neovim neovim-qt snmpd net-tools nftables openssh-{client,server} ostree p7zip p7zip-full p7zip-rar packagekit pandoc pip

sudo apt install -y --install-recommends pipewire-{audio,doc} pkg-config plasma-discover-backend-{flatpak,fwupd} plasma-firewall plocate powertop python3 python3-pip python3-setproctitle qrencode ripgrep rsync rygel sassc screen socat sshpass sxiv

sudo apt install -y --install-recommends tar terminator thefuck tlp tlp-rdw tlpui tumbler tumbler-plugins-extra ufw ugrep un{zip,rar} unrar-free variety vim virt-manager webext-ublock-origin-chromium wget wget2 wsdd xclip zip systemd-zram-generator zramswap-sysvinit-compat zram-tools zstd

echo "Package installation completed."
    sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

#Install gum : A tool for glamorous shell scripts. https://github.com/charmbracelet/gum
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum

sudo apt install earlyoom
sudo systemctl enable --now earlyoom

echo "Installiong Software Packages"

sudo apt install -y --install-recommends blender blender-data ghostwriter gimp gimp-help-en krita inkscape boomaga digikam flameshot kdepim kdepim-addons neochat rclone rclone-browser rhythmbox scribus scribus-doc scribus-template shotwell simplescreenrecorder syncthing syncthing-gtk telegram-desktop uget vlc yakuake

echo "Package installation completed."
    sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

echo "Installing utilites for different file system access"
# Support for additional file systems:

    sudo apt install -y --install-recommends btrfs-progs exfatprogs f2fs-tools hfsprogs hfsplus hfsutils jfsutils lvm2 nilfs-tools reiserfsprogs reiser4progs udftools xfsprogs disktype apfs-dkms apfsprogs libfsapfs-utils libfsapfs1 exfat-fuse

echo "Installation completed."
    sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

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

# Installing fonts
sudo apt install fonts-font-awesome fonts-noto-color-emoji xfonts-100dpi fonts-noto-color-emoji
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
echo -e "|        Setup Complete! Enjoy MX!           |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
