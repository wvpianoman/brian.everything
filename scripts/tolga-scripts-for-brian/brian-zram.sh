# ------------- ssd tweaks & ram ---------------

echo "setting up tmpfs for /tmp..."

sudo tee /etc/systemd/system/tmp.mount >/dev/null <<EOF
[Unit]
Description=Temporary Directory /tmp
Documentation=man:file-hierarchy(7)
DefaultDependencies=no
Conflicts=umount.target
Before=local-fs.target umount.target

[Mount]
What=tmpfs
Where=/tmp
Type=tmpfs
Options=size=8G,mode=1777

[Install]
WantedBy=local-fs.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now tmp.mount
df -h /tmp

sudo tee /etc/sysctl.d/99-tuned-ssd.conf <<EOF
vm.dirty_ratio = 28
vm.dirty_background_ratio = 14
vm.dirty_expire_centisecs = 1200
vm.dirty_writeback_centisecs = 200
EOF

ram_gb=$(free -g | awk '/Mem:/{print $2}')
swapfile="/swapfile"

if (( ram_gb < 2 )); then
    swapsize=$(( ram_gb * 2 ))
    swappy=70
elif (( ram_gb <= 8 )); then
    swapsize=$ram_gb
    swappy=30
elif (( ram_gb <= 16 )); then
    swapsize=4
    swappy=20
else
    swapsize=4
    swappy=10
fi

echo "detected ram: ${ram_gb}gb"
echo "creating ${swapsize}gb swap swappiness=${swappy}"
sleep 1

sudo swapoff -a 2>/dev/null
sudo dd if=/dev/zero of=$swapfile bs=1M count=$((swapsize * 1024))
sudo chmod 600 $swapfile
sudo mkswap $swapfile
sudo swapon $swapfile

grep -q "$swapfile" /etc/fstab || echo "$swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab

sudo sysctl vm.swappiness=$swappy

sudo sysctl --system

swapon --show
free -h
