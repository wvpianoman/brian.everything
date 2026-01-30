# ------------- FSTRIM tweak ---------------
clear 

progress() {

    echo "→ $1"
    echo "   Brother, I'm running: $2"
    eval "$2"
    echo "   done"
    echo
}

echo
echo "🧹 setting up daily fstrim..."
sleep 1

sudo mkdir -p /etc/systemd/system/fstrim.timer.d
cat <<EOF | sudo tee /etc/systemd/system/fstrim.timer.d/override.conf >/dev/null
[Timer]
OnCalendar=
OnCalendar=daily
EOF

progress "rebuilding grub and initramfs" "update-grub && update-initramfs -u -k all"
progress "setting up zram swap" "modprobe zram && mkswap /dev/zram0 && swapon /dev/zram0"
progress "enabling daily fstrim" "systemctl enable fstrim.timer && systemctl restart fstrim.timer"

sudo systemctl daemon-reload
sudo systemctl enable fstrim.timer
sudo systemctl restart fstrim.timer
sudo systemctl status fstrim.timer --no-pager || true

echo
sudo dmesg | grep -i zswap | tail -n 5 || echo "zswap will activate after reboot"
echo "✅ all done — reboot to enjoy compressed swap and faster io"
sleep 2

