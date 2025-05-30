#!/usr/bin/env bash

# Metadata
# ----------------------------------------------------------------------------
# AUTHOR="Tolga Erok"
# VERSION="V6.0"
# DATE_CREATED="16/3/2025"
# Description: Systemd script to force CAKE onto any active network interface.

YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

# Detect pkg manager
if command -v dnf &>/dev/null; then
    PM="dnf"
    INSTALL_CMD="sudo dnf install -y"
elif command -v pacman &>/dev/null; then
    PM="pacman"
    INSTALL_CMD="sudo pacman -Sy --needed"
else
    echo -e "${RED}Unsupported distribution. Exiting...${NC}"
    exit 1
fi

# Check and install `tc`
if ! command -v tc &>/dev/null; then
    echo -e "${YELLOW}tc command not found, installing iproute2...${NC}"
    $INSTALL_CMD iproute2
    hash -r
fi

# Detect active network interface (wired or wireless, non-loopback - BETA)
interface=$(ip -o link show | awk -F": " '
    $2 ~ /^wlp/ && $0 ~ "UP" && $0 !~ "NO-CARRIER" {print $2; exit}  # Prefer wireless if UP and not NO-CARRIER
    $2 !~ "lo" && $0 ~ "UP" && $0 !~ "NO-CARRIER" {print $2; exit}   # Otherwise, pick first available UP interface
')

if [ -z "$interface" ]; then
    echo -e "${RED}No active network interface found. Exiting.${NC}"
    exit 1
fi

echo -e "${BLUE}Detected active network interface: ${interface}${NC}"

# systemd service names
SERVICE_NAME="tolga-apply-cake-qdisc.service"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
SERVICE_NAME2="tolga-apply-cake-qdisc-wake.service"
SERVICE_FILE2="/etc/systemd/system/$SERVICE_NAME2"

# Create systemd file for after boot
echo -e "${BLUE}Creating systemd service file at ${SERVICE_FILE}...${NC}"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Tolga's V6.0 CAKE qdisc for active network interface
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'interface=\$(ip link show | awk -F": " '\''\$0 ~ "^[2-9]:|^[1-9][0-9]: " && \$0 ~ "UP" && \$0 !~ "LOOPBACK|NO-CARRIER" {gsub(/^[ \t]+|[ \t]+$/, "", \$2); print \$2; getline}'\''); if [ -n "\$interface" ]; then sudo tc qdisc replace dev \$interface root cake bandwidth 1Gbit; fi'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Create systemd for after suspend/wake
echo -e "${BLUE}Creating systemd service file at ${SERVICE_FILE2}...${NC}"
sudo bash -c "cat > $SERVICE_FILE2" <<EOF
[Unit]
Description=Re-apply Tolga's V6.0 CAKE qdisc after suspend/wake
After=suspend.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'interface=\$(ip link show | awk -F": " '\''\$0 ~ "^[2-9]:|^[1-9][0-9]: " && \$0 ~ "UP" && \$0 !~ "LOOPBACK|NO-CARRIER" {gsub(/^[ \t]+|[ \t]+$/, "", \$2); print \$2; getline}'\''); if [ -n "\$interface" ]; then sudo tc qdisc replace dev \$interface root cake bandwidth 1Gbit; fi'

[Install]
WantedBy=suspend.target
EOF

# Reload systemd and enable services
echo -e "${BLUE}Reloading systemd daemon and enabling services...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable --now tolga-apply-cake-qdisc.service
sudo systemctl enable --now tolga-apply-cake-qdisc-wake.service

echo -e "${BLUE}Verifying qdisc configuration for ${interface}:${NC}"

sudo tc qdisc show dev "$interface"
echo -e "${YELLOW}CAKE qdisc should be applied to ${interface} now.${NC}"
sudo tc -s qdisc show dev "$interface"

sudo systemctl status tolga-apply-cake-qdisc.service --no-pager
sudo systemctl status tolga-apply-cake-qdisc-wake.service --no-pager

# Add new custom alias to .bashrc
set +H
echo "alias cake3='interface=\$(ip link show | awk -F: '\''\$0 ~ \"wlp|wlo|wlx\" && \$0 !~ \"NO-CARRIER\" {gsub(/^[ \t]+|[ \t]+$/, \"\", \$2); print \$2; exit}'\''); sudo systemctl daemon-reload && sudo systemctl restart tolga-apply-cake-qdisc.service && sudo tc -s qdisc show dev \$interface && sudo systemctl status tolga-apply-cake-qdisc.service --no-pager && sudo systemctl status tolga-apply-cake-qdisc-wake.service --no-pager'" >>$HOME/.bashrc
echo -e "${YELLOW}Alias 'cake3' added to .bashrc. You can use it to quickly apply CAKE settings.${NC}"
