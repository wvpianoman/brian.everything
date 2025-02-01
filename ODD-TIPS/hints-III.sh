#!/bin/bash

# Tolga Erok
# for
# Brian
# 4/3/2024


clear

# Function to install packages using apt package manager (debian)
install_debian_packages() {
    local software_packages=("$@")
    echo "The following packages will be installed:"
    for ((i = 0; i < ${#software_packages[@]}; i++)); do
        echo "- ${software_packages[i]}"
        echo "Explanation: ${software_explanations[i]}"
        sleep 3
    done

    read -p "Do you want to proceed with the installation? (y/n): " choice

    if [[ $choice =~ ^[Yy]$ ]]; then
        echo "Installing the packages using apt..."
        sudo apt install -y --install-recommends "${software_packages[@]}"
        echo "Package installation completed."
    else
        echo "Package installation skipped."
    fi
}

# Function to install packages using Solus package manager
install_solus_packages() {
    local software_packages=("$@")
    echo "The following packages will be installed:"
    for ((i = 0; i < ${#software_packages[@]}; i++)); do
        echo "- ${software_packages[i]}"
        echo "Explanation: ${software_explanations[i]}"
        sleep 3
    done

    read -p "Do you want to proceed with the installation? (y/n): " choice

    if [[ $choice =~ ^[Yy]$ ]]; then
        echo "Installing the packages using eopkg..."
        sudo eopkg install -y "${software_packages[@]}"
        echo "Package installation completed."
    else
        echo "Package installation skipped."
    fi
}

# Software packages to be installed in an array/index
declare -a software_packages=(
    acl arc-kde-yakuake aria2 attr autoconf automake bash-completion bc binutils btop busybox ca-certificates cifs-utils cjson codec2 cowsay crontabs curl dbus-glib dconf-editor dialog direnv dnf-plugins-core dnf-utils dnsutils duf earlyoom easyeffects espeak espeak-ng
    fancontrol-{gui,gui-kcm,gui-plasmoid} fastfetch fd-find ffmpeg ffmpeg-libs ffmpegthumbnailer ffmpegthumbs figlet flatpak font-manager fortune-mod git gnome-font-viewer gnupg2 google-noto-emoji-color-fonts grep grub-customizer gstreamer1.0-{libav,vaapi}
    gstreamer1.0-plugins-{bad-free,bad-free-extras,good,good-extras,ugly,ugly-free} gtk-murrine-engine gtk{2,3}-immodule-xim gtk2-engines haveged htop ibus-gtk4 intel-media-driver iptables iptables-services jq kate libavcodec-{free,freeworld} libdvdcss
    libffi-devel libfreeaptx libfreeaptx-tools libgcab1 librabbitmq librabbitmq-tools librist libsodium libsodium-devel libtool libva-intel-driver libvdpau libvdpau-va-gl libXext llvm16-libs lpcnetfreedv lsd make materia-kde-yakuake mbedtls meld mesa-{libGL,libGLU,libd3d}-devel
    mesa-filesystem mesa-libEGL mesa-libGL mesa-libGL{w,U} mesa-libglapi mesa-libO{penCL,SMesa} mesa-va-drivers mesa-vulkan-drivers mozilla-ublock-origin mpg123 nano neofetch neovim neovim-qt net-snmp net-tools nftables openssh openssh-{client,server} ostree
    p7zip p7zip-gui p7zip-plugins PackageKit pandoc pip pipewire-codec-aptx pkg-config plasma-discover-{flatpak,packagekit,snap} plasma-firewall-ufw plocate pluginskdegraphics-thumbnailers powertop pulseeffects python3 python3-pip python3-setproctitle qrencode
    rclone rclone-browser ripgrep rsync rygel sassc screen socat openssl-devel sshpass sxiv tar terminator tlp tlp-rdw tlpi tumbler tumbler-extra ufw ufw-kde ugrep un{zip,rar} unrar-free variety vim virt-manager wget wsdd xclip xorg-x11-fonts-ISO8859-1-100dpi
    zip zram zram-generator zram-generator-defaults zstd
)

# Explanations..tried my best to explain them
declare -a software_explanations=(
    "acl                               Access control list utilities for file permissions management."
    "aria2                             High speed download utility"
    "attr                              Tools for managing extended attributes on filesystems."
    "btop                              Modern and colorful command line resource monitor that shows usage and stats"
    "cifs-utils                        Utilities for mounting and managing CIFS/SMB file systems."
    "cjson                             Ultralightweight JSON parser in ANSI C"
    "codec2                            Next-Generation Digital Voice for Two-Way Radio"
    "cowsay                            Configurable speaking/thinking cow"
    "curl                              A utility for getting files from remote servers (FTP, HTTP, and others)"
    "dbus-glib                         GLib bindings for D-Bus"
    "dconf-editor                      Configuration editor for dconf"
    "direnv                            Utility to set directory specific environment variables"
    "duf                               Disk Usage/Free Utility"
    "earlyoom                          Early OOM Daemon"
    "espeak                            Multi-lingual software speech synthesizer"
    "espeak-ng                         eSpeak Next Geberation open source speech synthesizer"
    "easyeffects                       Audio effects for PipeWire applications"
    "fancontrol                        utility to control the fan speed (GUI, KCM and Plasmoid)"
    "fastfetch                         Like neofetch, but much faster because written in c"
    "fd-find                           Fd is a simple, fast and user-friendly alternative to find"
    "ffmpeg                            Complete, cross-platform solution for recording, converting, and streaming audio and video."
    "ffmpeg-libs                       Libraries for ffmpeg"
    "ffmpegthumbnailer                 Lightweight video thumbnailer that can be used by file managers"
    "ffmpegthumbs                      KDE ffmpegthumbnailer service"
    "figlet                            Make large character ASCII banners out of ordinary text"
    "flatpak                           Application sandboxing and distribution framework."
    "font-manager                      font management application for the GNOME desktop"
    "fortune-mod                       provides fortune cookies on demand"
    "git                               Fast Version Control System"
    "gnome-font-viewer                 Utility for previewing fonts for GNOME"
    "google-noto-emoji-color-fonts     Google “Noto Color Emoji” colored emoji font"
    "grep                              GNU grep. egrep and fgrep"
    "grub-customizer                   GUI to configure GRUB2 and BURG"
    "gstreamer1-libav                  GStreamer plugins for the libav codec library."
    "gstreamer1-plugins-bad-free       GStreamer plugins from the 'bad' set (+ extras)."
    "gstreamer1-plugins-good           GStreamer plugins with good code and licensing (+ extras)"
    "gstreamer1-plugins-ugly           GStreamer plugins from the 'ugly' set (+ free)."
    "gstreamer1.0-vaapi                GStreamer plugins for video decoding/encoding using VA-API."
    "gtk-murrine-engine                Murrine GTK2 engine"
    "gtk2-engines                      Murrine GTK2 engine"
    "gtk2-immodule-xim                 XIM support for GTK+"
    "gtk3                              GTK+ graphical user interface library"
    "gtk3-immodule-xim                 XIM support for GTK+"
    "ibus-gtk4                         IBus IM module for GTK4"
    "intel-media-driver                The Intel Media Driver for VAAPI"
    "kate                              Advanced Text Editor"
    "kate-plugins                      Kate plugins"
    "kdegraphics-thumbnailers          Graphics file format thumbnailers for KDE."
    "libavcodec-free                   FFmpeg codec library"
    "libavcodec-freeworld              Freeworld libavcodec to complement the distro counterparts"
    "libdvdcss                         A portable abstraction library for DVD decryption"
    "libffi-devel                      Development files for libffi"
    "libfreeaptx                       Open Source implementation of Audio Processing Technology codec (aptX)"
    "libfreeaptx-tools                 libfreeaptx encoder and decoder utilities"
    "libgcab1                          Library to create Cabinet archives"
    "librabbitmq                       Client library for AMQP"
    "librabbitmq-tools                 Example tools built using the librabbitmq package"
    "librist                           Library for Reliable Internet Stream Transport (RIST) protocol"
    "libva-intel-driver                HW video decode support for Intel integrated graphics"
    "libvdpau                          Wrapper library for the Video Decode and Presentation API"
    "libvdpau-va-gl                    VDPAU driver with OpenGL/VAAPI back-end"
    "libXext                           X.Org X11 libXext runtime library"
    "llvm16-libs                       LLVM shared libraries"
    "lpcnetfreedv                      LPCNet for FreeDV"
    "lsd                               ls command with a lot of pretty colors and some other stuff"
    "mbedtls                           Light-weight cryptographic and SSL/TLS library"
    "meld                              graphical tool to diff and merge files"
    "mesa-filesystem                   Mesa driver filesystem"
    "mesa-libd3d-devel                 Mesa Direct3D9 state tracker development package"
    "mesa-libEGL                       Mesa libEGL runtime libraries"
    "mesa-libGL                        Mesa libGL runtime libraries"
    "mesa-libGL-devel                  Mesa libGL development package"
    "mesa-libglapi                     Mesa shared glapi"
    "mesa-libGLw                       Motif OpenGL widgets"
    "mesa-libGLU                       Mesa libGLU library"
    "mesa-libGLU-devel                 Development files for mesa-libGLU"
    "mesa-libOpenCL                    Mesa OpenCL runtime library"
    "mesa-libOSMesa                    Mesa offscreen rendering libraries"
    "mesa-va-drivers                   Mesa-based VA-API video acceleration drivers"
    "mesa-vulkan-drivers               Mesa Vulkan drivers"
    "mozilla-ublock-origin             An efficient blocker for Firefox"
    "mpg123                            Real time MPEG 1.0/2.0/2.5 audio player/decoder for layers 1, 2 and 3"
    "nano                              A small text editor"
    "neofetch                          Fast, highly customizable system info script."
    "net-snmp                          A collection of SNMP (Simple Network Management Protocol) tools and libraries"
    "openssh                           An open source implementation of SSH protocol version 2"
    "openssh-clients                   An open source SSH client applications"
    "openssh-server                    An open source SSH server daemon"
    "openssl-devel                     Files for development of applications which will use OpenSSL"
    "ostree                            Tool for managing bootable, immutable filesystem trees"
    "p7zip                             Very high compression ratio file archiver"
    "p7zip-plugins                     Additional plugins for p7zip"
    "p7zip-gui                         7zG - 7-Zip GUI version"
    "PackageKit                        Package management service"
    "pandoc                            general markup converter"
    "pipewire-codec-aptx               PipeWire Bluetooth aptX codec plugin"
    "plasma-discover-flatpak           Plasma Discover flatpak support"
    "plasma-discover-packagekit        Plasma Discover PackageKit support"
    "plasma-discover-snap              Plasma Discover snap support"
    "plocate                           Fast filesystem search tool."
    "powertop                          diagnose issues with power consumption and management"
    "pulseeffects                      advanced audio manipulation tools"
    "python3                           General-purpose, high-level programming language supporting multiple programming paradigms"
    "python3-pip                       A tool for installing and managing Python3 packages"
    "python3-setproctitle              Allow customization of the process title."
    "rclone                            rsync for commercial cloud storage"
    "rclone-browser                    Simple cross platform GUI for rclone"
    "ripgrep                           recursively searches your current directory for a regex"
    "rsync                             A program for synchronizing files over a network"
    "rygel                             GNOME UPnP/DLNA services"
    "sassc                             Wrapper around libsass to compile CSS stylesheet"
    "sshpass                           Non-interactive SSH authentication utility"
    "sxiv                              simple X image viewer"
    "tar                               GNU file archiving program"
    "terminator                        Multiple GNOME terminals in one window."
    "tlp                               feature-rich command-line utility, saving laptop battery power"
    "tlp-rdw                           TLP Radio device wizard providing event based switching of bluetooth, NFC, Wi-Fi and WWAN"
    "tlpi                              Utilities to display namespaces and control groups"
    "tumbler                           D-Bus service for applications to request thumbnails"
    "tumbler-extra                     Additional plugins for the tumbler thumbnail rendering service."
    "ugrep                             faster grep with an interactive query GUI"
    "unrar                             Extract files from RAR archives."
    "unrar-free                        Free software version of the non-free unrar utility"
    "unzip                             A utility for unpacking zip files"
    "variety                           Wallpaper changer, downloader and manager"
    "virt-manager                      Desktop tool for managing virtual machines via libvirt"
    "wget                              A utility for retrieving files using the HTTP or FTP protocols"
    "wsdd                              Python Web Services Discovery Daemon, Windows Net Browsing"
    "xclip                             Command line clipboard grabber"
    "xorg-x11-fonts-ISO8859-1-100dpi   A set of 100dpi ISO-8859-1 fonts for X"
    "zip                               A file compression and packaging utility compatible with PKZIP"
    "zstd                              compression library"
)

# Check distribution type (Debian, Fedora or Solus) and call respective function from above
if [ -f /etc/debian_version ]; then
    echo""
    echo -e "\e[34mDebian-based distribution detected.\e[0m"  # Blue color
    echo""
    install_debian_packages "${software_packages[@]}"
elif [ -f /etc/redhat-release ]; then
    echo""
    echo -e "\e[34mFedora-based distribution detected."
    echo ""
    install_fedora_packages "${software_packages[@]}"
elif [ -f /usr/bin/eopkg ]; then
    echo""
    echo -e "\e[34mSolus-based distribution detected.\e[0m"  # Blue color
    echo""
    install_solus_packages "${software_packages[@]}"
else
    echo "Unsupported distribution."
fi


# Install packages ;^)
# install_packages "${software_packages[@]}"
