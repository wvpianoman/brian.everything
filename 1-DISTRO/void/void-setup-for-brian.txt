#!/bin/bash
# for brother brian
# but has my GTX 1650 pkgs but includes your Cinnamon + extra XFCE/Plasma
# ─────────────────────────────────────────────────────────────────────────────

clear
install_xfce=false
install_plasma=false

echo ""
echo "  ── Desktop Environment Selection ──────────────────────────────────────"
echo ""
echo "  1) Cinnamon only"
echo "  2) Cinnamon + XFCE"
echo "  3) Cinnamon + Plasma"
echo "  4) Cinnamon + XFCE + Plasma (everything)"
echo ""
read -rp "  Choice [1-4]: " de_choice

case "$de_choice" in
    1) ;;
    2) install_xfce=true ;;
    3) install_plasma=true ;;
    4) install_xfce=true; install_plasma=true ;;
    *) echo "  Invalid choice, installing Cinnamon only." ;;
esac

echo ""

# ── repos ────────────────────────────────────────────────────────────────────

sudo xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
echo "repository=https://github.com/void-linux/xbps-repo/releases/latest/download" \
    | sudo tee /etc/xbps.d/noid-xbps-repo.conf
sudo xbps-install -Su

# ── my nvidia (GTX 1650) ─────────────────────────────────────────────────────

sudo xbps-install -S nvidia nvidia-libs nvidia-libs-32bit

# write Xorg nvidia config from solus, old fedora and kubuntu
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/20-nvidia.conf > /dev/null <<'EOF'
Section "Device"
    Identifier "NVIDIA"
    Driver     "nvidia"
    Option     "AllowEmptyInitialConfiguration" "true"
EndSection
EOF

# add user to video/render groups
sudo usermod -aG video,render "$USER"

# ── base system extras ────────────────────────────────────────────────────────

sudo xbps-install -S \
    base-system linux cryptsetup lvm2 mdadm \
    elogind polkit dbus udisks2 upower \
    NetworkManager network-manager-applet \
    xorg-minimal xorg-input-drivers xorg-video-drivers xauth setxkbmap \
    pipewire alsa-pipewire wireplumber \
    cups cups-filters cups-browsed cups-pdf cups-pk-helper gutenprint foomatic-db foomatic-db-engine \
    print-manager system-config-printer \
    gvfs-mtp gvfs-afc gvfs-smb \
    lightdm lightdm-gtk-greeter \
    gnome-keyring polkit-gnome \
    flatpak

# ── cinnamon ──────────────────────────────────────────────────────────────────

sudo xbps-install -S cinnamon-all

# ── fonts ─────────────────────────────────────────────────────────────────────

sudo xbps-install -S \
    dejavu-fonts-ttf nerd-fonts nerd-fonts-ttf nerd-fonts-otf nerd-fonts-symbols-ttf \
    terminus-font font-misc-misc

# ── shells / terminal tools ───────────────────────────────────────────────────

sudo xbps-install -S \
    fish-shell zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-history-substring-search \
    bash-completion checkbashisms \
    alacritty kitty ghostty terminator yakuake xfce4-terminal \
    tmux micro nano \
    btop duf lsd bat fd ripgrep-all tldr thefuck \
    fastfetch figlet cowsay fortune-mod fortune-mod-anarchism fortune-mod-void \
    powerline-go

# ── dev / build tools ────────────────────────────────────────────────────────

sudo xbps-install -S \
    git git-lfs make autoconf automake binutils bc direnv jq \
    xtools pandoc helix vscodium sublime-text4

# ── multimedia ────────────────────────────────────────────────────────────────

sudo xbps-install -S \
    vlc ffmpeg mpg123 \
    ffmpegthumbnailer ffmpegthumbs \
    easyeffects \
    obs

# ── graphics / office ─────────────────────────────────────────────────────────

sudo xbps-install -S \
    gimp inkscape blender krita scribus \
    libreoffice \
    flameshot

# ── internet / download ───────────────────────────────────────────────────────

sudo xbps-install -S \
    firefox aria2 uget uget-integrator persepolis rclone RcloneBrowser \
    telegram-desktop neochat

# ── misc apps ─────────────────────────────────────────────────────────────────

sudo xbps-install -S \
    digikam variety \
    gparted \
    dconf-editor \
    meld \
    hunspell-en \
    ibus-gtk4 \
    p7zip \
    pdfsandwich tesseract-ocr tesseract-ocr-eng \
    brltty orca \
    yad

# ── system services ───────────────────────────────────────────────────────────

sudo xbps-install -S \
    earlyoom haveged chrony \
    nftables net-tools \
    cifs-utils \
    zramen \
    octoxbps void-updates void-docs-browse void-release-keys

# ── optional: XFCE ────────────────────────────────────────────────────────────

if $install_xfce; then
    echo "  ── Installing XFCE ─────────────────────────────────────────────────────"
    sudo xbps-install -S \
        xfce4 xfce4-plugins xfce4-terminal xfce4-appfinder \
        xfce4-notifyd xfce4-panel xfce4-panel-profiles \
        xfce4-power-manager xfce4-screensaver xfce4-screenshooter \
        xfce4-session xfce4-settings xfce4-taskmanager \
        xfce4-whiskermenu-plugin xfce4-clipman-plugin \
        xfce4-pulseaudio-plugin xfce4-alsa-plugin \
        xfce4-battery-plugin xfce4-cpugraph-plugin xfce4-cpufreq-plugin \
        xfce4-datetime-plugin xfce4-diskperf-plugin xfce4-fsguard-plugin \
        xfce4-genmon-plugin xfce4-mailwatch-plugin xfce4-mpc-plugin \
        xfce4-netload-plugin xfce4-sensors-plugin xfce4-systemload-plugin \
        xfce4-timer-plugin xfce4-weather-plugin xfce4-xkb-plugin \
        xfce4-eyes-plugin xfce4-dict
fi

# ── optional: Plasma ─────────────────────────────────────────────────────────

if $install_plasma; then
    echo "  ── Installing Plasma ───────────────────────────────────────────────────"
    sudo xbps-install -S \
        kde-plasma plasma-desktop plasma-workspace plasma-workspace-wallpapers \
        plasma-nm plasma-pa plasma-firewall plasma-disks plasma-systemmonitor \
        plasma-browser-integration plasma-activities plasma-activities-stats \
        plasma-integration plasma-wayland-protocols \
        plasma-thunderbolt plasma-sdk \
        kdeplasma-addons \
        dolphin dolphin-plugins kate konsole yakuake \
        discover
fi

# ── enable runit services ─────────────────────────────────────────────────────

for svc in dbus elogind NetworkManager polkitd cupsd earlyoom haveged chronyd lightdm; do
    sudo ln -sf /etc/sv/"$svc" /var/service/
done

# user-level pipewire (run as user, not root)
# add to your shell profile or autostart:
# pipewire & pipewire-pulse & wireplumber &

echo ""
echo "Done. Reboot, then start pipewire from your session autostart Brian."
