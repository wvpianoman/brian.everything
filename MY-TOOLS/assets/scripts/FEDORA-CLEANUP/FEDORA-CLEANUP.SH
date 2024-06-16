#!/bin/bash
# Tolga Erok
# fedora40 clean up
# 26/4/24

# Assign color variables
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m'

# Function to display messages
display_message() {
    clear
    echo -e "\n                  Tolga's DEEP fedora cleaner\n"
    echo -e "\e[34m|--------------------\e[33m Currently executing \e[34m-------------------|"
    echo -e "|${YELLOW}==>${NC}  $1"
    echo -e "\e[34m|------------------------------------------------------------|\e[0m"
    echo ""
    gum spin --spinner dot --title "Stand-by..." -- sleep 1
    sleep 1.5
}

# Clean up system upgrade files
system_upgrade_clean() {
    sudo dnf system-upgrade clean
}

# Function to remove uninstalled runtimes and applications
remove_unused() {
    flatpak uninstall --unused -y
    flatpak uninstall --unused -y --delete-data
}

# Function to remove extra packages excluding kernel-related ones
remove_extra_packages() {
    sudo dnf remove $(sudo dnf repoquery --extras --exclude=kernel,kernel-*) -y
}

# Function to remove old versions of install-only packages
remove_old_packages() {
    sudo dnf remove $(sudo dnf repoquery --installonly --latest-limit=-3) -y
}

# Function to rotate journal files and vacuum journal entries older than 1 second
rotate_and_vacuum_journal() {
    sudo journalctl --rotate && sudo journalctl --vacuum-time=1s
}

# Function to install and execute tool for removing retired packages
install_and_remove_retired_packages() {
    sudo dnf install remove-retired-packages -y
}

# Update installed packages
display_message "[${GREEN}✔${NC}]  Updating installed packages..."
sudo dnf update -y

# Clean up system upgrade files
display_message "[${GREEN}✔${NC}]  Cleaning up system upgrade files..."
system_upgrade_clean

# Remove uninstalled runtimes and applications
display_message "[${GREEN}✔${NC}]  Removing uninstalled runtimes and applications..."
remove_unused

# List packages with unresolved dependencies
display_message "[${GREEN}✔${NC}]  Listing packages with unresolved dependencies..."
sudo dnf repoquery --unsatisfied

# List duplicate packages
display_message "[${GREEN}✔${NC}]  Listing duplicate packages..."
sudo dnf repoquery --duplicates

# List installed packages not in any repository
display_message "[${GREEN}✔${NC}]  Listing installed packages not in any repository..."
sudo dnf list extras

# Remove extra packages excluding kernel-related ones
display_message "[${GREEN}✔${NC}]  Removing extra packages excluding kernel-related ones..."
remove_extra_packages

# Remove unused dependencies
display_message "[${GREEN}✔${NC}]  Removing unused dependencies..."
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
display_message "[${GREEN}✔${NC}]  Cleaning up temporary files..."
sudo rm -rf /tmp/orphaned-pkgs

# Trim all mount points on SSD
display_message "[${GREEN}✔${NC}]  Trimming all mount points on SSD..."
sudo fstrim -av

# Clean DNF cache
display_message "[${GREEN}✔${NC}]  Cleaning DNF cache..."
sudo dnf -y clean all

# Enable trim support
display_message "[${GREEN}✔${NC}]  Enabling trim support..."
sudo systemctl enable fstrim.timer

# Install and execute tool for removing retired packages
display_message "[${GREEN}✔${NC}]  Installing and executing tool for removing retired packages..."
install_and_remove_retired_packages

# Install tool for managing configuration files
display_message "[${GREEN}✔${NC}]  Installing tool for managing configuration files..."
sudo dnf install rpmconf -y

# Interactively manage configuration files that have been changed
display_message "[${GREEN}✔${NC}]  Interactively managing configuration files..."
sudo rpmconf -a

# Remove old versions of install-only packages
display_message "[${GREEN}✔${NC}]  Removing old versions of install-only packages..."
remove_old_packages

# Check for and remove dangling symbolic links in the /usr directory
display_message "[${GREEN}✔${NC}]  Checking for and removing dangling symbolic links..."
sudo symlinks -r -d /usr

# Rotate journal files and vacuum journal entries older than 1 second
display_message "[${GREEN}✔${NC}]  Rotating journal files and vacuuming journal entries..."
rotate_and_vacuum_journal

# Final message
display_message "[${GREEN}✔${NC}]  Cleanup process completed successfully!"

