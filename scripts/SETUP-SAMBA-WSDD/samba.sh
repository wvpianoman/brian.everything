#!/bin/bash
### #!/usr/bin/env bash

	# Install Samba and its dependencies
	sudo eopkg it -y samba cifs-utils

	# Enable and start SMB and NMB services
	display_message "[${GREEN}✔${NC}]  SMB && NMB services started"
	sudo systemctl enable smb.service nmb.service
	sudo systemctl start smb.service nmb.service

	# Restart SMB and NMB services (optional)
	sudo systemctl restart smb.service nmb.service

	# Configure the firewall
	display_message "[${GREEN}✔${NC}]  Firewall Configured"
	sudo firewall-cmd --add-service=samba --permanent
	sudo firewall-cmd --add-service=samba
	sudo firewall-cmd --runtime-to-permanent
	sudo firewall-cmd --reload

	# Set SELinux booleans
	display_message "[${GREEN}✔${NC}]  SELINUX parameters set "
	sudo setsebool -P samba_enable_home_dirs on
	sudo setsebool -P samba_export_all_rw on
	sudo setsebool -P smbd_anon_write 1

	# Create samba user/group
	display_message "[${GREEN}✔${NC}]  Create smb user and group"
	read -r -p "Set-up samba user & group's
" -t 2 -n 1 -s

	# Prompt for the desired username for samba
	read -p $'\n'"Enter the USERNAME to add to Samba: " sambausername

	# Prompt for the desired name for samba
	read -p $'\n'"Enter the GROUP name to add username to Samba: " sambagroup

	# Add the custom group
	sudo groupadd $sambagroup

	# ensures that a home directory is created for the user
	sudo useradd -m $sambausername

	# Add the user to the Samba user database
	sudo smbpasswd -a $sambausername

	# enable or activate the Samba user account for login
	sudo smbpasswd -e $sambausername

	# Add the user to the specified group
	sudo usermod -aG $sambagroup $sambausername

	read -r -p "
Continuing..." -t 1 -n 1 -s

	# Configure custom samba folder
	read -r -p "Create and configure custom samba folder located at /home/solus
" -t 2 -n 1 -s

	sudo mkdir /home/solus
	sudo chgrp samba /home/solus
	sudo chmod 770 /home/solus
	sudo restorecon -R /home/solus

	# Create the sambashares group if it doesn't exist
	sudo groupadd -r sambashares

	# Create the usershares directory and set permissions
	sudo mkdir -p /var/lib/samba/usershares
	sudo chown $username:sambashares /var/lib/samba/usershares
	sudo chmod 1770 /var/lib/samba/usershares

	# Restore SELinux context for the usershares directory
	display_message "[${GREEN}✔${NC}]  Restore SELinux for usershares folder"
	sudo restorecon -R /var/lib/samba/usershares

	# Add the user to the sambashares group
	display_message "[${GREEN}✔${NC}]  Adding user to usershares"
	sudo gpasswd sambashares -a $username

	# Add the user to the sambashares group (alternative method)
	sudo usermod -aG sambashares $username

	# Restart SMB and NMB services (optional)
	display_message "[${GREEN}✔${NC}]  Restart SMB && NMB (samba) services"
	sudo systemctl restart smb.service nmb.service
