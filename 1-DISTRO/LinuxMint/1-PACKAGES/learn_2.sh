#!/usr/bin/env bash
# brian francisco
# oct 27 2025
# 《˘ ͜ʖ ˘》
# inspired by tolga erok

# simple color setup
green="\e[32m"
blue="\e[34m"
reset="\e[0m"

say() { echo -e "${blue}$1${reset}"; sleep 1; }

# update base
init_setup() {
  say "initial setup..."
  sudo apt install -y apt wget curl gnupg lsb-release software-properties-common
}

# add external repos
install_repos() {
  say "adding external repos..."

  # sublime text
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
  echo -e "types: deb\nuris: https://download.sublimetext.com/\nsuites: apt/stable/\nsigned-by: /etc/apt/keyrings/sublimehq-pub.asc" | sudo tee /etc/apt/sources.list.d/sublime-text.sources

  # freeoffice
  wget -qO- https://shop.softmaker.com/repo/linux-repo-public.key | gpg --dearmor | sudo tee /etc/apt/keyrings/softmaker.gpg > /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/softmaker.gpg] https://shop.softmaker.com/repo/apt stable non-free" | sudo tee /etc/apt/sources.list.d/softmaker.list

  # gum
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

  # onlyoffice
  mkdir -p -m 700 ~/.gnupg
  gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
  chmod 644 /tmp/onlyoffice.gpg
  sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg
  echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee /etc/apt/sources.list.d/onlyoffice.list

  # grub customizer
  sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer

  # gcalendar
  sudo add-apt-repository -y ppa:slgobinath/gcalendar

  # element messenger
  sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list

  # fish shell
  sudo add-apt-repository -y ppa:fish-shell/release-4

  sudo apt update
}

# install deb files
install_extras() {
  say "installing deb packages..."
  wget https://mega.nz/linux/repo/Debian_testing/amd64/megasync-Debian_testing_amd64.deb
  sudo apt install -y ./megasync-Debian_testing_amd64.deb
}

# install core tools
install_tools() {
  say "installing core tools..."

  sudo apt install -y onlyoffice-desktopeditors onlyoffice-desktopeditors-help gum \
    softmaker-freeoffice-2024 sublime-text fonts-crosextra-caladea grub-customizer \
    gcalendar element-desktop fish

  sudo apt install -y yad espeak espeak-ng fancontrol figlet fortune-mod fortunes fortunes-min uget hardinfo thefuck \
    ocrmypdf ocrmypdf-doc pdfsandwich meld acl aria2 attr autoconf automake bash-completion bc binutils btop busybox \
    ca-certificates cifs-utils libcjson1 codec2 cookietool cowsay cron curl gir1.2-dbusglib-1.0 dconf-editor dialog \
    direnv dnsutils duf easyeffects mbpfan fd-find ffmpeg ffmpegthumbnailer ffmpegthumbs flatpak gdebi git gnupg2 grep \
    yaru-cinnamon-theme-{gtk,icon} sox zenity synaptic plank lolcat vnstati haveged ibus-gtk4 jq lsd make \
    ublock-origin-doc webext-ublock-origin-firefox mpg123 nano neofetch neovim neovim-qt snmpd net-tools nftables \
    openssh-{client,server} ostree p7zip p7zip-full p7zip-rar packagekit pandoc pip pipewire-{audio,doc} pkg-config \
    plocate powertop python3 python3-pip python3-setproctitle qrencode ripgrep rsync rygel sassc screen socat sshpass \
    sxiv tar terminator tumbler tumbler-plugins-extra ufw ugrep unzip unrar unrar-free variety vim \
    webext-ublock-origin-chromium wget wget2 wsdd xclip zip systemd-zram-generator zram-tools zstd gparted kdeconnect meld

  sudo apt install -y hunspell-en-us hyphen-en-us libreoffice blender blender-data gimp gimp-help-en inkscape boomaga \
    digikam neochat scribus scribus-template rclone rclone-browser flameshot vlc simplescreenrecorder megacmd obs-studio \
    duf figlet kitty pandoc thunar thunar-gtkhash thunar-archive-plugin thunar-media-tags-plugin thunar-font-manager \
    thunar-volman thunar-megasync thunarx-python
}

# setup fish shell
setup_shell() {
  say "configuring fish shell..."
  echo /usr/bin/fish | sudo tee -a /etc/shells
  chsh -s /usr/bin/fish
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  fisher install IlanCosman/tide@v6
}

# main runner
main() {
  init_setup
  install_repos
  install_extras
  install_tools
  setup_shell
  say "${green}all packages installed successfully.${reset}"
}

main
