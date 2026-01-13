#!/usr/bin/env bash
# Tolga Erok
# For Brians
set -e

wget https://mega.nz/linux/repo/Debian_testing/amd64/megacmd-Debian_testing_amd64.deb && sudo apt install "$PWD/megacmd-Debian_testing_amd64.deb"

service_dir="$HOME/.config/systemd/user"
bin_dir="$HOME/bin"

mkdir -p "$service_dir" "$bin_dir"

# create the brian-mega.sh sync script
cat > "$bin_dir/brian-mega.sh" << 'EOF'
#!/usr/bin/env bash
set -e

# Auto-login change your password brother
mega-login "dbf.linux@gmail.com" "PASSWORD"

# Sync directories
mega-sync "$HOME/Documents"               "/Documents"
mega-sync "$HOME/Pictures"                "/Pictures"
mega-sync "$HOME/Templates"               "/Templates"
mega-sync "$HOME/Music"                   "/Music"
mega-sync "$HOME/Videos"                  "/Videos"
mega-sync "$HOME/Downloads/appimage_files" "/appimage_files"
mega-sync "$HOME/Downloads/apps"          "apps"
mega-sync "$HOME/github"                  "/github"
mega-sync "$HOME/scripts"                 "/scripts"
mega-sync "$HOME/Downloads/ventoy"        "/Ventoy"

echo "✅ MegaCMD sync complete."
EOF

chmod +x "$bin_dir/brian-mega.sh"

# Service unit
cat > "$service_dir/mega-cmd-mon.service" << EOF
[Unit]
Description=Mega-CMD per-user service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Restart=on-failure
RestartSec=5
ExecStart=%h/bin/brian-mega.sh

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

# Reload and enable both
systemctl --user daemon-reload
systemctl --user enable --now mega-cmd-mon.service
systemctl --user enable --now mega-cmd-mon.timer

echo "✅ Mega-CMD service, timer, and brian-mega.sh installed, enabled, and started. Enjoy brother!"
