### Systemd timer *to clean up paccache*

Create a file with 

```console 
sudo nano /etc/systemd/system/paccache.timer
```
with the following contents
```
[Unit]
Description=Clean-up old pacman pkg cache

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=multi-user.target
```


Enable with
```console 
sudo systemctl start paccache.timer
```