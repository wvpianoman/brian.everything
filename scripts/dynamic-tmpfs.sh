#!/bin/bash
# tolga erok
# my dynamic ramdisk setup - aio
# calculates 25% of total ram, rounds down to nearest 128mb, creates tmpfs mount unit

set -e

RAM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')  # in KB???
RAM_25=$((RAM_TOTAL / 4))

# round down to nearest 128MB (131072 KB) ??? should work
RAM_ROUND=$(( (RAM_25 / 131072) * 131072 ))

RAM_MB=$((RAM_ROUND / 1024))

MOUNT_POINT=/mnt/ramdisk
UNIT_FILE=/etc/systemd/system/mnt-ramdisk.mount

echo "===> calculating ramdisk size, please wait brother..."
echo "total RAM: $((RAM_TOTAL / 1024)) MB"
echo "25% of RAM: $((RAM_25 / 1024)) MB"
echo "rounded size: ${RAM_MB}MB"

echo "===> preparing mountpoint..."
sudo mkdir -p $MOUNT_POINT

echo "===> creating systemd mount unit..."
sudo tee $UNIT_FILE > /dev/null <<EOF
[Unit]
Description=Tolga's Dynamic tmpfs ramdisk setup 2025
DefaultDependencies=no
Before=local-fs.target

[Mount]
What=tmpfs
Where=$MOUNT_POINT
Type=tmpfs
Options=size=${RAM_MB}M,mode=1777,noatime

[Install]
WantedBy=multi-user.target
EOF

echo "===> reloading systemd..."
sudo systemctl daemon-reload
sudo systemctl enable mnt-ramdisk.mount
sudo systemctl start mnt-ramdisk.mount

echo "===> verifying setup..."
echo
echo "df output:"
df -h $MOUNT_POINT
echo
echo "mount options:"
mount | grep $MOUNT_POINT
echo
echo "systemd status:"
systemctl status mnt-ramdisk.mount --no-pager

# recheck
systemctl is-enabled mnt-ramdisk.mount
systemctl status mnt-ramdisk.mount --no-pager
df -h "$MOUNT_POINT"
mount | grep -F "$MOUNT_POINT"
journalctl -b -u mnt-ramdisk.mount --no-pager
sudo cat /etc/systemd/system/mnt-ramdisk.mount

# should be no ramdisk entries in my fstab, should be all 100% systemD
grep -x 'tmpfs.*/mnt/ramdisk' /etc/fstab || echo 'no fstab entry for /mnt/ramdisk'
grep -q 'tmpfs.*/mnt/ramdisk' /etc/fstab || echo "no fstab entry for /mnt/ramdisk"

