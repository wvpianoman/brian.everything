#!/bin/bash

# user-level pipewire (run as user, not root)
# add to your shell profile or autostart:
pipewire & pipewire-pulse & wireplumber &
