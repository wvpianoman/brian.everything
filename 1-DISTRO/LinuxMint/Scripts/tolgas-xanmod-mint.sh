#!/usr/bin/env bash
# tolga erok
# 15/10/25
# BETA
# my xanmod kernel manager installer with safety checks and yad gui

# Linuxtweaks icon setup
icon_URL="https://raw.githubusercontent.com/tolgaerok/linuxtweaks/main/MY_PYTHON_APP/images/LinuxTweak.png"
icon_dir="$HOME/.config"
icon_path="$icon_dir/LinuxTweak.png"

mkdir -p "$icon_dir"
wget -q -O "$icon_path" "$icon_URL"
chmod 644 "$icon_path"
ICON="$icon_path"

info() {
    yad --title="LinuxTweaks" \
        --window-icon="$ICON" \
        --image="$ICON" \
        --text="$1" \
        --button=OK:0 \
        --center \
        --width=450 \
        --height=150
}

if ! command -v yad &> /dev/null; then
    echo "yad not found. installing..."
    sudo apt update
    sudo apt install -y yad
fi

info "yad is installed. proceeding brother!..."
sleep 1

info "checking for existing xanmod repositories..."
XANMOD_REPO="/etc/apt/sources.list.d/xanmod.list"
XANMOD_MANAGER_REPO="/etc/apt/sources.list.d/xanmod-manager.list"

for repo in "$XANMOD_REPO" "$XANMOD_MANAGER_REPO"; do
    if [ -f "$repo" ]; then
        info "repository already exists: $repo. skipping creation."
    fi
done

info "removing duplicate xanmod repo files if found..."
sudo find /etc/apt/sources.list.d/ -type f -name "xanmod*.list" ! -name "$(basename "$XANMOD_REPO")" ! -name "$(basename "$XANMOD_MANAGER_REPO")" -exec sudo rm -v {} \;

info "checking system architecture..."
wget -q https://dl.xanmod.org/check_x86-64_psabi.sh -O check_x86-64_psabi.sh
chmod +x check_x86-64_psabi.sh
ARCH_OUTPUT=$(./check_x86-64_psabi.sh 2>&1)
info "$ARCH_OUTPUT"
info "system check complete."

if [ ! -f "$XANMOD_REPO" ]; then
    info "adding xanmod main repo..."
    echo "deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main" | sudo tee "$XANMOD_REPO" > /dev/null
fi

if [ ! -f "$XANMOD_MANAGER_REPO" ]; then
    info "adding xanmod manager repo..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO - https://raw.githubusercontent.com/bobbycomet/xanmod-kernel-update-tool/refs/heads/main/xanmodkernalmanager-repo/dists/stable/your-public-key.asc | sudo gpg --dearmor -o /etc/apt/keyrings/xanmod-manager-repo.gpg
    echo "deb [signed-by=/etc/apt/keyrings/xanmod-manager-repo.gpg] https://bobbycomet.github.io/xanmod-kernel-update-tool stable main" | sudo tee "$XANMOD_MANAGER_REPO" > /dev/null
fi

info "updating package lists..."
sudo apt update -y
info "installing xanmod-kernel-manager..."
sudo apt install -y xanmod-kernel-manager

SESSION_TYPE=$(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | cut -d= -f2)
info "your current desktop session type is: $SESSION_TYPE"

info "launching xanmod kernel manager..."
xanmod-kernel-manager &
