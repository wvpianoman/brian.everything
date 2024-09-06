#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Jan 20 2024

#   《˘ ͜ʖ ˘》
#
#  ███████╗██╗██████╗ ██╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗    ██████╗ ██╗  ██╗ ██████╗ ███████╗
#  ██╔════╝██║██╔══██╗██║   ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║    ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
#  ███████╗██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██╔██╗ ██║    ██████╔╝█████╔╝ ██║  ███╗███████╗
#  ╚════██║██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██║╚██╗██║    ██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
#  ███████║██║██████╔╝╚██████╔╝╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║    ██║     ██║  ██╗╚██████╔╝███████║
#  ╚══════╝╚═╝╚═════╝  ╚═════╝  ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=siduction%20Pkgs

# Install some software:
software_packages=(
    shotwell transmission transmission-{remote-gtk,gtk,qt} syncthing syncthing-gtk blender blender-data gimp
    gimp-help-en krita scribus scribus-doc telegram-desktop inkscape power-profiles-daemon variety rclone
    rclone-browser grep ugrep ripgrep meld pandoc fortune-mod fortunes-min fortunes-debian-hints font-manager
    fortunes-bofh-excuses direnv boomaga tlp tlp-rdw powertop espeak figlet gedit  grub-customizer
    rygel wsdd uget aria2 lsd sxiv flameshot btop duf fonts-powerline simplescreenrecorder scribus-template
    )

software_explanations=(
"aria2                            : High speed download utility"
"blender                          : Very fast and versatile 3D modeller/renderer"
"blender-data                     : Very fast and versatile 3D modeller/renderer - data pack"
"boomaga                          : virtual printer for viewing a document before printing"
"btop                             : Modern and colorful command line resource monitor that shows usage and stats"
"cookietool                       : suite of programs to help maintain a fortune database"
"direnv                           : Utility to set directory specific environment variables"
"duf                              : Disk Usage/Free Utility"
"espeak                           : Multi-lingual software speech synthesizer"
"figlet                           : Make large character ASCII banners out of ordinary text"
"flameshot                        : Powerful yet simple to use screenshot software."
"font-manager                     : font management application for the GNOME desktop"
"fonts-powerline  #####                ; prompt and statusline utility (symbols font)"
"fortune-mod                      : provides fortune cookies on demand"
"fortunes                         : Data files containing fortune cookies"
"fortunes-bofh-excuses            : Description: BOFH excuses for fortune"
"fortunes-debian-hints            : Debian Hints for fortune"
"fortunes-min                     : Data files containing selected fortune cookies"
"gedit                            : popular text editor for the GNOME desktop environment"
"gimp                             : GNU Image Manipulation Program"
"gimp-help-en                     : Documentation for GIMP (English)"
"grep                             : GNU grep. egrep and fgrep"
"grub-customizer                  : GUI to configure GRUB2 and BURG"
"inkscape                         : vector-based drawing program"
"krita                            : pixel-based image manipulation program"
"lsd                              : ls command with a lot of pretty colors and some other stuff"
"meld                             : graphical tool to diff and merge files"
"pandoc                           : general markup converter"
"power-profiles-daemon            : Makes power profiles handling available over D-Bus"
"powertop                         : diagnose issues with power consumption and management"
"rclone                           : rsync for commercial cloud storage"
"rclone-browser                   : Simple cross platform GUI for rclone"
"ripgrep                          : recursively searches your current directory for a regex"
"rygel                            : GNOME UPnP/DLNA services"
"scribus                          : Open Source Desktop Page Layout"
"scribus-doc                      : Documentation for Scribus"
"scribus-template                 : additional scribus templates"
"shotwell                         : Digital Photo Organizer"
"simplescreenrecorder             : Feature-rich screen recorder for X11 and OpenGL"
"sxiv                             : simple X image viewer"
"telegram-desktop                 : fast and secure mnessaging application"
"tlp                              : feature-rich command-line utility, saving laptop battery power"
"tlp-rdw                          : TLP Radio device wizard providing event based switching of bluetooth, NFC, Wi-Fi and WWAN"
"transmission                     : Lightweight BitTorrent Client"
"transmission-{remote-gtk,gtk,qt} : Lightweight BitTorrent Client (GTK+ & QT Interface)"
"uget                             : easy-to-use download manager written in GTK+"
"ugrep                            : faster grep with an interactive query GUI"
"variety                          : Wallpaper changer, downloader and manager"
"wsdd                             : Python Web Services Discovery Daemon, Windows Net Browsing"
)

echo "The following packages will be installed:"
for ((i = 0; i < ${#software_packages[@]}; i++)); do
    echo "- ${software_explanations[i]}"
done

echo
read -p "Do you want to proceed with the installation? (y/n): " choice

if [[ $choice =~ ^[Yy]$ ]]; then
    echo "Installing the packages..."
    sudo apt install -y "${software_packages[@]}"
    echo "Package installation completed."
else
    echo "Package installation skipped."
fi
#Install gum : A tool for glamorous shell scripts. https://github.com/charmbracelet/gum

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum

# Install & enable earlyoom
sudo apt install earlyoom
sudo systemctl enable --now earlyoom

# Support for additional file systems:
filesystem_packages=(
    btrfs-progs exfatprogs f2fs-tools hfsprogs hfsplus jfsutils lvm2 nilfs-tools
    reiserfsprogs reiser4progs udftools xfsprogs disktype
)

filesystem_explanations=(
    "btrfs-progs              : Tools for managing Btrfs file systems."
    "disktype                 : Detects the content format of a disk or disk image."
    "exfatprogs               : Utilities for exFAT file system."
    "f2fs-tools               : Utilities for Flash-Friendly File System (F2FS)."
    "hfsplus                  : Tools for HFS+ file system."
    "hfsprogs                 : Tools for HFS and HFS+ file systems."
    "jfsutils                 : Utilities for JFS (Journaled File System)."
    "lvm2                     : Logical Volume Manager 2 utilities."
    "nilfs-tools              : Tools for NILFS (New Implementation of a Log-structured File System)."
    "reiser4progs             : Tools for Reiser4 file system."
    "reiserfsprogs            : Tools for ReiserFS file system."
    "udftools                 : Tools for UDF (Universal Disk Format) file system."
    "xfsprogs                 : Tools for managing XFS file systems."
)

echo "The following packages will be installed:"
for ((i = 0; i < ${#filesystem_packages[@]}; i++)); do
    echo "- ${filesystem_explanations[i]}"
done

echo
read -p "Do you want to proceed with the installation? (y/n): " choice

if [[ $choice =~ ^[Yy]$ ]]; then
    echo "Installing the packages..."
    sudo apt install -y "${filesystem_packages[@]}"
    echo "Package installation completed."
else
    echo "Package installation skipped."
fi

    # Install firmware for AMD GPU
    sudo apt update
    sudo apt install firmware-amd-graphics -y
    echo "AMD GPU firmware installed successfully."


####################################################################

# Install some software:
software_packages2=(
    acl attr cifs-utils dnsutils ffmpeg ffmpegthumbnailer firmware-realtek flatpak
    gdebi gnome-software-plugin-flatpak gstreamer1.0-libav gstreamer1.0-plugins-bad
    gstreamer1.0-plugins-ugly gstreamer1.0-tools gstreamer1.0-vaapi htop
    kdegraphics-thumbnailers libavcodec-extra neofetch ntp ntpdate
    plasma-discover-backend-flatpak plocate python3-setproctitle rhythmbox
    simplescreenrecorder snmp software-properties-common sntp synaptic terminator
    ttf-mscorefonts-installer tumbler-plugins-extra vlc  rar unrar p7zip-rar nvidia-detect
    plasma-discover-backend-fwupd plasma-discover-backend-snap
)

software_explanations2=(
    "acl:                                Access control list utilities for file permissions management."
    "attr:                               Tools for managing extended attributes on filesystems."
    "cifs-utils:                         Utilities for mounting and managing CIFS/SMB file systems."
    "dnsutils:                           DNS utilities for querying DNS servers."
    "ffmpeg:                             Complete, cross-platform solution for recording, converting, and streaming audio and video."
    "ffmpegthumbnailer:                  Lightweight video thumbnailer."
    "firmware-realtek:                   Firmware files for Realtek WiFi cards."
    "flatpak:                            Application sandboxing and distribution framework."
    "gdebi:                              Simple tool for installing deb packages."
    "gnome-software-plugin-flatpak:      GNOME Software plugin for Flatpak integration."
    "gstreamer1.0-libav:                 GStreamer plugins for the libav codec library."
    "gstreamer1.0-plugins-bad:           GStreamer plugins from the 'bad' set."
    "gstreamer1.0-plugins-ugly:          GStreamer plugins from the 'ugly' set."
    "gstreamer1.0-tools:                 Tools for GStreamer multimedia framework."
    "gstreamer1.0-vaapi:                 GStreamer plugins for video decoding/encoding using VA-API."
    "htop:                               Interactive process viewer and system monitor."
    "kdegraphics-thumbnailers:           Graphics file format thumbnailers for KDE."
    "libavcodec-extra:                   Extra multimedia codecs for libavcodec."
    "neofetch:                           Fast, highly customizable system info script."
    "ntp:                                Network Time Protocol daemon and utility programs."
    "ntpdate:                            Client for setting system time from NTP servers."
    "plasma-discover-backend-flatpak:    Flatpak backend for Plasma Discover."
    "plasma-discover-backend-fwupd:      Discover software management suite - fwupd backend"
    "plasma-discover-backend-snap:       Discover software management suite - Snap backend"
    "plocate:                            Fast filesystem search tool."
    "python3-setproctitle:               Allow customization of the process title."
    "rhythmbox:                          Music player and organizer for GNOME."
    "simplescreenrecorder:               Screen recorder for Linux."
    "snmp:                               SNMP (Simple Network Management Protocol) applications."
    "software-properties-common:         Software properties common utilities."
    "sntp:                               Simple Network Time Protocol (SNTP) client."
    "synaptic:                           Graphical package manager for apt."
    "terminator:                         Multiple GNOME terminals in one window."
    "ttf-mscorefonts-installer:          Installer for Microsoft TrueType core fonts."
    "tumbler-plugins-extra:              Additional plugins for the tumbler thumbnail rendering service."
    "vlc:                                Multimedia player and streaming server."
    "rar:                                Archive manager for RAR files."
    "unrar:                              Extract files from RAR archives."
    "p7zip-rar:                          RAR support for p7zip."
    "nvidia-detect:                      NVIDIA GPU detection utility."
)

echo "The following packages will be installed:"
for ((i = 0; i < ${#software_packages2[@]}; i++)); do
    echo "- ${software_explanations2[i]}"
done

echo
read -p "Do you want to proceed with the installation? (y/n): " choice

if [[ $choice =~ ^[Yy]$ ]]; then
    echo "Installing the packages..."
    sudo apt install -y "${software_packages2[@]}"
    echo "Package installation completed."
else
    echo "Package installation skipped."
fi

#################################################################################

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
sudo apt install fontawesome-fonts fontawesome-fonts-web
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
echo -e "|        Setup Complete! Enjoy debian!       |"
echo -e "|       Please run placeholder.sh            |"
echo -e "|    to back up your APT packages and more   |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

exit 0
