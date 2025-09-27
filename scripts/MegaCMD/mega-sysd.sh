#!/usr/bin/env bash
# Tolga Erok
# For Brian
set -e

service_dir="$HOME/.config/systemd/user"

mkdir -p "$service_dir"

# Service unit
cat > "$service_dir/mega-cmd-mon.service" << 'EOF'
[Unit]
Description=Mega-CMD per-user service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Restart=on-failure
RestartSec=5
ExecStart=/usr/bin/mega-cmd-server

[Install]
WantedBy=default.target
EOF

# Timer unit
cat > "$service_dir/mega-cmd-mon.timer" << 'EOF'
[Unit]
Description=Start Mega-CMD on login and keep it nudged

[Timer]
OnBootSec=30s
OnUnitActiveSec=30m
Unit=mega-cmd-mon.service

[Install]
WantedBy=timers.target
EOF

# Reload and enable both for my brother
systemctl --user daemon-reload
systemctl --user enable --now mega-cmd-mon.service
systemctl --user enable --now mega-cmd-mon.timer

echo "✅ Mega-CMD service and timer installed, enabled, and started. Enjoy brother"
