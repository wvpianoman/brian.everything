#!/usr/bin/env bash
# Tolga Erok
# Short cut to my server creator


path="$HOME/Desktop/Tolga_QNAP.desktop"

cat > "$path" <<EOF
[Desktop Entry]
Type=Link
Name=Tolga_QNAP_Server
Icon=internet
URL=https://49.194.247.185/share.cgi?ssid=0vk2Hj9
EOF

chmod +x "$path"