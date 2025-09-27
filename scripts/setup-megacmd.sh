#!/bin/bash
# Gandalf = Inspired by Tolga
# 9/26/2025

#ToDo 
#  determine distro installing on
#  make systemd unit insteal of autostart entry

# Function to install MegaCMD if not already installed
function install_megacmd() {
    if ! command -v mega-cmd &> /dev/null; then
        echo "MegaCMD is not installed. Installing..."
        sudo eopkg it -y megacmd
    fi
}

# Function to log in to MegaCMD non-interactively (theory)
function login_megacmd() {
    # Ensure credentials are stored securely or sourced from a secure location
    #.........      EMAIL              PASSWORD    
    mega-login "dbf.linux@gmail.com" "**************"
}

# Function to sync directories
function mega_sync() {
    local local_dir=$1        # /home/brian/Templates etc etc 
    local remote_dir=$2       # cloud folder
    mega-sync "$local_dir" "$remote_dir"
}

cd /home/brian
sudo mkdir /Documents
sudo mkdir /Pictures
sudo mkdir /Templates
sudo mkdir /Music
sudo mkdir /Videos
sudo mkdir /Downloads/appimage_files
sudo mkdir /Downloads/ventoy
sudo mkdir /scripts
sudo mkdir /gitbub

# Function to create the BriansMegaSyncCMD.desktop file
function create_desktop_entry() {
    local desktop_file="$HOME/.config/autostart/MegaCMD.desktop"
    mkdir -p "$HOME/.config/autostart"

    if [ -f "$desktop_file" ]; then
        echo ".desktop entry already exists at $desktop_file. Skipping creation."
    else
        cat << EOF > "$desktop_file"
[Desktop Entry]
Name=MegaCMD
Comment=Run MegaCMD application at startup
Exec=$HOME/MEGA/brian-mega.sh
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Utility;
EOF
        echo ".desktop entry created at $desktop_file"
    fi
}

# Install MegaCMD if not already installed
install_megacmd

# Log in to MegaCMD
login_megacmd

# Perform sync operations
user_home=$(eval echo "~$(whoami)")
echo "Syncing directories..."

echo "Syncing directories..."

#........ /home/brian/            cloud folder
mega_sync "$user_home/Documents" "/Documents"
mega_sync "$user_home/Pictures" "/Pictures"
mega_sync "$user_home/Templates" "/Templates"
mega_sync "$user_home/Music" "/Music"
mega_sync "$user_home/Videos" "/Videos"
mega_sync "$user_home/Downloads/appimage_files" "/appimage_files"
mega_sync "$user_home/github" "/github"
mega_sync "$user_home/scripts" "/scripts"
mega_sync "$user_home/Downloads/ventoy" "/Ventoy"
echo "Sync completed."

# Create MegaCMD.desktop entry for automatic startup
create_desktop_entry

echo "Setup completed."

