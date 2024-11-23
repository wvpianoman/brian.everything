#!/usr/bin/env bash

# Brian Francisco
# My personal flatpaks
# APril 1, 2024

# Run from remote location:::.
# sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/FlatPakApps.sh)"

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

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Try using sudo."
    exit 2
fi

# Prompt user for confirmation
read -p ")==> This script will install Flatpak applications and make system modifications. Do you want to continue? (y/n): " choice
if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo "Installation aborted."
    exit 0
fi

# Check if Flatpak is installed
if ! command -v flatpak &>/dev/null; then
    echo "Flatpak is not installed.  We're going to install flatpak first."
    sudo dnf install -y flatpak
    sleep 3
fi

# Add Flathub repository if not already added
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Enable wayland support
flatpak override --user --socket=wayland --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox

# KDE specific configurations
tee -a ${FIREFOX_PROFILE_PATH}/user.js <<'EOF'

// KDE integration
// https://wiki.archlinux.org/title/firefox#KDE_integration
user_pref("widget.use-xdg-desktop-portal.mime-handler", 1);
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
EOF

# Define an array of Flatpak application IDs
flatpak_apps=(
#    "com.anydesk.Anydesk"
#    "eu.betterbird.Betterbird"
#    "org.blender.Blender"
#    "com.sindresorhus.Caprine"
    "net.giuspen.cherrytree"
#    "com.google.Chrome"
    "com.google.ChromeDev"
#    "com.discordapp.Discord"
    "com.jgraph.drawio.desktop"
    "com.microsoft.EdgeDev"
    "im.riot.Riot"
#    "one.ablaze.floorp"
    "io.gitlab.adhami3310.Footage"
    "it.mijorus.gearlever"
#    "io.github.wereturtle.ghostwriter"
#    "org.gimp.GIMP"
#    "com.axosoft.GitKraken"
    "com.mattjakeman.ExtensionManager"
    "io.gitlab.adhami3310.Impression"
#    "org.inkscape.Inkscape"
#    "org.kde.krita"
#    "org.libreoffice.LibreOffice"
    "io.missioncenter.MissionCenter"
    "io.github.amit9838.mousam"
#    "com.obsproject.Studio"
#    "org.onlyoffice.desktopeditors"
#    "net.scribus.Scribus"
#    "org.gnome.Shotwell"
    "io.gitlab.adhami3310.Converter"
#    "me.kozec.syncthingtk"
#    "io.github.shiftey.Desktop"
#    "com.github.zocker_160.SyncThingy"
#    "com.transmissionbt.Transmission"
#    "org.telegram.desktop"
#    "org.telegram.desktop.webview"
#    "org.videolan.VLC"
    "com.vivaldi.Vivaldi"
#    "com.vscodium.codium"
    "net.codelogistics.webapps"
#    "com.wps.Office"
    "io.github.aandrew_me.ytdn"
    "io.github.zen_browser.zen"
)

# Install applications
for app in "${flatpak_apps[@]}"; do
    flatpak install -y flathub "$app"
done

# flatpak install flathub-beta thunderbird

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
sleep 10
