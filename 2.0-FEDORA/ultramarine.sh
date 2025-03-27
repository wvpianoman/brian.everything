#!/bin/bash

# Brian Francisco
# My personal Ultramarine/Fedora KDE tweaker
# 18/11/2023

# Run from remote location:
# sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/wvpianoman/brian-ultramarine/main/mushroom-magic/brianum.sh)"

#  ¯\_(ツ)_/¯
#
#  ██╗   ██╗██╗  ████████╗██████╗  █████╗ ███╗   ███╗ █████╗ ██████╗ ██╗███╗   ██╗███████╗
#  ██║   ██║██║  ╚══██╔══╝██╔══██╗██╔══██╗████╗ ████║██╔══██╗██╔══██╗██║████╗  ██║██╔════╝
#  ██║   ██║██║     ██║   ██████╔╝███████║██╔████╔██║███████║██████╔╝██║██╔██╗ ██║█████╗
#  ██║   ██║██║     ██║   ██╔══██╗██╔══██║██║╚██╔╝██║██╔══██║██╔══██╗██║██║╚██╗██║██╔══╝
#  ╚██████╔╝███████╗██║   ██║  ██║██║  ██║██║ ╚═╝ ██║██║  ██║██║  ██║██║██║ ╚████║███████╗
#   ╚═════╝ ╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Ultramarine

clear

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
	echo "Please run this script as root or using sudo."
	exit 1
fi

[ ${UID} -eq 0 ] && read -p "Username for this script: " user && export user || export user="$USER"

# Check whether if the windowing system is Xorg or Wayland
if [[ ${XDG_SESSION_TYPE} == "wayland" ]]; then
	export MOZ_ENABLE_WAYLAND=1
	export OBS_USE_EGL=1
fi

# QT/Kvantum theme
if [ -f /usr/bin/qt5ct ]; then
	export QT_QPA_PLATFORM="xcb"
	export QT_QPA_PLATFORMTHEME="qt5ct"
fi

BASHRC_FILE="$HOME/.bashrc"
# desired_ps1='PS1="\[\e[1;32m\]┌[\[\e[1;32m\]\u\[\e[1;34m\]@\h\[\e[1;m\]] \[\e[1;m\]::\[\e[1;36m\] \W \[\e[1;m\]::\n\[\e[1;m\]└\[\e[1;33m\]➤ 🖐️👀 👉\[\e[0;m\] "'
desired_ps1='PS1="\[\e[1;m\]┌[\[\e[1;32m\]\u\[\e[1;34m\]@\h\[\e[1;m\]] \[\e[1;m\]::\[\e[1;36m\] \W \[\e[1;m\]::\n\[\e[1;m\]└\[\e[1;33m\]➤ 🖐️👀 👉\[\e[0;m\]  "'
fortune='echo "" && fortune | lolcat && echo "" '

if ! grep -qF "$desired_ps1" "$BASHRC_FILE"; then
	# Add desired PS1 configuration to .bashrc
	echo -e "$desired_ps1" >>"$BASHRC_FILE"
	echo -e "$fortune" >>"$BASHRC_FILE"
	source "$BASHRC_FILE"

	gum spin --spinner dot --title "Custom bashrc colors added, standby..." -- sleep 2
else
	gum spin --spinner dot --title "Bashrc custom colors already exist, standby..." -- sleep 2
fi

# Assign a color variable based on the RANDOM number
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'
YELLOW='\e[1;33m'
NC='\e[0m'

# Green, Yellow & Red Messages.
green_msg() {
	tput setaf 2
	echo "[*] ----- $1"
	tput sgr0
}

yellow_msg() {
	tput setaf 3
	echo "[*] ----- $1"
	tput sgr0
}

red_msg() {
	tput setaf 1
	echo "[*] ----- $1"
	tput sgr0
}

# Declare Paths & Settings
CONFIG_CONTENT="[General]\nNumlock=on"
PROF_PATH="/etc/profile"
SDDM_CONF="/etc/sddm.conf.d/sddm.conf"
SSH_PATH="/etc/ssh/sshd_config"
SSH_PORT=""
SWAP_PATH="/swapfile"
SWAP_SIZE=2G
SYS_PATH="/etc/sysctl.conf"

sudo dnf install -y figlet fortune-mod lolcat

# Update Time (Enable Network Time)
sudo timedatectl set-ntp true

# Update User Dirs
[ -f /usr/bin/xdg-user-dirs-update ] && xdg-user-dirs-update

# Set to performance
#[ -f /usr/bin/powerprofilesctl ] && powerprofilesctl list | grep -q performance && powerprofilesctl set performance

clear

echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo

sudo yum install gum -y
clear

# Function to set I/O scheduler
set_io_scheduler() {
	local device_path=$1
	local scheduler=$2
	echo ""
	echo "Setting I/O scheduler for $device_path to $scheduler..."
	echo "$scheduler" >"$device_path/queue/scheduler"
	gum spin --spinner dot --title "Stand-by..." -- sleep .5

}

# Determine the device type (you may need to customize this based on your system)
if [[ -e "/sys/block/sda" ]]; then
	DEVICE_PATH="/sys/block/sda"
elif [[ -e "/sys/class/nvme/" ]]; then
	DEVICE_PATH="/sys/block/nvme0n1"
else
	echo "Unknown device type. Exiting."
	exit 1
fi

# Determine the I/O scheduler based on user's choice
echo ""
echo "Current I/O scheduler is:"
echo ""
cat /sys/block/sda/queue/scheduler
echo ""
echo -e "\nChoose an I/O scheduler:"
echo "1. kyber - A scheduler designed for low-latency and mixed workloads."
echo "2. none  - Allows the kernel to use the underlying storage device's native scheduler."
echo "3. mq    - Multi-Queue framework that can work well with SSDs."
echo "4. noop  - A simple scheduler that performs minimal I/O scheduling."

read -p "Enter your choice (1/2/3/4): " IO_SCHEDULER_CHOICE

# Determine the I/O scheduler based on user's choice
case $IO_SCHEDULER_CHOICE in
1) SELECTED_IO_SCHEDULER="kyber" ;;
2) SELECTED_IO_SCHEDULER="none" ;;
3) SELECTED_IO_SCHEDULER="mq-deadline" ;;
4) SELECTED_IO_SCHEDULER="noop" ;;
*)
	echo "Invalid choice. Exiting."
	exit 1
	;;
esac

# Set the chosen I/O scheduler
set_io_scheduler "$DEVICE_PATH" "$SELECTED_IO_SCHEDULER"

echo "I/O scheduler configurations has been updated."
echo ""
# none [mq-deadline] kyber bfq
# Super tweak I/O scheduler
#echo -e "\n${BLUE}Configuring I/O Scheduler to: ${NC}\n"
#echo "mq-deadline" | sudo tee /sys/block/sda/queue/scheduler
#printf "\n${YELLOW}I/O Scheduler has been set to ==>  ${NC}"
#cat /sys/block/sda/queue/scheduler

# Check your cpu schedule goveners
for cpu in $(seq 0 $(($(nproc) - 1))); do
	echo "CPU $cpu: $(cat /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_available_governors)"
done

echo ""
gum spin --spinner dot --title "These are your available CPU scheduling goveners..." -- sleep 2.5

echo ""

# Get available TCP congestion control algorithms
available_algorithms=$(cat /proc/sys/net/ipv4/tcp_available_congestion_control)

# Display available algorithms
echo -e "${YELLOW}Available TCP Congestion Control Algorithms for your current KERNEL:${NC}"
printf "${BLUE}%s${NC}\n" "$available_algorithms"

# Explain each algorithm with colors
echo -e "\n${YELLOW}Explanations:${NC}"
for algorithm in $available_algorithms; do
	printf "${GREEN}%-9s:${NC} " "$algorithm"
	case $algorithm in
	cubic)
		echo -e "${BLUE}CUBIC is a widely used congestion control algorithm designed for high-speed networks.${NC}"
		;;
	reno)
		echo -e "${BLUE}Reno is a classic congestion control algorithm and a variant of Tahoe.${NC}"
		;;
	bic)
		echo -e "${BLUE}BIC (Binary Increase Control) is a variant of TCP congestion control.${NC}"
		;;
	htcp)
		echo -e "${BLUE}HTCP (H-TCP) is a delay-based congestion control algorithm.${NC}"
		;;
	vegas)
		echo -e "${BLUE}Vegas is a delay-based congestion control algorithm designed to avoid queue buildup.${NC}"
		;;
	westwood)
		echo -e "${BLUE}Westwood is a TCP congestion control algorithm optimized for wireless networks.${NC}"
		;;
	bbr)
		echo -e "${BLUE}BBR (Bottleneck Bandwidth and Round-trip propagation time) is a congestion control algorithm developed by Google, focusing on bandwidth and delay estimation.${NC}"
		;;
	bbr2 | bbrv2)
		echo -e "${BLUE}BBRv2 is an enhanced version of BBR with improvements for better performance in various network conditions.${NC}"
		;;
	bbr3 | bbrv3)
		echo -e "${BLUE}BBRv3 is another iteration of the BBR algorithm with further enhancements and optimizations.${NC}"
		;;
	*)
		echo -e "${BLUE}Description not available.${NC}"
		;;
	esac
done
echo""
echo -e "${BLUE}Your current TCP congestion setting is:${NC}"
echo""
sysctl net.ipv4.tcp_congestion_control

echo ""
read -p "Press Enter to continus...."
gum spin --spinner dot --title "Stand-by..." -- sleep 1

# Turn on NumLock in SDDM login screen
echo "$(cat /etc/sddm.conf | sed -E s/'^\#?Numlock\=.*$'/'Numlock=on'/)" | sudo tee /etc/sddm.conf && sudo systemctl daemon-reload

# Check if the SDDM configuration file exists
#if [ ! -f "$SDDM_CONF" ]; then
# If not, create the file and echo the configuration content into it
#	echo -e "$CONFIG_CONTENT" | sudo tee "$SDDM_CONF" >/dev/null
#else
# If the file exists, append the configuration content
#	echo -e "$CONFIG_CONTENT" | sudo tee -a "$SDDM_CONF" >/dev/null
#fi

echo""
# for_exit "figlet"
figlet Ultramarine/Fedora Tweaks
gum spin --spinner dot --title "Stand-by..." -- sleep 2

# Function to display messages
display_message() {
	clear
	echo -e "\n                  Brian's online Ultramarine/Fedora updater\n"
	echo -e "\e[34m|--------------------\e[33m Currently configuring:\e[34m-------------------|"
	echo -e "|${YELLOW}==>${NC}  $1"
	echo -e "\e[34m|--------------------------------------------------------------|\e[0m"
	echo ""
	gum spin --spinner dot --title "Stand-by..." -- sleep 1
}

# Function to check and display errors
check_error() {
	if [ $? -ne 0 ]; then
		display_message "[${RED}✘${NC}] Error occurred !!"
		# Print the error details
		echo "Error details: $1"
		gum spin --spinner dot --title "Stand-by..." -- sleep 8
	fi
}





# Change Hostname
change_hotname() {
	current_hostname=$(hostname)

	display_message "Changing HOSTNAME: $current_hostname"

	# Get the new hostname from the user
	read -p "Enter the new hostname: " new_hostname

	# Change the system hostname
	sudo hostnamectl set-hostname "$new_hostname"

	# Update /etc/hosts file
	sudo sed -i "s/127.0.0.1.*localhost/127.0.0.1 $new_hostname localhost/" /etc/hosts

	# Display the new hostname
	echo "Hostname changed to: $new_hostname"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}



# Function to update the system
update_system() {
	display_message "Updating the system...."

	sudo dnf update -y

	# Install necessary dependencies if not already installed
	display_message "Checking for extra dependencies..."
	sudo dnf install -y rpmconf

	# Install DNF plugins core (if not already installed)
	sudo dnf install -y dnf-plugins-core

	# Install required dependencies
	# sudo dnf install -y epel-release
	sudo dnf install -y dnf-plugins-core

	# Update the package manager
	sudo dnf makecache -y
	sudo dnf upgrade -y --refresh

	check_error

	display_message "System updated successfully."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

# Function to install firmware updates with a countdown on error
install_firmware() {
	display_message "Installing firmware updates..."

	# Attempt to install firmware updates
	sudo fwupdmgr get-devices
	sudo fwupdmgr refresh --force
	sudo fwupdmgr get-updates
	sudo fwupdmgr update

	# Check for errors during firmware updates
	if [ $? -ne 0 ]; then
		display_message "Error occurred during firmware updates.."

		# Countdown for 10 seconds on error
		for i in {4..1}; do
			echo -ne "Continuing in $i seconds... \r"
			sleep 1
		done
		echo -e "Continuing with the script."
	else
		display_message "Firmware updated successfully."
	fi
}

# Function to install GPU drivers with a reboot option on a 3 min timer, Nvidia && AMD
install_gpu_drivers() {
	display_message "[${GREEN}✔${NC}]  Checking GPU and installing drivers..."
	sudo dnf install -y mesa-vdpau-drivers zenity

	# Check for AMD GPU
	if lspci | grep -i amd &>/dev/null; then
		display_message "AMD GPU detected. Installing AMD drivers..."

		sudo dnf install -y mesa-dri-drivers
		sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
		sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

		check_error "Failed to install AMD drivers."
		display_message "AMD drivers installed successfully."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi

	glxinfo | egrep "OpenGL vendor|OpenGL renderer"

	REBOOT_REQUIRED="yes"
	if [ "$REBOOT_REQUIRED" == "yes" ]; then

		zenity --question \
			--title="Reboot Required." \
			--width=600 \
			--text="$(printf "The system requires a reboot before changes can take effect. Would you like to reboot now?\n\n")"

		if [ $? = 0 ]; then
			shutdown -r now &>>/tmp/nvcheck.log || {
				zenity --error --text="Failed to issue reboot:\n\n $(cat /tmp/nvcheck.log)\n\n Please reboot the system manually."
				exit 1
			}
		else
			exit 0
		fi

	fi

	# Prompt user for reboot or continue
	read -p "Do you want to reboot now? (y/n): " choice
	case "$choice" in
	y | Y)
		# Reboot the system after 3 minutes
		display_message "Rebooting in 3 minutes. Press Ctrl+C to cancel."
		sleep 180
		sudo reboot
		;;
	n | N)
		display_message "Reboot skipped. Continuing with the script."
		;;
	*)
		display_message "Invalid choice. Continuing with the script."
		;;
	esac
}

# Function to optimize battery life on lappy, in theory.... LOL
optimize_battery() {
	display_message "Optimizing battery life..."

	# Check if the battery exists
	if [ -e "/sys/class/power_supply/BAT0" ]; then
		# Install TLP and mask power-profiles-daemon
		sudo dnf install -y tlp tlp-rdw
		sudo systemctl mask power-profiles-daemon

		# Install powertop and apply auto-tune
		sudo dnf install -y powertop
		sudo powertop --auto-tune

		display_message "Battery optimization completed."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	else
		display_message "No battery found. Skipping battery optimization."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi
}



# Function to install H/W Video Acceleration for AMD or Intel chipset
install_hw_video_acceleration_amd_or_intel() {
	display_message "Checking for AMD chipset..."

	# Check for AMD chipset
	if lspci | grep -i amd &>/dev/null; then
		display_message "[${GREEN}✔${NC}]  AMD chipset detected. Installing AMD video acceleration..."

		sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
		sudo dnf swap -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
		sudo dnf config-manager --set-enabled fedora-cisco-openh264
		sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264

		display_message "[${GREEN}✔${NC}]  H/W Video Acceleration for AMD chipset installed successfully."
	else
		display_message "[${RED}✘${NC}]  No AMD chipset found. Pausing for user confirmation..."

		# Pause for user confirmation
		read -p "Press Enter to check for Intel chipset..."

		display_message "Checking for Intel chipset..."

		# Check for Intel chipset
		if lspci | grep -i intel &>/dev/null; then
			display_message "Intel chipset detected. Installing Intel video acceleration..."

			sudo dnf install -y intel-media-driver

			# Install video acceleration packages
			sudo dnf install libva libva-utils xorg-x11-drv-intel -y

			display_message "[${GREEN}✔${NC}]  H/W Video Acceleration for Intel chipset installed successfully."
			gum spin --spinner dot --title "Stand-by..." -- sleep 2
		else
			display_message "No Intel chipset found. Skipping H/W Video Acceleration installation."
			gum spin --spinner dot --title "Stand-by..." -- sleep 2
		fi
	fi
}

# Function to clean up old or unused Flatpak packages
cleanup_flatpak_cruft() {
	display_message "Cleaning up old or unused Flatpak packages..."

	# Remove uninstalled runtimes
	flatpak uninstall --unused -y

	# Remove uninstalled applications
	flatpak uninstall --unused -y --delete-data

	display_message "Flatpak cleanup completed."
}

# Function to update Flatpak
update_flatpak() {
	display_message "[${GREEN}✔${NC}]  Updating Flatpak..."

	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# flatpak update
	flatpak update -y

	display_message "[${GREEN}✔${NC}]  Executing Tolga's Flatpak's..."

	sudo flatpak override --env=GTK_MODULES=colorreload-gtk-module org.mozilla.firefox

	# Execute the Flatpak Apps installation script from the given URL
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/FlatPakApps.sh)"

	display_message "[${GREEN}✔${NC}]  Flatpak updated successfully."

	# Call the cleanup function
	cleanup_flatpak_cruft
}

# Function to set UTC Time for dual boot issues, THanks Tolga Erok
set_utc_time() {
	display_message "Setting UTC Time..."

	sudo timedatectl set-local-rtc '0'

	display_message "[${GREEN}✔${NC}]  UTC Time set successfully."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

# Function to disable mitigations, old fedora hack and used on nixos also, thanks chris titus!
disable_mitigations() {
	display_message "Disabling Mitigations..."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2

	# Inform the user about the security risks
	display_message "[${RED}✘${NC}] Note: Disabling mitigations can present security risks. Only proceed if you understand the implications."

	# Ask for user confirmation
	read -p "Do you want to proceed? (y/n): " choice
	case "$choice" in
	y | Y)
		# Disable mitigations
		sudo grubby --update-kernel=ALL --args="mitigations=off"

		# Custon Tweak for tolga
		# sudo grubby --update-kernel=ALL --args="mitigations=off threadirqs swap=0 nowatchdog=1 transparent_hugepage=never intel_idle.max_cstate=0 processor.max_cstate=0"

		display_message "[${GREEN}✔${NC}]  Mitigations disabled successfully and multi-threading enabled."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
		;;
	n | N)
		display_message "[${RED}✘${NC}] Mitigations not disabled. Exiting."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
		;;
	*)
		display_message "[${RED}✘${NC}] Invalid choice. Exiting."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
		;;
	esac
}

# Function to enable Modern Standby. Can result in better battery life when your laptop goes to sleep.... in theory LOL
enable_modern_standby() {
	display_message "Enabling Modern Standby..."

	# Enable Modern Standby
	sudo grubby --update-kernel=ALL --args="mem_sleep_default=s2idle"

	display_message "Modern Standby enabled successfully."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}


# Function to disable NetworkManager-wait-online.service
disable_network_manager_wait_online() {
	display_message "[${GREEN}✔${NC}]  Disabling NetworkManager-wait-online.service..."

	# Disable NetworkManager-wait-online.service
	sudo systemctl disable NetworkManager-wait-online.service

	display_message "NetworkManager-wait-online.service disabled successfully."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

# Function to use themes in Flatpaks, learned from nixos and trials and errors...
use_flatpak_themes() {
	display_message "Using themes in Flatpaks..."

	# Override themes for Flatpaks
	sudo flatpak override --filesystem="$HOME/.themes"

	# Select your theme from inside of ./themes
	sudo flatpak override --env=GTK_THEME=Nordic

	display_message "Themes applied to Flatpaks successfully."
}

# Function to check if mitigations=off is present in GRUB configuration
check_mitigations_grub() {
	display_message "[${GREEN}✔${NC}]  Checking if mitigations=off is present in GRUB configuration..."

	# Read the GRUB configuration
	grub_config=$(cat /etc/default/grub)

	# Check if mitigations=off is present
	# for tolga's system
	# if echo "$grub_config" | grep -q "mitigations=off threadirqs swap=0 nowatchdog=1 transparent_hugepage=never intel_idle.max_cstate=0 processor.max_cstate=0"; then

	if echo "$grub_config" | grep -q "mitigations=off"; then

		display_message "[${GREEN}✔${NC}]  Mitigations are currently disabled in GRUB configuration: ==>  ( Success! )"
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	else
		display_message "[${RED}✘${NC}] Warning: Mitigations are not currently disabled in GRUB configuration."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi
}

####

	## Make a backup of the original sysctl.conf file
	display_message "[${GREEN}✔${NC}]  Tweaking network settings"

	cp $SYS_PATH /etc/sysctl.conf.bak

	echo
	yellow_msg 'Default sysctl.conf file Saved. Directory: /etc/sysctl.conf.bak'
	echo
	gum spin --spinner dot --title "Stand-by..." -- sleep 1

	echo
	yellow_msg 'Optimizing the Network...'
	echo
	gum spin --spinner dot --title "tweaking network" -- sleep 3

	sed -i -e '/fs.file-max/d' \
		-e '/net.core.default_qdisc/d' \
		-e '/net.core.netdev_max_backlog/d' \
		-e '/net.core.optmem_max/d' \
		-e '/net.core.somaxconn/d' \
		-e '/net.core.rmem_max/d' \
		-e '/net.core.wmem_max/d' \
		-e '/net.core.rmem_default/d' \
		-e '/net.core.wmem_default/d' \
		-e '/net.ipv4.tcp_rmem/d' \
		-e '/net.ipv4.tcp_wmem/d' \
		-e '/net.ipv4.tcp_congestion_control/d' \
		-e '/net.ipv4.tcp_fastopen/d' \
		-e '/net.ipv4.tcp_fin_timeout/d' \
		-e '/net.ipv4.tcp_keepalive_time/d' \
		-e '/net.ipv4.tcp_keepalive_probes/d' \
		-e '/net.ipv4.tcp_keepalive_intvl/d' \
		-e '/net.ipv4.tcp_max_orphans/d' \
		-e '/net.ipv4.tcp_max_syn_backlog/d' \
		-e '/net.ipv4.tcp_max_tw_buckets/d' \
		-e '/net.ipv4.tcp_mem/d' \
		-e '/net.ipv4.tcp_mtu_probing/d' \
		-e '/net.ipv4.tcp_notsent_lowat/d' \
		-e '/net.ipv4.tcp_retries2/d' \
		-e '/net.ipv4.tcp_sack/d' \
		-e '/net.ipv4.tcp_dsack/d' \
		-e '/net.ipv4.tcp_slow_start_after_idle/d' \
		-e '/net.ipv4.tcp_window_scaling/d' \
		-e '/net.ipv4.tcp_ecn/d' \
		-e '/net.ipv4.ip_forward/d' \
		-e '/net.ipv4.udp_mem/d' \
		-e '/net.ipv6.conf.all.disable_ipv6/d' \
		-e '/net.ipv6.conf.all.forwarding/d' \
		-e '/net.ipv6.conf.default.disable_ipv6/d' \
		-e '/net.unix.max_dgram_qlen/d' \
		-e '/vm.min_free_kbytes/d' \
		-e '/vm.swappiness/d' \
		-e '/vm.vfs_cache_pressure/d' \
		"$SYS_PATH"

	display_message "[${GREEN}✔${NC}]  Previous settings deleted"
	gum spin --spinner dot --title "Re-accessing, stanby" -- sleep 2

	## Add new parameteres. Read More: https://github.com/hawshemi/Linux-Optimizer/blob/main/files/sysctl.conf

	cat <<EOF >>"$SYS_PATH"
# System Reload Command
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Command to reload system configurations:
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# alias tolga-sysctl-reload="sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system && sysctl -p"

# About These Settings
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# These configurations aim to optimize various aspects of the Linux system, including network performance, file systems, and kernel behavior. The tweaks are inspired by configurations from RHEL,
# Fedora, Solus, Mint, and Windows Server. Adjustments have been made based on personal experimentation and preferences.
# Keep in mind that before applying these tweaks, it's recommended to test in a controlled environment and monitor system behavior.
#
# Tolga Erok

# Linux System Optimization
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Network
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#-net.ipv4.conf.all.rp_filter = 0                          # Disable source route verification for all interfaces
#-vm.unprivileged_userfaultfd = 1                          # Enable unprivileged userfaultfd
fs.aio-max-nr = 1048576                                   # Defines the maximum number of asynchronous I/O requests that can be in progress at a given time.
fs.file-max = 67108864                                    # Maximum number of file handles the kernel can allocate. Default: 67108864
fs.inotify.max_user_watches = 524288                      # Sets the maximum number of file system watches, enhancing file system monitoring capabilities. Default: 8192, Tweaked: 524288
fs.suid_dumpable=2                                        # Set SUID_DUMPABLE flag. 0 means not core dump, 1 means core dump, and 2 means core dump with setuid
kernel.core_pattern=|/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %h
kernel.core_uses_pid = 1                                  # Append the PID to the core filename
kernel.nmi_watchdog = 0                                   # Disable NMI watchdog
kernel.panic = 5                                          # Reboot after 5 seconds on kernel panic. Default: 0
kernel.pid_max = 4194304                                  # Allows a large number of processes and threads to be managed. Default: 32768, Tweaked: 4194304
kernel.pty.max = 24000                                    # Maximum number of pseudo-terminals (PTYs) in the system
kernel.sched_autogroup_enabled = 0                        # Disable automatic task grouping for better server performance
kernel.sysrq = 1                                          # Enable SysRQ for rebooting the machine properly if it freezes. [Source](https://oglo.dev/tutorials/sysrq/index.html)
kernel.unprivileged_bpf_disabled = 1                      # Disable unprivileged BPF
net.core.default_qdisc = fq_codel
net.core.netdev_max_backlog = 32768                       # Maximum length of the input queue of a network device
net.core.optmem_max = 65536                               # Maximum ancillary buffer size allowed per socket
net.core.rmem_default = 1048576                           # Default socket receive buffer size
net.core.rmem_max = 16777216                              # Maximum socket receive buffer size
net.core.somaxconn = 65536                                # Maximum listen queue backlog
net.core.wmem_default = 1048576                           # Default socket send buffer size
net.core.wmem_max = 16777216                              # Maximum socket send buffer size

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# IPv4 Network Configuration
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

net.ipv4.conf.*.promote_secondaries = 1                   # Promote secondary addresses when the primary address is removed
net.ipv4.conf.*.rp_filter = 2                             # Enable source route verification
net.ipv4.conf.all.secure_redirects = 0                    # Disable acceptance of secure ICMP redirected packets
net.ipv4.conf.all.send_redirects = 0                      # Disable sending of all IPv4 ICMP redirected packets
net.ipv4.conf.default.accept_redirects = 0                # Disable acceptance of all ICMP redirected packets (default)
net.ipv4.conf.default.promote_secondaries = 1             # Promote secondary addresses when the primary address is removed
net.ipv4.conf.default.rp_filter = 2                       # Enable source route verification
net.ipv4.conf.default.secure_redirects = 0                # Disable acceptance of secure ICMP redirected packets (default)
net.ipv4.conf.default.send_redirects = 0                  # Disable sending of all IPv4 ICMP redirected packets (default)
net.ipv4.ip_forward = 1                                   # Enable IP forwarding
net.ipv4.tcp_congestion_control = westwood
net.ipv4.tcp_dsack = 1                                    # Enable Delayed SACK
net.ipv4.tcp_ecn = 1                                      # Enable Explicit Congestion Notification (ECN)
net.ipv4.tcp_fastopen = 3                                 # Enable TCP Fast Open with a queue of 3
net.ipv4.tcp_fin_timeout = 25                             # Time to hold socket in FIN-WAIT-2 state (seconds)
net.ipv4.tcp_keepalive_intvl = 30                         # Time between individual TCP keepalive probes (seconds)
net.ipv4.tcp_keepalive_probes = 5                         # Number of TCP keepalive probes
net.ipv4.tcp_keepalive_time = 300                         # Time before sending TCP keepalive probes (seconds)
net.ipv4.tcp_max_orphans = 819200                         # Maximum number of TCP sockets not attached to any user file handle
net.ipv4.tcp_max_syn_backlog = 20480                      # Maximum length of the listen queue for accepting new TCP connections
net.ipv4.tcp_max_tw_buckets = 1440000                     # Maximum number of TIME-WAIT sockets
net.ipv4.tcp_mem = 65536 1048576 16777216                 # TCP memory allocation limits
net.ipv4.tcp_mtu_probing = 1                              # Enable Path MTU Discovery
net.ipv4.tcp_notsent_lowat = 16384                        # Minimum amount of data in the send queue below which TCP will send more data
net.ipv4.tcp_retries2 = 8                                 # Number of times TCP retransmits unacknowledged data segments for the second SYN on a connection initiation
net.ipv4.tcp_rmem = 8192 1048576 16777216                 # TCP read memory allocation for network sockets
net.ipv4.tcp_sack = 1                                     # Enable Selective Acknowledgment (SACK)
net.ipv4.tcp_slow_start_after_idle = 0                    # Disable TCP slow start after idle
net.ipv4.tcp_window_scaling = 1                           # Enable TCP window scaling
net.ipv4.tcp_wmem = 8192 1048576 16777216                 # TCP write memory allocation for network sockets
net.ipv4.udp_mem = 65536 1048576 16777216                 # UDP memory allocation limits

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# IPv6 Network Configuration
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

net.ipv6.conf.all.accept_redirects = 0                    # Disable acceptance of all ICMP redirected packets for IPv6
net.ipv6.conf.all.disable_ipv6 = 0                        # Enable IPv6
net.ipv6.conf.all.forwarding = 1                          # Enable IPv6 packet forwarding
net.ipv6.conf.default.accept_redirects = 0                # Disable acceptance of all ICMP redirected packets for IPv6 (default)
net.ipv6.conf.default.disable_ipv6 = 0                    # Enable IPv6

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# UNIX Domain Socket
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

net.unix.max_dgram_qlen = 50                              # Maximum length of the UNIX domain socket datagram queue

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Virtual Memory Management
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

vm.dirty_background_bytes = 474217728                     # Set dirty background bytes for optimized performance (adjusted for SSD).
vm.dirty_background_ratio = 5                             # Percentage of system memory at which background writeback starts
vm.dirty_bytes = 742653184                                # Set dirty bytes for optimized performance (adjusted for SSD).
vm.dirty_expire_centisecs = 3000                          # Set the time at which dirty data is old enough to be eligible for writeout (6000 centiseconds). Adjusted for SSD.
vm.dirty_ratio = 80                                       # Set the ratio of dirty memory at which a process is forced to write out dirty data (10%). Adjusted for SSD.
vm.dirty_writeback_centisecs = 300                        # Set the interval between two consecutive background writeback passes (500 centiseconds).
vm.extfrag_threshold = 100                                # Fragmentation threshold for the kernel
vm.max_map_count=2147483642                               # Define the maximum number of memory map areas a process may have
vm.min_free_kbytes = 65536                                # Minimum free kilobytes
vm.mmap_min_addr = 65536                                  # Minimum address allowed for a user-space mmap
vm.page-cluster = 0                                       # Disable page clustering for filesystems
vm.swappiness = 10                                        # Swappiness parameter (tendency to swap out unused pages)
vm.vfs_cache_pressure = 50                                # Controls the tendency of the kernel to reclaim the memory used for caching of directory and inode objects
fs.file-max = 67108864                                    # Maximum number of file handles the kernel can allocate (Default: 67108864)
EOF

	# To Do For NVME ssd
	#block.sd*/queue/nr_requests=4096
	#block.sd*/queue/scheduler=bfq
	#block.sd*/queue/nr_requests=4096
	#block.sd*/queue/read_ahead_kb=1024
	#block.sd*/queue/add_random=1
	#block.nvme*/queue/scheduler=mq-deadline
	#block.nvme*/queue/scheduler=bfq
	#3block.nvme*/queue/iosched/low_latency=0
	#block.nvme*/queue/iosched/low_latency=1
	#block.nvme*/queue/nr_requests=2048
	#block.nvme*/queue/read_ahead_kb=1024
	#block.nvme*/queue/add_random=1
	#kernel.nmi_watchdog=0
	#block.{sd,mmc,nvme,0}*/queue/iosched/slice_idle=0

	display_message "[${GREEN}✔${NC}]  Adding New network settings"

	# Apply sysctl changes
	sudo udevadm control --reload-rules
	sudo udevadm trigger
	sudo sysctl --system
	sudo sysctl -p

	sudo systemctl restart systemd-sysctl
	echo ""
	gum spin --spinner dot --title "Restarting systemd custom settings.." -- sleep 4

	echo
	green_msg 'Network is Optimized.'
	echo
	gum spin --spinner dot --title "Starting SSH..." -- sleep 3

	# Start and enable SSH
	sudo systemctl start sshd
	sudo systemctl enable sshd
	display_message "[${GREEN}✔${NC}]  Checking SSh port"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
	check_port22
	# sudo systemctl status sshd

	display_message "[${GREEN}✔${NC}]  Setup Web Service Discovery host daemon"

	echo ""
	echo "wsdd implements a Web Service Discovery host daemon. This enables (Samba) hosts, like your local NAS device, to be found by Web Service Discovery Clients like Windows."
	echo "It also implements the client side of the discovery protocol which allows to search for Windows machines and other devices implementing WSD. This mode of operation is called discovery mode."
	echo""

	gum spin --spinner dot --title " Standby, traffic for the following ports, directions and addresses must be allowed" -- sleep 2

	sudo firewall-cmd --add-rich-rule='rule family="ipv4" source address="239.255.255.250" port protocol="udp" port="3702" accept'
	sudo firewall-cmd --add-rich-rule='rule family="ipv6" source address="ff02::c" port protocol="udp" port="3702" accept'
	sudo firewall-cmd --add-rich-rule='rule family="ipv4" port protocol="udp" port="3702" accept'
	sudo firewall-cmd --add-rich-rule='rule family="ipv6" port protocol="udp" port="3702" accept'
	sudo firewall-cmd --add-rich-rule='rule family="ipv4" port protocol="tcp" port="5357" accept'
	sudo firewall-cmd --add-rich-rule='rule family="ipv6" port protocol="tcp" port="5357" accept'

	# Define the path to the wsdd service file
	SERVICE_FILE="/usr/lib/systemd/system/wsdd.service"

	# Define the path to the old sysconfig file
	OLD_SYSCONFIG_FILE="/etc/default/wsdd"

	# Define the path to the new sysconfig file
	NEW_SYSCONFIG_FILE="/etc/sysconfig/wsdd"

	# Check if EnvironmentFile line with old path exists in the service file
	if grep -q "EnvironmentFile=$OLD_SYSCONFIG_FILE" "$SERVICE_FILE"; then
		# Comment out the old EnvironmentFile line
		sudo sed -i "s|EnvironmentFile=$OLD_SYSCONFIG_FILE|#&|" "$SERVICE_FILE"

		# Add the new EnvironmentFile line directly under the commented old line
		sudo sed -i "\|#EnvironmentFile=$OLD_SYSCONFIG_FILE|a EnvironmentFile=$NEW_SYSCONFIG_FILE" "$SERVICE_FILE"
		gum spin --spinner dot --title " Standby, editind WSDD config" -- sleep 2

		# Reload systemd to apply changes
		sudo systemctl daemon-reload

		# Restart the wsdd service

		gum spin --spinner dot --title " Standby, restarting , reloading and getting wsdd status" -- sleep 2
		sudo systemctl enable wsdd.service
		sudo systemctl restart wsdd.service
		display_message "[${GREEN}✔${NC}]  WSDD setup complete"
		# systemctl status wsdd.service

		sleep 1

		echo "EnvironmentFile updated to $NEW_SYSCONFIG_FILE and service restarted."
		sleep 2
	else
		# Check if EnvironmentFile line with new path exists
		if grep -q "EnvironmentFile=$NEW_SYSCONFIG_FILE" "$SERVICE_FILE"; then
			echo "No changes needed. EnvironmentFile is already updated."
		else
			# Add the new EnvironmentFile line at the end of the [Service] section
			echo -e "\nEnvironmentFile=$NEW_SYSCONFIG_FILE" | sudo tee -a "$SERVICE_FILE" >/dev/null
			gum spin --spinner dot --title " Standby, editind WSDD config" -- sleep 2

			# Reload systemd to apply changes
			sudo systemctl daemon-reload

			# Restart the wsdd service
			gum spin --spinner dot --title " Standby, restarting , reloading and getting wsdd status" -- sleep 2
			sudo systemctl enable wsdd.service
			sudo systemctl restart wsdd.service
			display_message "[${GREEN}✔${NC}]  WSDD setup complete"
			# systemctl status wsdd.service

			sleep 1

			echo "EnvironmentFile added with path $NEW_SYSCONFIG_FILE and service restarted."
			sleep 2
		fi
	fi

	gum spin --spinner dot --title "Standby.." -- sleep 1

	display_message "[${GREEN}✔${NC}]  Setup KDE Wallet"
	gum spin --spinner dot --title "Standby.." -- sleep 1
	# Install Plasma related packages
	sudo dnf install -y \
		ksshaskpass

	mkdir -p ${HOME}/.config/autostart/
	mkdir -p ${HOME}/.config/environment.d/

	# Use the KDE Wallet to store ssh key passphrases
	# https://wiki.archlinux.org/title/KDE_Wallet#Using_the_KDE_Wallet_to_store_ssh_key_passphrases
	tee ${HOME}/.config/autostart/ssh-add.desktop <<EOF
[Desktop Entry]
Exec=ssh-add -q
Name=ssh-add
Type=Application
EOF

	tee ${HOME}/.config/environment.d/ssh_askpass.conf <<EOF
SSH_ASKPASS='/usr/bin/ksshaskpass'
GIT_ASKPASS=ksshaskpass
SSH_ASKPASS=ksshaskpass
SSH_ASKPASS_REQUIRE=prefer
EOF

	display_message "[${GREEN}✔${NC}]  Install vitualization group and set permissions"
	gum spin --spinner dot --title "Standby.." -- sleep 1
	# Install virtualization group
	sudo dnf install -y @virtualization

	# Enable libvirtd service
	sudo systemctl enable libvirtd

	# Add user to libvirt group
	sudo usermod -a -G libvirt ${USER}

	# Start earlyloom services
	display_message "[${GREEN}✔${NC}]  Starting earlyloom services"
	sudo systemctl start earlyoom
	sudo systemctl enable --now earlyoom
	echo ""
	gum spin --spinner dot --title "Restarting Earlyloom.." -- sleep 2.5
	display_message "[${GREEN}✔${NC}]  Checking earlyloom status service"

	# Check EarlyOOM status
	earlyoom_status=$(systemctl status earlyoom | cat)

	# Check if EarlyOOM is active and enabled
	if is_service_active earlyoom; then
		active_status="Active"
	else
		active_status="Inactive"
	fi

	if is_service_enabled earlyoom; then
		enabled_status=$(print_yellow "Enabled")
	else
		enabled_status="Disabled"
	fi

	# Get memory information
	mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
	swap_total=$(grep SwapTotal /proc/meminfo | awk '{print $2}')

	# Display information
	echo -e "EarlyOOM Status: $active_status"
	echo -e "Service Enablement: $enabled_status"
	echo -e "Total Memory: $mem_total KB"
	echo -e "Total Swap: $swap_total KB\n\n"
	gum spin --spinner dot --title "Standby.." -- sleep 1
	sudo journalctl -u earlyoom | grep sending
	gum spin --spinner dot --title "Standby.." -- sleep 3

	# Install fedora preload
	display_message "[${GREEN}✔${NC}]  Install fedora preload"
	sudo dnf copr enable atim/preload -y && sudo dnf install preload -y
	display_message "[${GREEN}✔${NC}]  Enable fedora preload service"
	sudo systemctl enable --now preload.service
	gum spin --spinner dot --title "Standby.." -- sleep 1.5



	# Install OpenRGB.
	display_message "[${GREEN}✔${NC}]  Installing OpenRGB"
	sudo modprobe i2c-dev && sudo modprobe i2c-piix4 && sudo dnf install openrgb -y

	# Install Docker
	display_message "[${GREEN}✔${NC}]  Installing Docker..this takes awhile"
	echo ""
	gum spin --spinner dot --title "If this is the first time installing docker, it usually takes VERY long" -- sleep 2
	sudo dnf install docker -y

	# Install Btrfs
	display_message "[${GREEN}✔${NC}]  Installing btrfs assistant.."
	package_url="https://kojipkgs.fedoraproject.org//packages/btrfs-assistant/1.8/2.fc39/x86_64/btrfs-assistant-1.8-2.fc39.x86_64.rpm"
	package_name=$(echo "$package_url" | awk -F'/' '{print $NF}')

	# Check if the package is installed
	if rpm -q "$package_name" >/dev/null; then
		display_message "[${RED}✘${NC}] $package_name is already installed."
		gum spin --spinner dot --title "Standby.." -- sleep 1
	else
		# Package is not installed, so proceed with the installation
		display_message "[${GREEN}✔${NC}]  $package_name is not installed. Installing..."
		sudo dnf install -y "$package_url"
		if [ $? -eq 0 ]; then
			display_message "[${GREEN}✔${NC}]  $package_name has been successfully installed."
			gum spin --spinner dot --title "Standby.." -- sleep 1
		else
			display_message "[${RED}✘${NC}] Failed to install $package_name."
			gum spin --spinner dot --title "Standby.." -- sleep 1
		fi
	fi

	# Install google
	display_message "[${GREEN}✔${NC}]  Installing Google chrome"
	if command -v google-chrome &>/dev/null; then
		display_message "[${RED}✘${NC}] Google Chrome is already installed. Skipping installation."
		gum spin --spinner dot --title "Standby.." -- sleep 1
	else
		# Install Google Chrome
		display_message "[${GREEN}✔${NC}]  Installing Google Chrome browser..."
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
		sudo dnf install -y ./google-chrome-stable_current_x86_64.rpm
		rm -f google-chrome-stable_current_x86_64.rpm
	fi

	# Download and install TeamViewer
	display_message "[${GREEN}✔${NC}]  Downloading && install TeamViewer"
	teamviewer_url="https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm?utm_source=google&utm_medium=cpc&utm_campaign=au%7Cb%7Cpr%7C22%7Cjun%7Ctv-core-download-sn%7Cfree%7Ct0%7C0&utm_content=Download&utm_term=teamviewer+download"
	teamviewer_location="/tmp/teamviewer.x86_64.rpm"
	download_and_install "$teamviewer_url" "$teamviewer_location" "teamviewer"

	# Download and install Visual Studio Code
	display_message "[${GREEN}✔${NC}]  Downloading && install Vscode"
	vscode_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
	vscode_location="/tmp/vscode.rpm"
	download_and_install "$vscode_url" "$vscode_location" "code"

	# Install extra package
	display_message "[${GREEN}✔${NC}]  Installing Extra RPM packages"
	sudo dnf groupupdate -y sound-and-video
	sudo dnf group upgrade -y --with-optional Multimedia
	sudo dnf groupupdate -y sound-and-video --allowerasing --skip-broken
	sudo dnf groupupdate multimedia sound-and-video

	# Cleanup
	display_message "[${GREEN}✔${NC}]  Cleaning up downloaded /tmp folder"
	rm "$download_location"

	display_message "[${GREEN}✔${NC}]  Installing SAMBA and dependencies"

	# Install Samba and its dependencies
	sudo dnf install samba samba-client samba-common cifs-utils samba-usershares -y

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
	read -r -p "Create and configure custom samba folder located at /home/ultramarine
" -t 2 -n 1 -s

	sudo mkdir /home/ultramarine
	sudo chgrp samba /home/ultramarine
	sudo chmod 770 /home/ultramarine
	sudo restorecon -R /home/ultramarine

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

	# Set up SSH Server on Host
	display_message "[${GREEN}✔${NC}]  Setup SSH and start service.."
	sudo systemctl enable sshd && sudo systemctl start sshd

	# Start Samba manually
	sudo systemctl start smb nmb wsdd

	# Configure Samba to start automatically on each boot and immediately start the service
	sudo systemctl enable --now smb nmb wsdd

	# Check whether Samba is running
	sudo systemctl --no-pager status smb nmb wsdd

	# Restart wsdd and Samba
	sudo systemctl restart wsdd smb nmb

	# Enable and start the services
	sudo systemctl enable smb.service nmb.service wsdd.service
	sudo systemctl start smb.service nmb.service wsdd.service

	# Apply sysctl changes
	sudo udevadm control --reload-rules
	sudo udevadm trigger
	sudo sysctl --system
	sudo sysctl -p

	workgroup="WORKGROUP"

	# colors
	BRIGHT_BLUE='\033[1;34m'
	BRIGHT_GREEN='\033[1;32m'
	BRIGHT_YELLOW='\033[1;33m'
	NC='\033[0m' # No Color

	echo -e "${BRIGHT_BLUE}Querying NetBIOS names for:${NC} ${BRIGHT_GREEN}$workgroup${NC}"

	# Perform NetBIOS name lookup for the specified workgroup and variations of case
	for name in "$workgroup" "samba" "Samba" "SAMBA" "WORKGROUP" "workgroup"; do
		echo -e "${BRIGHT_YELLOW}NetBIOS Name:${NC} ${BRIGHT_GREEN}$name${NC}"
		nmblookup -S "$name"
		echo "----------------------------------------"
	done

	echo -e "${BRIGHT_BLUE}Script completed.${NC}"

	display_message "[${GREEN}✔${NC}]  Installation completed."
	gum spin --spinner dot --title "Standby.." -- sleep 3

	# Check for errors during installation
	if [ $? -eq 0 ]; then
		display_message "Apps installed successfully."
		gum spin --spinner dot --title "Standby.." -- sleep 2
	else
		display_message "[${RED}✘${NC}] Error: Unable to install Apps."
		gum spin --spinner dot --title "Standby.." -- sleep 2
	fi
}

cleanup_fedora() {
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

fix_chrome() {
	display_message "[${GREEN}✔${NC}]  Applying chrome HW accelerations issue for now"
	# Prompt user for reboot or continue
	read -p "Do you want to down grade mesa dlibs now? (y/n): " choice
	case "$choice" in
	y | Y)
		# Apply fix
		display_message "[${GREEN}✔${NC}]  Applied"
		sudo sudo dnf downgrade mesa-libGL
		sudo rm -rf ./config/google-chrome
		sudo rm -rf ./cache/google-chrome
		sudo chmod -R 770 ~/.cache/google-chrome
		sudo chmod -R 770 ~/.config/google-chrome

		sleep 2
		display_message "Bug @ https://bugzilla.redhat.com/show_bug.cgi?id=2193335"
		;;
	n | N)
		display_message "Fix skipped. Continuing with the script."
		;;
	*)
		display_message "[${RED}✘${NC}] Invalid choice. Continuing with the script."
		;;
	esac

	echo "If problems persist, copy and pate the following into chrome address bar and disable HW acceleration"
	echo ""
	echo "chrome://settings/?search=hardware+acceleration"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
	sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/execute-python-script.sh)"
}

display_XDG_session() {
	session=$XDG_SESSION_TYPE

	display_message "Current XDG session is [ $session ]"
	echo "Current XDG session is [ $session ]"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2

}

fix_grub() {
	# Check if GRUB_TIMEOUT_STYLE is present
	if ! grep -q '^GRUB_TIMEOUT_STYLE=menu' /etc/default/grub; then
		# Add GRUB_TIMEOUT_STYLE=menu if not present
		echo 'GRUB_TIMEOUT_STYLE=menu' | sudo tee -a /etc/default/grub >/dev/null
	fi

	# Check if UEFI is enabled
	uefi_enabled=$(test -d /sys/firmware/efi && echo "UEFI" || echo "BIOS/Legacy")

	# Display information about GRUB configuration
	display_message "[${GREEN}✔${NC}]  Current GRUB configuration:"
	echo "  - GRUB_TIMEOUT_STYLE: $(grep '^GRUB_TIMEOUT_STYLE' /etc/default/grub | cut -d '=' -f2)"
	echo "  - System firmware: $uefi_enabled"

	# Prompt user to proceed
	read -p "Do you want to proceed with updating GRUB? (yes/no): " choice
	case "$choice" in
	[Yy] | [Yy][Ee][Ss]) ;;
	*)
		echo "GRUB update aborted."
		return
		;;
	esac

	# Update GRUB configuration
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg
	sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

	echo "GRUB updated successfully."
	sleep 2
}

# Remove KDE Junk
kde_crap() {

	# Color codes
	RED='\e[1;31m'
	GREEN='\e[1;32m'
	YELLOW='\e[1;33m'
	NC='\e[0m' # No Color

	# List of KDE applications to check..
	apps=("akregator" "ksysguard" "kmag" "kmail"
		"kaddressbook" "konversation" "elisa-player"
		"kcolorchooser" "kmouth" "korganizer" "kmousetool" "kmahjongg"
		"kpat" "kmines" "dragonplayer" "kamoso"
		"kolourpaint" "krdc" "krfb" "kmail-account-wizard"
		"pim-data-exporter" "pim-sieve-editor" "elisa*" "kdeconnectd")

	display_message "Checking for KDE applications..."

	# Check if each application is installed
	found_apps=()
	for app in "${apps[@]}"; do
		if command -v "$app" &>/dev/null; then
			found_apps+=("$app")
		fi
	done

	# Prompt the user to uninstall found applications
	if [ ${#found_apps[@]} -gt 0 ]; then
		clear
		display_message "[${RED}✘${NC}] The following KDE applications are installed:"
		for app in "${found_apps[@]}"; do
			echo -e "  ${RED}[✘]${NC}  ${YELLOW}==>${NC}  $app"
		done

		echo ""
		read -p "Do you want to uninstall them? (y/n): " uninstall_choice
		if [ "$uninstall_choice" == "y" ]; then
			display_message "[${RED}✘${NC}] Uninstalling KDE applications..."

			# Build a string of package names
			packages_to_remove=$(
				IFS=" "
				echo "${found_apps[*]}"
			)

			sudo dnf remove $packages_to_remove

			sudo dnf remove kmail-account-wizard mbox-importer kdeconnect pim-data-exporter elisa*
			dnf clean all

			# Remove media players
			sudo dnf remove -y \
				dragon \
				elisa-player \
				kamoso

			# Remove akonadi
			# sudo dnf remove -y *akonadi*

			# Remove games
			sudo dnf remove -y \
				kmahjongg \
				kmines \
				kpat

			# Remove misc applications
			sudo dnf remove -y \
				dnfdragora \
				konversation \
				krdc \
				krfb \
				plasma-welcome

			read -p "Do you want to perform autoremove? (y/n): " autoremove_choice
			if [ "$autoremove_choice" == "y" ]; then
				sudo dnf remove kmail-account-wizard mbox-importer kdeconnect pim-data-exporter elisa*
				sudo dnf autoremove
				dnf clean all
			fi
			display_message "[${GREEN}✔${NC}]  Uninstallation completed."
		else
			display_message "[${RED}✘${NC}] No applications were uninstalled."
		fi
	else
		sudo dnf remove kmail-account-wizard mbox-importer kdeconnect pim-data-exporter elisa*
		sudo dnf autoremove
		dnf clean all
		display_message "[${GREEN}✔${NC}]  Congratulations, no KDE applications detected."
		sleep 1
	fi
}

# Function to start balance operation
start_balance() {
	display_message "[${GREEN}✔${NC}]  Balance operation started successfully."
	echo -e "\n ${YELLOW}==>${NC} This will take a very LONG time..."
	check_balance_status
	sudo btrfs balance start --full-balance / &
	check_balance_status
	display_message "[${GREEN}✔${NC}]  Balance operation running in background."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

# Function to check balance status
check_balance_status() {
	display_message "[${GREEN}✔${NC}]  Balance operation successfull"
	sudo btrfs balance status /
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

# Function to start scrub operation
start_scrub() {
	display_message "[${GREEN}✔${NC}]  Scrub operation started successfully."
	check_scrub_status
	sudo btrfs scrub start /
	check_scrub_status
	display_message "[${GREEN}✔${NC}]  Scrub operation running in background."
	gum spin --spinner dot --title "Stand-by..." -- sleep 4

}

# Function to check scrub status.
check_scrub_status() {
	display_message "[${GREEN}✔${NC}]  Scrub operation successfull"
	sudo btrfs scrub status /
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

# Function to display the main menu
btrfs_maint() {

	# Start balance operation
	start_balance

	# Display balance status
	echo -e "\n ${YELLOW}==>${NC} Checking balance status..."
	check_balance_status

	# Start scrub operation
	start_scrub

	# Display scrub status
	echo -e "\n ${YELLOW}==>${NC} Checking scrub status..."
	check_scrub_status

	# Check if both operations have completed
	if ! pgrep -f "sudo btrfs balance start" >/dev/null &&
		! pgrep -f "sudo btrfs scrub start" >/dev/null; then
		display_message "[${GREEN}✔${NC}]  Balance and scrub operations running in background."
		sleep 5
		break
	fi

	# Sleep for 10 seconds before checking again
	display_message "[${GREEN}✔${NC}]  Balance and scrub operations running in background."
	echo -e "\n ${YELLOW}==> ${NC} BTRFS balance and scrub will take a VERY LONG time ...\n"
	gum spin --spinner dot --title "Stand-by..." -- sleep 7

}

create-extra-dir() {
	display_message "[${GREEN}✔${NC}]  Create extra needed directories"

	# Check if username is provided, otherwise use default
	if [ -z "$user" ]; then
		user="$USER"
	fi

	# Directories to create
	directories=(
		"~/.config/autostart"
		"~/.config/environment.d"
		"~/.config/systemd/user"
		"~/.local/bin"
		"~/.local/share/applications"
		"~/.local/share/fonts"
		"~/.local/share/icons"
		"~/.local/share/themes"
		"~/.ssh"
		"~/.zshrc.d"
		"~/Applications"
		"~/src"
	)

	# Create directories using the specified username
	for dir in "${directories[@]}"; do
		dir_path=$(eval echo "$dir" | sed "s|~|/home/$user|")
		mkdir -p "$dir_path"
		gum spin --spinner dot --title "[✔]  Creating: $dir_path" -- sleep 1
		sleep 0.5
		chown "$user:$user" "$dir_path"
	done

	# Set SSH folder permissions
	chmod 700 "/home/$user/.ssh"

	display_message "[${GREEN}✔${NC}]  Extra hidden dirs created"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
}

speed-up-shutdown() {
	display_message "${YELLOW}[*]${NC} Configure shutdown of units and services to 10s .."
	sleep 1

	# Configure default timeout to stop system units
	sudo mkdir -p /etc/systemd/system.conf.d
	sudo tee /etc/systemd/system.conf.d/default-timeout.conf <<EOF
[Manager]
DefaultTimeoutStopSec=10s
EOF

	# Configure default timeout to stop user units
	sudo mkdir -p /etc/systemd/user.conf.d
	sudo tee /etc/systemd/user.conf.d/default-timeout.conf <<EOF
[Manager]
DefaultTimeoutStopSec=10s
EOF

	display_message "${GREEN}[✔]${NC} Shutdown speed configured"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2

}

check_internet_connection() {
	display_message "${YELLOW}[*]${NC} Checking Internet Connection .."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
	display_message "${GREEN}[✔]${NC} connecting to google.."

	if curl -s -m 10 https://www.google.com >/dev/null || curl -s -m 10 https://www.github.com >/dev/null; then
		display_message "${GREEN}[✔]${NC} Network connection is OK "
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	else
		display_message "${RED}[✘]${NC} Network connection is not available ${RED}[✘]${NC}"
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi

	echo ""

	echo -e "${YELLOW}[*]${NC} Executing menu ..."
	gum spin --spinner dot --title "Stand-by..." -- sleep 2
	clear
}

firewall() {
	# Define allowed TCP ports
	allowedTCPPorts=(
		21    # FTP
		53    # DNS
		80    # HTTP
		443   # HTTPS
		143   # IMAP
		389   # LDAP
		139   # Samba
		445   # Samba
		25    # SMTP
		22    # SSH
		5432  # PostgreSQL
		3306  # MySQL/MariaDB
		3307  # MySQL/MariaDB
		111   # NFS
		2049  # NFS
		2375  # Docker
		22000 # Syncthing
		9091  # Transmission
		60450 # Transmission
		80    # Gnomecast server
		8010  # Gnomecast server
		8888  # Gnomecast server
		5357  # wsdd: Samba
		1714  # Open KDE Connect
		1764  # Open KDE Connect
		8200  # Teamviewer
	)

	# Define allowed UDP ports
	allowedUDPPorts=(
		53    # DNS
		137   # NetBIOS Name Service
		138   # NetBIOS Datagram Service
		3702  # wsdd: Samba
		5353  # Device discovery
		21027 # Syncthing
		22000 # Syncthing
		8200  # Teamviewer
		1714  # Open KDE Connect
		1764  # Open KDE Connect
	)
	display_message "[${GREEN}✔${NC}] Setting up firewall ports (OLD NixOs settings)"
	gum spin --spinner dot --title "Stand-by..." -- sleep 2

	# Add allowed TCP ports
	for port in "${allowedTCPPorts[@]}"; do
		sudo firewall-cmd --permanent --add-port="$port/tcp"
		gum spin --spinner dot --title "Setting up TCPorts:  $port" -- sleep 0.5
	done

	# Add allowed UDP ports
	for port in "${allowedUDPPorts[@]}"; do
		sudo firewall-cmd --permanent --add-port="$port/udp"
		gum spin --spinner dot --title "Setting up UDPPorts:  $port" -- sleep 0.5
	done

	# Add extra command for NetBIOS name resolution traffic on UDP port 137
	display_message "[${GREEN}✔${NC}] Adding NetBIOS name resolution traffic on UDP port 137"
	gum spin --spinner dot --title "Add extra command for NetBIOS name resolution traffic on UDP port 137" -- sleep 1.5
	sudo iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns

	# Reload the firewall for changes to take effect
	sudo firewall-cmd --reload
	gum spin --spinner dot --title "Reloading firewall" -- sleep 0.5

	display_message "[${GREEN}✔${NC}] Firewall rules applied successfully."
	gum spin --spinner dot --title "Reloading MainMenu" -- sleep 1.5
}

zram() {
	display_message "[${GREEN}✔${NC}] Setting up ZRAM."

	# Step 1: Create and configure swap file
	#if [ "$(free -h | grep -c 'Swap')" -eq 0 ]; then
	sudo fallocate -l 4G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
	gum spin --spinner dot --title "Create and configure swap file in progress" -- sleep 1.5
	# fi

	# Step 2: Use echo and sed to update GRUB_CMDLINE_LINUX_DEFAULT
	display_message "[${GREEN}✔${NC}] Updating GRUB."
	echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash zswap.enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=50 zswap.zpool=z3fold"' | sudo tee -a /etc/default/grub >/dev/null
	sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash zswap.enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=50 zswap.zpool=z3fold"/' /etc/default/grub
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg
	sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

	gum spin --spinner dot --title "GRUB updated successfully. Initializing ( initramfs )" -- sleep 1
	echo ""
	echo lz4 | sudo tee -a /etc/initramfs-tools/modules >/dev/null
	echo lz4_compress | sudo tee -a /etc/initramfs-tools/modules >/dev/null
	echo z3fold | sudo tee -a /etc/initramfs-tools/modules >/dev/null
	sudo update-initramfs -u

	display_message "[${GREEN}✔${NC}] ZRAM setup complete"
	echo ""
	gum spin --spinner dot --title "REBOOT to enable" -- sleep 3
}

# Function to display the main menu.
display_main_menu() {
	clear
	echo -e "\n                  Brian's online Fedora updater\n"
	echo -e "\e[34m|----| \e[33m Main Menu \e[34m |---------------------------------------------------------------------------------------------------------------------|\e[0m"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------------------------------------------------------\e[0m"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------------------------------------------------------\e[0m"
	echo -e "\e[33m 3.\e[0m \e[32m Update the system                                            ( Create meta cache etc )\e[0m"
	echo -e "\e[33m 4.\e[0m \e[32m Install firmware updates                                     ( Not compatible with all systems )\e[0m"
	echo -e "\e[33m 5.\e[0m \e[32m Install AMD GPU drivers                                      ( Auto scan and install )\e[0m"
	echo -e "\e[33m 6.\e[0m \e[32m Optimize battery life\e[0m"
	echo -e "\e[33m 7.\e[0m \e[32m Install multimedia codecs\e[0m"
	echo -e "\e[33m 8.\e[0m \e[32m Install H/W Video Acceleration for AMD or Intel\e[0m"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------------------------------------------------------\e[0m"
	echo -e "\e[33m 10.\e[0m \e[32mSet UTC Time\e[0m"
	echo -e "\e[33m 11.\e[0m \e[32mDisable mitigations\e[0m"
	echo -e "\e[33m 12.\e[0m \e[32mEnable Modern Standby\e[0m"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------------------------------------------------------\e[0m"
	echo -e "\e[33m 9.\e[0m \e[32m Update Flatpak\e[0m"
	echo -e "\e[33m 9.\e[0m \e[32m Cleanup unused/removed Flatpak\e[0m"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------------------------------------------------------\e[0m"
	echo -e "\e[33m 16.\e[0m \e[32mChange hostname                                              ( Change current localname/pc name )\e[0m"
	echo -e "\e[33m 17.\e[0m \e[32mCheck mitigations=off in GRUB\e[0m"
	echo -e "\e[33m 18.\e[0m \e[32mInstall additional apps\e[0m"
	echo -e "\e[33m 19.\e[0m \e[32mCleanup Fedora\e[0m"
	echo -e "\e[33m 20.\e[0m \e[32mFix Chrome HW accelerations issue                            ( No guarantee )\e[0m"
	echo -e "\e[33m 21.\e[0m \e[32mDisplay XDG session\e[0m"
	echo -e "\e[33m 22.\e[0m \e[32mFix grub or rebuild grub                                     ( Checks and enables menu output to grub menu )\e[0m"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------------------------------------------------------\e[0m"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------------------------------------------------------\e[0m"
	echo -e "\e[33m 25.\e[0m \e[32mPerform BTRFS balance and scrub operation on / partition     ( !! WARNING, backup important data incase, 5 min operation )\e[0m"
	echo -e "\e[33m 26.\e[0m \e[32mCreate extra hidden dir in HOME                                "
	echo -e "\e[33m 27.\e[0m \e[32mModify systemd timeout settings to 10s                         "
	echo -e "\e[33m 28.\e[0m \e[32mSet-up TCP && UDP firewall settings                          ( Mimic my NixOS firewall settings ) "
	echo -e "\e[33m 29.\e[0m \e[32mSet-up ZRAM                                                  ( For systems with low RAM (<+ 8 GB) ) "
	echo -e "\e[34m|-------------------------------------------------------------------------------|\e[0m"
	echo -e "\e[31m   (0) \e[0m \e[32mExit\e[0m"
	echo -e "\e[34m|-------------------------------------------------------------------------------|\e[0m"
	echo ""

}

# Function to handle user input
handle_user_input() {

	# Get the hostname and username
	hostname=$(hostname)
	username=$(whoami)

	echo -e "${YELLOW}┌──($username㉿$hostname)-[$(pwd)]${NC}"

	choice=""
	echo -n -e "${YELLOW}└─\$>>${NC} "
	read choice

	echo ""

	case "$choice" in
	1)  ;;
	2)  ;;
	3) update_system ;;
	4) install_firmware ;;
	5) install_gpu_drivers ;;
	6) optimize_battery ;;
	7) install_multimedia_codecs ;;
	8) install_hw_video_acceleration_amd_or_intel ;;
	9)  ;;
	10) set_utc_time ;;
	11) disable_mitigations ;;
	12) enable_modern_standby ;;
	13)  ;;
	14) update_flatpak ;;
	15) cleanup_flatpak_cruft ;;
	15)  ;;
	16) change_hotname ;;
	17) check_mitigations_grub ;;
	18)  ;;
	19) cleanup_fedora ;;
	20) fix_chrome ;;
	21) display_XDG_session ;;
	22) fix_grub ;;
	23)  ;;
	24)  ;;
	25) btrfs_maint ;;
	26) create-extra-dir ;;
	27) speed-up-shutdown ;;
	28) firewall ;;
	29) zram ;;
	0)
		# Before exiting, check if duf and neofetch are installed
		for_exit "duf"
		for_exit "neofetch"
		for_exit "figlet"
		for_exit "espeak"
		duf
		neofetch
		figlet Ultramarine
		#end_time=$(date +%s)
		#time_taken=$((end_time - start_time))
		# # espeak -v en-us+m7 -s 165 "ThankYou! For! Using! My Configurations! Bye! "
		exit
		;;
	*)
		echo -e "Invalid choice. Please enter a number from 0 to 26."
		gum spin --spinner dot --title "Stand-by..." -- sleep 1
		;;
	esac
}

check_internet_connection

# Main loop for the menu
while true; do
	display_main_menu
	handle_user_input
done
