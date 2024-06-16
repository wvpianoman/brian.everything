#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# 22 May 2024

#   《˘ ͜ʖ ˘》
#
#  ███████╗ ██████╗ ███████╗████████╗██╗    ██╗ █████╗ ██████╗ ███████╗    ██████╗ ██╗  ██╗ ██████╗ ███████╗
#  ██╔════╝██╔═══██╗██╔════╝╚══██╔══╝██║    ██║██╔══██╗██╔══██╗██╔════╝    ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
#  ███████╗██║   ██║█████╗     ██║   ██║ █╗ ██║███████║██████╔╝█████╗      ██████╔╝█████╔╝ ██║  ███╗███████╗
#  ╚════██║██║   ██║██╔══╝     ██║   ██║███╗██║██╔══██║██╔══██╗██╔══╝      ██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
#  ███████║╚██████╔╝██║        ██║   ╚███╔███╔╝██║  ██║██║  ██║███████╗    ██║     ██║  ██╗╚██████╔╝███████║
#  ╚══════╝ ╚═════╝ ╚═╝        ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Software%20Pkgs

# Tolga Erok
# for
# Brian
# 4/3/2024

# clear

wget https://mega.nz/linux/repo/Fedora_40/x86_64/megasync-Fedora_40.x86_64.rpm && sudo rpm-ostree install "$PWD/megasync-Fedora_40.x86_64.rpm"

echo "Package installation completed."

sleep 3

# read -n 1 -r -s -p $'Press enter to continue...\n'

sudo rpm-ostree install -y earlyoom
sudo systemctl enable --now earlyoom

	# Install some fonts
	display_message "[${GREEN}✔${NC}]  Installing some fonts"

sudo rpm-ostree install -y curl cabextract xorg-x11-font-utils fontconfig -y
sudo rpm-ostree -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
sudo unzip FiraCode.zip -d /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
sudo unzip Meslo.zip -d /usr/share/fonts
wget https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip
sudo unzip WPS-FONTS.zip -d /usr/share/fonts/wps-office

# Reloading Font
sudo fc-cache -vf

# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip ./WPS-FONTS.zip

	sudo rpm-ostree install -y fontawesome-fonts powerline-fonts 'google-roboto*' 'mozilla-fira*' fira-code-fonts
	sudo rpm-ostree install -y redhat-{mono,text,display}-fonts xorg-x11-fonts-ISO8859-1-100dpi google-noto-emoji-color-fonts

	sudo mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
	wget https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip
	unzip WPS-FONTS.zip -d /usr/share/fonts

	zip_file="Apple-Fonts-San-Francisco-New-York-master.zip"

	# Check if the ZIP file exists
	if [ -f "$zip_file" ]; then
		# Remove existing ZIP file
		sudo rm -f "$zip_file"
		echo "Existing ZIP file removed."
	fi

	# Download the ZIP file
	curl -LJO https://github.com/tolgaerok/Apple-Fonts-San-Francisco-New-York/archive/refs/heads/master.zip

	# Check if the download was successful
	if [ -f "$zip_file" ]; then
		# Unzip the contents to the system-wide fonts directory
		sudo unzip -o "$zip_file" -d /usr/share/fonts/

		# Update font cache
		sudo fc-cache -f -v

		# Remove the ZIP file
		rm "$zip_file"

		display_message "[${GREEN}✔${NC}] Apple fonts installed successfully."
		echo ""
		gum spin --spinner dot --title "Re-thinking... 1 sec" -- sleep 2
	else
		display_message "[${RED}✘${NC}] Download failed. Please check the URL and try again."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi

	# Removing zip Files & reloading font cache
	rm ./WPS-FONTS.zip
	sudo fc-cache -f -v

####################################################

	# Enable trim support
	sudo systemctl enable fstrim.timer
#################################################

	# Audio
	[ -f /usr/bin/easyeffects ] && [ -f $HOME/.config/easyeffects/output/default.json ] && easyeffects -l default
	[ -f /usr/bin/pulseeffects ] && [ -f $HOME/.config/PulseEffects/output/default.json ] && pulseeffects -l default
-----------------------------------------------

	# Configure fortune
	# If you want to display a specific fortune file or category, you can use the -e option followed by the file or category name. For example:
	# fortune -e art ascii-art bofh-excuses computers cookie definitions disclaimer drugs education fortunes humorists kernelnewbies knghtbrd law linux literature miscellaneous news people riddles science
	# or to see a list:
	# fortune -f

	# Execute rygel to start DLNA sharing
	/usr/bin/rygel-preferences

	# Install profile-sync: it to manage browser profile(s) in tmpfs and to periodically sync back to the physical disc (HDD/SSD)
	sudo dnf install -y profile-sync-daemon
	/usr/bin/profile-sync-daemon preview
	# sudo dnf remove profile-sync-daemon
	# psd profile located in $HOME/.config/psd/psd.conf


	## Make a backup of the original sysctl.conf file
	display_message "[${GREEN}✔${NC}]  Tweaking network settings"

	cp $SYS_PATH /etc/sysctl.conf.bak

	echo
	yellow_msg 'Default sysctl.conf file Saved. Directory: /etc/sysctl.conf.bak'
	echo
	gum spin --spinner dot --title "Stand-by..." -- sleep 1

function cleanup_fedora() {
	# Clean package cache
	display_message "[${GREEN}✔${NC}]  Time to clean up system..."
	sudo dnf clean all

	# Remove unnecessary dependencies
	sudo dnf autoremove -y

	# Sort the lists of installed packages and packages to keep
	display_message "[${GREEN}✔${NC}]  Sorting out list of installed packages and packages to keep..."
	comm -23 <(sudo dnf repoquery --installonly --latest-limit=-1 -q | sort) <(sudo dnf list installed | awk '{print $1}' | sort) >/tmp/orphaned-pkgs

	if [ -s /tmp/orphaned-pkgs ]; then
		sudo dnf remove $(cat /tmp/orphaned-pkgs) -y --skip-broken
	else
		display_message "[${GREEN}✔${NC}]  Congratulations, no orphaned packages found."
	fi

	# Clean up temporary files
	display_message "[${GREEN}✔${NC}]  Clean up temporary files ..."
	sudo rm -rf /tmp/orphaned-pkgs

	display_message "[${GREEN}✔${NC}]  Trimming all mount points on SSD"
	sudo fstrim -av

	echo -e "\e[1;32m[✔]\e[0m Restarting kernel tweaks...\n"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
	sudo sysctl -p

	display_message "[${GREEN}✔${NC}]  Cleanup complete, ENJOY!"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

# Function to clear systemd journal logs
    "com.obsproject.Studio"function clear_journal_logs() {
    sudo journalctl --vacuum-time=7d
    echo "Systemd journal logs cleared."
}

# Lets clean up
echo -e "\n\n----------------------------------------------"
echo -e "|     Let's clean up                         |"
echo -e "----------------------------------------------\n\n"
sudo update-grub
sudo dnf -y up
sudo dnf -y autoremove
sudo dnf -y clean all
clear_journal_logs
cleanup_fedora

echo -e "\n\n----------------------------------------------"
echo -e "|     Let's clean up your SSD                 |"
echo -e "----------------------------------------------\n\n"
# sudo fstrim -av

echo -e "\n\n----------------------------------------------"
echo -e "|                                            |"
echo -e "|      Setup Complete! Enjoy Ultramarine     |"
echo -e "|       Please run ___________.sh            |"
echo -e "|    to back up your APT packages and more   |"
echo -e "|                                            |"
echo -e "----------------------------------------------\n\n"

# exit 0
