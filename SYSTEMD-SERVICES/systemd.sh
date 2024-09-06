sudo cp $HOME/GitHub/brian-everything/BASE/SYSTEMD-SERVICES/*.service /etc/systemd/system/

sudo systemctl enable --now onedrive.service
sudo systemctl enable --now mega.service
