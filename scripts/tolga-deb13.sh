#!/bin/bash
# debian13-setup.sh

# Tolga Erok
# 18/8/25

set -e

# [+] ================ MUST BE RUN AS ROOT ====================================== [+]
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root (use sudo)"
  exit 1
fi

# [+] ================ TRIXIE REPO'S ====================================== [+]
echo "Backing up and updating /etc/apt/sources.list..."
if [ -f /etc/apt/sources.list ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo truncate -s 0 /etc/apt/sources.list
fi

cat <<'EOF' | sudo tee /etc/apt/sources.list
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb http://security.debian.org/ trixie-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ trixie-backports main contrib non-free non-free-firmware
EOF

# [+] ================ NALA ====================================== [+]
echo "📦 Updating package lists and installing extra packages..."
# Install nala if not already installed
if ! command -v nala >/dev/null 2>&1; then
    sudo apt install -y nala
fi

# [+] ================ IO SCHEDULER AT BOOT ====================================== [+]
sudo tee /etc/udev/rules.d/99-disk-tweaks.rules > /dev/null <<'EOF'
# NVMe drives: disable write cache, scheduler 'none'
ACTION=="add|change", KERNEL=="nvme*", ATTR{queue/write_cache}="0", ATTR{queue/scheduler}="none"

# SATA SSDs: enable write cache, scheduler 'mq-deadline'
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/write_cache}="1", ATTR{queue/scheduler}="mq-deadline"

# HDDs: leave write cache enabled, scheduler 'cfq'
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/write_cache}="1", ATTR{queue/scheduler}="cfq"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=block
cat /sys/block/sda/queue/scheduler
sleep 2

# [+] ================ EXTRA'S ====================================== [+]
echo "📦 Updating system..."
sudo nala update
sudo nala upgrade -y
sudo nala dist-upgrade -y

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo nala update

GH="https://github.com"

declare -A fetch_online=(
    [chrome]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    [discord]="https://discord.com/api/download/stable?platform=linux&format=deb"
    [emoji-picker]="$GH/GaZaTu/x11-emoji-picker/releases/download/v0.15.0/x11-emoji-picker-x86_64-debian-12.deb"
    [obsidian]="$GH/obsidianmd/obsidian-releases/releases/download/v1.8.10/obsidian_1.8.10_amd64.deb"
    [quickemu]="$GH/quickemu-project/quickemu/releases/download/4.9.7/quickemu_4.9.7-1_all.deb"
    [rocket]="$GH/RocketChat/Rocket.Chat.Electron/releases/download/4.7.1/rocketchat-4.7.1-linux-amd64.deb"
)

wget_install() {
    local name=$1
    local url=$2
    local file="/tmp/${name}.deb"

    # Skip if package already installed
    if dpkg -s "$name" &>/dev/null; then
        echo "✔ $name is already installed, skipping…"
        return
    fi

    echo "📦 Installing $name from $url …"
    wget -O "$file" "$url"
    sudo nala install -y "$file"
    rm -f "$file"
}

# grab my fetch_online
for key in "${!fetch_online[@]}"; do
    wget_install "$key" "${fetch_online[$key]}"
done

# my extra packages (utilities, networking, multimedia)
EXTRA_PACKAGES=(
    cifs-utils
    curl
    dnsutils
    ffmpeg
    fonts-liberation
    fortune-mod
    genisoimage
    git
    jq
    lolcat
    mesa-utils
    net-tools
    pipx
    python3-pip
    qemu-system
    samba
    samba-common-bin
    socat
    spice-client-gtk
    swtpm
    systemd-timesyncd
    transmission
    uuid-runtime
    variety
    wget
    zsync
)

# my development tools
DEV_PACKAGES=(
    autojump
    bridge-utils
    ca-certificates
    cargo
    containerd.io
    curl
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
    ffmpeg
    gcc
    libvirt-clients
    libvirt-daemon-system
    make
    python3.13-venv
    qemu-kvm
    ripgrep
    rsync
    sqlite3
    tmux
    tree
    unzip
    virt-install
    virt-manager
    virt-viewer
    xclip
)

install_packages() {
    local key=$1
    shift
    local packages=("$@")

    for pkg in "${packages[@]}"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            echo "Installing $pkg..."
            sudo nala install -y "$pkg"
        else
            echo "$pkg is already installed"
        fi
    done
}

install_packages "extra" "${EXTRA_PACKAGES[@]}"
install_packages "dev" "${DEV_PACKAGES[@]}"

# Enable libvirt services
sudo systemctl enable --now libvirtd

# add user to the libvirt group so you can run VMs without sudo
sudo usermod -aG libvirt $USER
newgrp libvirt

# time synchronization
sudo timedatectl set-ntp true
sudo systemctl enable --now systemd-timesyncd

# Verify
timedatectl status

# [+]============ SOUNDCLOUD SETUP ========================================== [+]
USER=${SUDO_USER:-$(whoami)}
sudo -u "$USER" python3 -m pip install --user pipx
sudo -u "$USER" pipx ensurepath
sudo -u "$USER" pipx install git+https://github.com/flyingrub/scdl
sudo -u "$USER" mkdir -p /home/"$USER"/.config/scdl
sudo -u "$USER" touch /home/"$USER"/.config/scdl/scdl.cfg
sudo -u "$USER" bash -c 'source ~/.bashrc'
sudo -u "$USER" bash -c 'which scdl && scdl --version'

# [+] ================ FIREWALL ====================================== [+]
if ! command -v ufw >/dev/null 2>&1; then
    echo "ufw not installed, skipping firewall setup"
else
    sudo apt install -y ufw
    sudo ufw enable
    sudo ufw allow Samba
    sudo ufw allow 5353/tcp    # mDNS
    sudo ufw allow 3702/tcp    # WSD
    sudo ufw reload
fi

# [+] ================ SAMBA GOODIES ====================================== [+]
# Create sambahome group if missing
if ! getent group sambahome >/dev/null; then
    sudo groupadd sambahome
fi

# Add user to sambashome and sambashare groups
sudo usermod -aG sambahome "$USER"
sudo usermod -aG sambashare "$USER"
sudo usermod -aG users "$USER"

# Setup Public share folder
echo "Creating Public share folder..."
sudo mkdir -p /srv/samba/public
sudo chown -R nobody:nogroup /srv/samba/public
sudo chmod -R 0777 /srv/samba/public

# Setup usershares folder
echo "Creating usershares folder..."
sudo mkdir -p /var/lib/samba/usershares
sudo chown root:sambashare /var/lib/samba/usershares
sudo chmod 1770 /var/lib/samba/usershares

# make sure home directories have correct group and permissions
sudo chgrp -R sambahome /home
sudo chmod -R 770 /home

# Backup original smb.conf and blank it out
if [ -f /etc/samba/smb.conf ]; then
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
    sudo truncate -s 0 /etc/samba/smb.conf
fi

# Insert my cleaned up configuration
cat <<'EOF' | sudo tee /etc/samba/smb.conf
#======================= Global Settings =======================

[global]
   workgroup = WORKGROUP
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user

   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d

   usershare path = /var/lib/samba/usershares
   usershare max shares = 100
   usershare allow guests = yes
   usershare owner only = false

#======================= Share Definitions =======================

[homes]
   comment = Home Directories
   browseable = yes
   read only = no
   create mask = 0700
   directory mask = 0700
   valid users = %S

[printers]
   comment = All Printers
   browseable = no
   path = /var/tmp
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700

[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = yes
   read only = yes
   guest ok = no

[Public]
   path = /srv/samba/public
   browseable = yes
   guest ok = yes
   read only = no
   force user = nobody

[UserHomes]
   path = /home
   browseable = yes
   guest ok = no
   read only = no
   force group = sambahome
EOF

# Set Samba password for user
echo "Set Samba password for $USER..."
sudo smbpasswd -a "$USER"

# Enable and start services
echo "Enabling and starting Samba services..."
sudo systemctl enable --now smbd nmbd
sudo systemctl restart smbd nmbd

echo "Samba setup complete!"
echo "Public share: /srv/samba/public"
echo "Usershares folder: /var/lib/samba/usershares"
echo "UserHomes accessible for user '$USER' with group 'sambahome'."
echo "You must restart the pc in order for the usershares protocol to work"

# [+] ================ MEGASYNC ====================================== [+]
wget https://mega.nz/linux/repo/Debian_12/amd64/megasync-Debian_12_amd64.deb && sudo apt install "$PWD/megasync-Debian_12_amd64.deb"

# [+] ================ WPS AND EXTRA FONTS ====================================== [+]
cd /tmp
git clone https://github.com/dv-anomaly/ttf-wps-fonts.git
cd ttf-wps-fonts
sudo bash install.sh
rm -rf /tmp/ttf-wps-fonts

# [+] ================ WIFI TWEAKS ====================================== [+]
WIFI_SSID="OPTUS_DADS_5GHz"

echo "🔧 Updating resolved.conf with Cloudflare and Google DNS..."
cat > /etc/systemd/resolved.conf <<EOF
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
FallbackDNS=8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
EOF

echo "🔧 Configuring NetworkManager to use systemd-resolved..."
mkdir -p /etc/NetworkManager/conf.d
cat > /etc/NetworkManager/conf.d/dns.conf <<EOF
[main]
dns=systemd-resolved
EOF

echo "🔄 Restarting systemd-resolved and NetworkManager..."
systemctl restart systemd-resolved
systemctl restart NetworkManager

echo "🧹 Deleting old Wi-Fi connection if it exists..."
nmcli connection delete "$WIFI_SSID" >/dev/null 2>&1

echo "📡 Scanning Wi-Fi networks..."
nmcli device wifi rescan
sleep 2

echo "📃 Available networks:"
nmcli device wifi list | grep "$WIFI_SSID"

echo "🔑 Connecting to '$WIFI_SSID'..."
nmcli device wifi connect "$WIFI_SSID" --ask

echo "⚙️  Disabling auto-DNS from router for '$WIFI_SSID'..."
nmcli connection modify "$WIFI_SSID" ipv4.ignore-auto-dns yes
nmcli connection modify "$WIFI_SSID" ipv6.ignore-auto-dns yes

echo "🔁 Reconnecting with new DNS settings..."
nmcli connection down "$WIFI_SSID"
nmcli connection up "$WIFI_SSID"

echo "✅ All done!"
echo
echo "📈 Testing DNS with 'dig openai.com'..."
dig openai.com | grep -E "SERVER:|openai\.com"

echo
echo "📡 Final status:"
resolvectl status | grep -A10 "Link" | grep -E "Link|Current DNS|Default Route"

echo "Detecting Wi-Fi interface..."
IFACE=$(ip -o link show | awk -F': ' '/wl/{print $2; exit}')

if [ -z "$IFACE" ]; then
    echo "No wireless interface found."
    exit 1
fi

echo "Using Wi-Fi interface: $IFACE"

# Bring Wi-Fi up
sudo ip link set "$IFACE" up

# Set MTU to 1500 (Wi-Fi safe max)
sudo ip link set "$IFACE" mtu 1500

# Scan for networks
echo "Scanning Wi-Fi networks..."
sudo iw dev "$IFACE" scan | grep SSID | sort -u

# interface status
echo
echo "Current interface details:"
ip link show "$IFACE" | grep mtu

# IP and routing info
echo
echo "Current IP and routing table:"
ip addr show "$IFACE"
ip route show | grep "$IFACE"

echo "Done."
echo "Reboot system brother"
