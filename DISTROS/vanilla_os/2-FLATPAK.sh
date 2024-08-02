#!/usr/bin/env bash

# Brian Francisco
# My personal flatpaks
# April 1, 2024

#  ¯\_(ツ)_/¯
#
#  ███████╗██╗      █████╗ ████████╗██████╗  █████╗ ██╗  ██╗     █████╗ ██████╗ ██████╗ ███████╗
#  ██╔════╝██║     ██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║ ██╔╝    ██╔══██╗██╔══██╗██╔══██╗██╔════╝
#  █████╗  ██║     ███████║   ██║   ██████╔╝███████║█████╔╝     ███████║██████╔╝██████╔╝███████╗
#  ██╔══╝  ██║     ██╔══██║   ██║   ██╔═══╝ ██╔══██║██╔═██╗     ██╔══██║██╔═══╝ ██╔═══╝ ╚════██║
#  ██║     ███████╗██║  ██║   ██║   ██║     ██║  ██║██║  ██╗    ██║  ██║██║     ██║     ███████║
#  ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Flatpak%20Apps

#if [[ $EUID -ne 0 ]]; then
#    echo "$0 is not running as root. Try using sudo."
#    exit 2
#fi

# Prompt user for confirmation
read -p ")==> This script will install Flatpak applications and make system modifications. Do you want to continue? (y/n): " choice
if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo "Installation aborted."
    exit 0
fi

# Check if Flatpak is installed
# Check if Flatpak is installed
#if ! command -v flatpak &>/dev/null; then
#    echo "Flatpak is not installed.  We're going to install flatpak first."
#    sudo eopkg install -y flatpak
#    sleep 3
#fi

# Add Flathub repository if not already added
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo



# Define an array of Flatpak application IDs
flatpak_apps=(
#    "com.anydesk.Anydesk"
    "app/eu.betterbird.Betterbird/x86_64/stable"
    "app/org.blender.Blender/x86_64/stable"
    "app/com.sindresorhus.Caprine/x86_64/stable"
    "app/net.giuspen.cherrytree/x86_64/stable"
#    "com.google.Chrome"
    "app/com.google.ChromeDev/x86_64/stable"
    "app/org.kde.digikam/x86_64/stable"
    "app/com.discordapp.Discord/x86_64/stable"
    "app/com.jgraph.drawio.desktop/x86_64/stable"
    "app/com.microsoft.EdgeDev/x86_64/stable"
    "app/one.ablaze.floorp/x86_64/stable"
    "app/it.mijorus.gearlever/x86_64/stable"
    "app/io.github.wereturtle.ghostwriter/x86_64/stable"
    "app/org.gimp.GIMP/x86_64/stable"
    "app/com.github.Murmele.Gittyup/x86_64/stable"
    "app/org.inkscape.Inkscape/x86_64/stable"
    "app/org.kde.krita/x86_64/stable"
    "app/org.libreoffice.LibreOffice"
    "app/io.missioncenter.MissionCenter/x86_64/stable"
    "app/io.github.amit9838.mousam/x86_64/stable"
    "app/com.obsproject.Studio/x86_64/stable"
    "app/org.onlyoffice.desktopeditors/x86_64/stable"
    "app/net.scribus.Scribus/x86_64/stable"
    "app/org.gnome.Shotwell/x86_64/stable"
    "app/me.kozec.syncthingtk/x86_64/stable"
#    "io.github.shiftey.Desktop"
#    "com.github.zocker_160.SyncThingy"
#    "com.transmissionbt.Transmission"
    "app/org.telegram.desktop/x86_64/stable"
    "app/org.telegram.desktop.webview/x86_64/stable"
    "app/org.videolan.VLC/x86_64/stable"
    "app/com.vivaldi.Vivaldi/x86_64/stable"
    "app/com.vscodium.codium/x86_64/stable"
    "app/com.wps.Office/x86_64/stable"
### To Make Gnome more user friendly ###
    "com.mattjakeman.ExtensionManager/x86_64/stable"
)

# Install applications
for app in "${flatpak_apps[@]}"; do
    flatpak install -y "$app"
done

echo -e "\e[1;32m[✔]\e[0m Checking updates for installed flatpak programs...\n"
flatpak update -y
sleep 1

echo -e "\e[1;32m[✔]\e[0m Removing Old Flatpak Cruft...\n"
flatpak uninstall --unused
flatpak uninstall --delete-data

echo "#####################################"
echo
echo "Enabling Flatpak Theming Overrides"
echo

# Check and set XDG_RUNTIME_DIR
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro

sudo flatpak override --env=gfx.webrender.all=true \
    --env=media.ffmpeg.vaapi.enabled=true \
    --env=widget.dmabuf.force-enabled=true \
    org.mozilla.firefox

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# Check if the directory exists before attempting to remove it
if [ -d "/var/tmp/flatpak-cache-*" ]; then
    echo -e "\e[1;32m[✔]\e[0m Removing Old Flatpak Cruft...\n"
    sudo rm -rfv /var/tmp/flatpak-cache-*
else
    echo -e "\e[1;32m[✔]\e[0m No old Flatpak cruft found.\n"
fi

sleep 1

# Display all platpaks installed on system
flatpak --columns=app,name,size,installation list
echo -e "\e[1;32m[✔]\e[0m List of flatpaks on system...\n"

echo "Installation completed. You can now run the installed applications."
sleep 3
