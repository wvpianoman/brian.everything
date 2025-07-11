#!/bin/bash

# Brian Francisco
# Personal use case packages
# Jan 20 2024

#  ¯\_(ツ)_/¯

# Function to optimize battery life on lappy, in theory.... LOL
optimize_battery() {
	display_message "Optimizing battery life..."

	# Check if the battery exists
	if [ -e "/sys/class/power_supply/BAT0" ]; then
		# Install TLP and mask power-profiles-daemon
		sudo eopkg iy -y tlp
		sudo systemctl mask power-profiles-daemon

		# Install powertop and apply auto-tune
		sudo eopkg it -y powertop
		sudo powertop --auto-tune

		display_message "Battery optimization completed."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	else
		display_message "No battery found. Skipping battery optimization."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi
}
