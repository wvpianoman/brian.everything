#!/bin/bash
# Tolga Erok
# 16 Sep 2024

# Define colors and symbols
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m' # Bright white for Flatpak names
NC='\033[0m'       # No Color
TICK='\u2714'      # Unicode for check mark
RED='\033[0;31m'   # Red for error messages

# Cache sudo credentials to avoid repeated password prompts
sudo -v

#clear

# Remote flatpak list (my personal collection)

# for Aurora/Bluiefin
# FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-aurora | tr '\n' ' ')

# for BigLinux
#FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-biglinux | tr '\n' ' ')

# for Fedora
#FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-fedora | tr '\n' ' ')

# for Garuda
#FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-garuda | tr '\n' ' ')

# for Makulu
#FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-makulu | tr '\n' ' ')

# PikaOS
#FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-pikaos | tr '\n' ' ')

# for siduction
#FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-siduction | tr '\n' ' ')

# for Solus
FLATPAK_LIST=$(curl -s https://raw.githubusercontent.com/wvpianoman/brian.everything/refs/heads/main/flatpak/flatpaks-solus | tr '\n' ' ')

# Add Flathub remote repository if it doesn't already exist
echo -e "${YELLOW}Adding Flathub repository if not present...${NC}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
#flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Install or update the Flatpaks from my list
echo -e "${YELLOW}****************************************************${NC}"
echo -e "${RED}Installing or updating Flatpaks from Brian's list...${NC}"
echo -e "${YELLOW}****************************************************${NC}\n"
for app in $FLATPAK_LIST; do
    if [ -n "$app" ]; then
        echo -e "${YELLOW}Processing: ${WHITE}$app${NC}"
        flatpak --system -y install --or-update flathub "$app" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[$TICK] Successfully installed or updated: ${WHITE}$app${NC}\n"
        else
            echo -e "${RED}✘ Failed to process: ${WHITE}$app${NC}\n"
        fi
    fi
done


# check if Firefox is installed as a Flatpak
is_firefox_flatpak_installed() {
    flatpak list | grep -q 'org.mozilla.firefox'
}

# apply Wayland and other overrides to Firefox Flatpak
apply_firefox_flatpak_overrides() {
    echo "Applying Flatpak overrides for Firefox..."
    flatpak override --user --socket=wayland --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox
    flatpak override --user --env=gfx.webrender.all=true \
        --env=media.ffmpeg.vaapi.enabled=true \
        --env=widget.dmabuf.force-enabled=true \
        org.mozilla.firefox
    echo "Flatpak overrides applied."
}

# apply VAAPI configuration for NVIDIA
apply_nvidia_vaapi() {
    echo "Applying VAAPI configuration for Firefox with NVIDIA..."
    flatpak override --user --filesystem=host-os \
        --env=LIBVA_DRIVER_NAME=nvidia \
        --env=LIBVA_DRIVERS_PATH=/run/host/usr/lib64/dri \
        --env=LIBVA_MESSAGING_LEVEL=1 \
        --env=MOZ_DISABLE_RDD_SANDBOX=1 \
        --env=NVD_BACKEND=direct \
        --env=MOZ_ENABLE_WAYLAND=1 \
        org.mozilla.firefox
    echo "VAAPI configuration for NVIDIA applied."
}

# apply VAAPI configuration for local Firefox with Intel
apply_intel_vaapi() {
    echo "Applying VAAPI configuration for local Firefox with Intel..."
    export LIBVA_DRIVER_NAME=i965
    export LIBVA_DRIVERS_PATH=/usr/lib64/dri
    export LIBVA_MESSAGING_LEVEL=1
    export MOZ_DISABLE_RDD_SANDBOX=1
    export MOZ_ENABLE_WAYLAND=1

    echo "Launching local Firefox with VAAPI enabled..."
    firefox &
}

# Main script execution
if lsmod | grep -wq "nvidia"; then
    echo -e "${GREEN}[✔]${NC} Nvidia module is loaded."

    if is_firefox_flatpak_installed; then
        echo -e "${GREEN}[✔]${NC} Firefox Flatpak is installed. Enabling VAAPI in Firefox Flatpak..."
        apply_nvidia_vaapi
    else
        echo -e "${YELLOW}[!]${NC} Firefox Flatpak is not installed. Enabling VAAPI in local Firefox installation..."
        apply_intel_vaapi
    fi
elif lsmod | grep -wq "i915"; then
    echo -e "${GREEN}[✔]${NC} Intel module is loaded."

    if is_firefox_flatpak_installed; then
        echo -e "${GREEN}[✔]${NC} Firefox Flatpak is installed. Applying Wayland and other overrides..."
        apply_firefox_flatpak_overrides
    else
        echo -e "${YELLOW}[!]${NC} Firefox Flatpak is not installed. Enabling VAAPI in local Firefox installation..."
        apply_intel_vaapi
    fi
else
    echo -e "${RED}[✘]${NC} No supported GPU module is loaded. Please check your hardware and drivers."
fi

# Enable the Flathub remote (which is disabled by default)
flatpak remote-modify --enable flathub

echo -e "${GREEN}All operations completed.${NC}\n"
