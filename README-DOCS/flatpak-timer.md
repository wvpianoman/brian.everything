# My personal systemd flatpak updater

* Tolga Erok
* 24-2-24

## Create flatpak-update.service

location:

```bash
sudo nano /etc/systemd/system/flatpak-update.service
```

```bash
[Unit]
Description=Update Flatpaks
[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak update -y
[Install]
WantedBy=default.target
```

### Create flatpak-update.timer

- `*:0/6` means it will run every 6 hours, starting from midnight.

location:

```bash
sudo nano /etc/systemd/system/flatpak-update.timer
```

```bash
[Unit]
Description=Update Flatpaks
[Timer]
OnCalendar=*:0/6
Persistent=true
[Install]
WantedBy=timers.target
```

### Enable and start services

```bash
systemctl enable flatpak-update.service && systemctl enable flatpak-update.timer
systemctl start flatpak-update.service && systemctl start flatpak-update.timer
systemctl status flatpak-update.service
systemctl status flatpak-update.timer
```

![alt text](image.png)

![alt text](image-1.png)

![alt text](image-2.png)