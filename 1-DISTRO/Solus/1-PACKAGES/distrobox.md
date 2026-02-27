#

<h1 align="center">
   The Ultimate Distrobox / Docker / BoxBuddy Cheat Sheet 
                Brian F 10-22-24
</h1>



Distrobox is a program that lets you run almost any Linux distro in a terminal. This means you can install apps from Fedora, Ubuntu, and Arch without a dual boot or a VM, and run them as if they were running natively! I tested it to run MegaSync and SublimeText, and it works pretty well, if a bit finicky to set up. 

## Steps I followed: 

### Install docker: 
```bash
sudo eopkg it docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
```
### Install distrobox without root: 
```bash
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
```
Create docker user group and add current user to it: 
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```
Add these lines to .bashrc so DIstrobox will be in your path and you can run graphical applications: 
```bash
export PATH="$PATH:$HOME/local/bin"
xhost +si:localuser:$USER
```
Follow the instructions on Github to create and enter a new container. Then you can run commands for the native distro and install whatever you want (just exercise care).

To allow easier access to Distrobox via GUI, you need to install a couple of flatpak apps.  Boxbuddy and Flatseal.  To install these run
'''bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.dvlv.boxbuddyrs
flatpak install flathub com.github.tchx84.Flatseal
'''

## BOXBUDDY  - Allowing Filesystem Access with Flatseal

Boxbuddy needs access to the user files to operate properly.  You just need to start Flatseal and pick BoxBuddy from the Applications tab on the left hand side.  Once you have selected BoxBuddy, scroll down to Filesystems and tick the switch for All user files.

Exit Flatseal, reboot to ensure all system changes are applied, Run BoxBuddy and make your first container.
