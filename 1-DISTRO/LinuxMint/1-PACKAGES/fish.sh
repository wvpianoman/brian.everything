# fish shell
sudo add-apt-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish

# fish plugins
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install IlanCosman/tide@v6

