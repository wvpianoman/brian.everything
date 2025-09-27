sudo cp mega-cmd-mon.service /etc/systemd/user/mega-cmd-mon.service
sudo cp mega-cmd-mon.timer /etc/systemd/user/mega-cmd-mon.timer

systemctl --user daemon-reload
systemctl --user enable --now mega-cmd-mon.service
systemctl --user enable --now mega-cmd-mon.timer
