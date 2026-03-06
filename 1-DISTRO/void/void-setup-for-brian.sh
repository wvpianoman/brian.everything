#!/bin/bash
# for brother brian
#
# ─────────────────────────────────────────────────────────────────────────────

clear

# ── repos ────────────────────────────────────────────────────────────────────

sudo xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
echo "repository=https://github.com/void-linux/xbps-repo/releases/latest/download" \
    | sudo tee /etc/xbps.d/noid-xbps-repo.conf
sudo xbps-install -Syu

# ── base system extras ────────────────────────────────────────────────────────

sudo xbps-install -Sy base-system linux cryptsetup lvm2 mdadm elogind polkit dbus udisks2 upower NetworkManager network-manager-applet xorg-minimal xorg-input-drivers xorg-video-drivers xauth setxkbmap pipewire alsa-pipewire wireplumber cups cups-filters cups-browsed cups-pdf cups-pk-helper gutenprint foomatic-db foomatic-db-engine pkg-config gvfs-mtp gvfs-afc gvfs-smb lightdm lightdm-gtk-greeter xmirror xtools openssl openssl-devel flatpak fsearch gcc zenity

sudo xbps-install -f gcc openssl-devel pkg-config openssl


# ── fonts ─────────────────────────────────────────────────────────────────────

sudo xbps-install -Sy dejavu-fonts-ttf nerd-fonts nerd-fonts-ttf nerd-fonts-otf nerd-fonts-symbols-ttf terminus-font font-misc-misc

# ── shells / terminal tools ───────────────────────────────────────────────────

sudo xbps-install -Sy fish-shell zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-history-substring-search bash-completion checkbashisms alacritty kitty ghostty terminator yakuake xfce4-terminal tmux micro nano btop duf lsd bat fd ripgrep-all tldr thefuck fastfetch figlet cowsay fortune-mod fortune-mod-anarchism fortune-mod-void powerline-go

# ── dev / build tools ────────────────────────────────────────────────────────

sudo xbps-install -Sy git git-lfs make autoconf automake binutils bc direnv jq xtools pandoc helix vscodium sublime-text4 meld vscodium

# ── multimedia ────────────────────────────────────────────────────────────────

sudo xbps-install -Sy vlc ffmpeg mpg123 ffmpegthumbnailer ffmpegthumbs easyeffects audacity obs handbrake

# ── graphics / office ─────────────────────────────────────────────────────────

sudo xbps-install -Sy gimp inkscape blender krita scribus libreoffice onlyoffice flameshot xournalpp cherrytree diffuse ghostwriter gpu-screen-recorder

# ── internet / download ───────────────────────────────────────────────────────

sudo xbps-install -Sy firefox aria2 uget uget-integrator persepolis rclone RcloneBrowser telegram-desktop neochat telegram-desktop

# ── misc apps ─────────────────────────────────────────────────────────────────

sudo xbps-install -Sy digikam variety gparted dconf-editor meld hunspell-en ibus-gtk4 p7zip pdfsandwich tesseract-ocr tesseract-ocr-eng brltty orca yad bleachbit conky gearlever LACT mission-center

# ── system services ───────────────────────────────────────────────────────────

sudo xbps-install -Sy earlyoom haveged chrony nftables net-tools cifs-utils zramen octoxbps void-updates void-docs-browse void-release-keys


# ──  Plasma ─────────────────────────────────────────────────────────
sudo xbps-install -Sy kde-plasma plasma-desktop plasma-workspace plasma-workspace-wallpapers plasma-nm plasma-pa plasma-firewall plasma-disks plasma-systemmonitor plasma-browser-integration plasma-activities plasma-activities-stats plasma-integration plasma-wayland-protocols plasma-thunderbolt plasma-sdk kdeplasma-addons dolphin dolphin-plugins kate konsole yakuake discover kdeconnect spectacle print-manager partionmanager okular kwrite isoimagewriter

# ──  Plasma ─────────────────────────────────────────────────────────

sudo xbps-install -Sy ark dolphin-plugins discover kwalletmanager ksystemlog khelpcenter spectacle filelight kcalc kfind sweeper partitionmanager isoimagewriter kwrite krename krusader kdeconnect


sudo xbps-install -Sy kdepim-addons korganizer akonadi-import-wizard kf6-akonadi calendarsupport eventviews incidenceeditor kholidays akonadi-notes akonadi-calendar

    # database backend
sudo xbps-install -Sy mariadb

# ── enable runit services ─────────────────────────────────────────────────────

for svc in dbus elogind NetworkManager polkitd cupsd earlyoom haveged chronyd lightdm; do
    sudo ln -sf /etc/sv/"$svc" /var/service/
done

# user-level pipewire (run as user, not root)
# add to your shell profile or autostart:
# pipewire & pipewire-pulse & wireplumber &

echo ""
echo "Done. Reboot, then start pipewire from your session autostart Brian."
