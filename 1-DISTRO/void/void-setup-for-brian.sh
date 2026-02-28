#!/bin/bash
# for brother brian
#
# ─────────────────────────────────────────────────────────────────────────────

clear

# ── repos ────────────────────────────────────────────────────────────────────

sudo xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
echo "repository=https://github.com/void-linux/xbps-repo/releases/latest/download" \
    | sudo tee /etc/xbps.d/noid-xbps-repo.conf
sudo xbps-install -Su

# ── base system extras ────────────────────────────────────────────────────────

sudo xbps-install -S base-system linux cryptsetup lvm2 mdadm elogind polkit dbus udisks2 upower NetworkManager network-manager-applet xorg-minimal xorg-input-drivers xorg-video-drivers xauth setxkbmap pipewire alsa-pipewire wireplumber cups cups-filters cups-browsed cups-pdf cups-pk-helper gutenprint foomatic-db foomatic-db-engine print-manager pkg-config gvfs-mtp gvfs-afc gvfs-smb lightdm lightdm-gtk-greeter xmirror xtools openssl openssl-devel flatpak fsearch ffmpeg

sudo xbps-install -f gcc


# ── fonts ─────────────────────────────────────────────────────────────────────

sudo xbps-install -S dejavu-fonts-ttf nerd-fonts nerd-fonts-ttf nerd-fonts-otf nerd-fonts-symbols-ttf terminus-font font-misc-misc

# ── shells / terminal tools ───────────────────────────────────────────────────

sudo xbps-install -S fish-shell zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-history-substring-search bash-completion checkbashisms alacritty kitty ghostty terminator yakuake xfce4-terminal tmux micro nano btop duf lsd bat fd ripgrep-all tldr thefuck fastfetch figlet cowsay fortune-mod fortune-mod-anarchism fortune-mod-void powerline-go

# ── dev / build tools ────────────────────────────────────────────────────────

sudo xbps-install -S git git-lfs make autoconf automake binutils bc direnv jq xtools pandoc helix vscodium sublime-text4 meld vscodium

# ── multimedia ────────────────────────────────────────────────────────────────

sudo xbps-install -S vlc ffmpeg mpg123 ffmpegthumbnailer ffmpegthumbs easyeffects audacity obs handbrake

# ── graphics / office ─────────────────────────────────────────────────────────

sudo xbps-install -S gimp inkscape blender krita scribus libreoffice onlyoffice flameshot xournalpp cherrytree diffuse ghostwriter gpu-screen-recorder

# ── internet / download ───────────────────────────────────────────────────────

sudo xbps-install -S firefox aria2 uget uget-integrator persepolis rclone RcloneBrowser telegram-desktop neochat telegram-desktop

# ── misc apps ─────────────────────────────────────────────────────────────────

sudo xbps-install -S digikam variety gparted dconf-editor meld hunspell-en ibus-gtk4 p7zip pdfsandwich tesseract-ocr tesseract-ocr-eng brltty orca yad bleachbit conky gearlever LACT mission-center

# ── system services ───────────────────────────────────────────────────────────

sudo xbps-install -S earlyoom haveged chrony nftables net-tools cifs-utils zramen octoxbps void-updates void-docs-browse void-release-keys


# ──  Plasma ─────────────────────────────────────────────────────────
sudo xbps-install -S kde-plasma plasma-desktop plasma-workspace plasma-workspace-wallpapers plasma-nm plasma-pa plasma-firewall plasma-disks plasma-systemmonitor plasma-browser-integration plasma-activities plasma-activities-stats plasma-integration plasma-wayland-protocols plasma-thunderbolt plasma-sdk kdeplasma-addons dolphin dolphin-plugins kate konsole yakuake discover kdeconnect
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
