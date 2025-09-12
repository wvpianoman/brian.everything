#!/usr/bin/env bash
# tolga-network-opt-setup.sh
# Sets up systemd service to load CAKE + BBR at boot for my aurora box
# 27/8/25

set -e

echo "Creating helper script for my brother..."
sudo tee /usr/local/bin/tolga-network-opt.sh > /dev/null <<'EOF'
#!/usr/bin/env bash
# Tolga's CAKE + BBR initializer

modprobe sch_cake
modprobe tcp_bbr

# Wait for wlan0 to be operational brother, yours may differ
while [[ "$(cat /sys/class/net/wlan0/operstate 2>/dev/null)" != "up" ]]; do
    sleep 1
done

# Apply CAKE to wlan0
tc qdisc replace dev wlan0 root cake

# Set BBR globally
sysctl -w net.ipv4.tcp_congestion_control=bbr
EOF

sudo chmod +x /usr/local/bin/tolga-network-opt.sh

echo "Creating linuxtweaks CAKE & BBR systemd service for AURORA .."
sudo tee /etc/systemd/system/tolga-network-opt.service > /dev/null <<'EOF'
[Unit]
Description=Tolga's CAKE + BBR Network Optimizer
After=network.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/tolga-network-opt.sh
RemainAfterExit=yes
TimeoutStartSec=2min

[Install]
WantedBy=multi-user.target
EOF

# Backup sysctl configs first brother
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
sudo cp -r /etc/sysctl.d /etc/sysctl.d.bak

# Remove old CAKE + BBR keys from sysctl configs thats is lingering in the bowels of your system
sudo sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sudo sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
sudo grep -rl 'net.core.default_qdisc\|net.ipv4.tcp_congestion_control' /etc/sysctl.d/ | while read f; do
    sudo sed -i '/net.core.default_qdisc/d' "$f"
    sudo sed -i '/net.ipv4.tcp_congestion_control/d' "$f"
done

echo "Removed CAKE + BBR keys from sysctl configs. Managed only via linuxtweaks CAKE & BBR systemd now... brother"

echo "Reloading systemd and enabling service...1 sec brother..."
sleep 3
clear
sudo systemctl daemon-reload
sudo sysctl --system
echo ""
sudo systemctl enable --now tolga-network-opt.service
sudo systemctl restart tolga-network-opt.service
sudo systemctl status tolga-network-opt.service --no-pager
echo ""
sudo sysctl -a | grep -E "qdisc|congestion"
echo ""
check-network
echo ""
echo "✅ CAKE + BBR systemd service installed and running, brother, enjoy!"
