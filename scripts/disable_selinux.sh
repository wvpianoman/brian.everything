#!/bin/bash

# 1. Install grubby if you don't have it (usually pre-installed)
sudo dnf install grubby

# 2. Add the selinux=0 kernel parameter
sudo grubby --update-kernel=ALL --args="selinux=0"

# 3. Reboot your system
echo -e 'type sudo systemctl reboot'
