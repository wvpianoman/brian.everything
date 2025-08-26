#!/usr/bin/env bash
# Tolga Erok
# 18/5/2025
# My Flatpak Manager / Installer (CLI Edition)
# VERSION 6 (CLI rewrite)

set -euo pipefail

done="✅"
error="⚠️"

# Relaunch script with sudo if not root
if [[ $EUID -ne 0 ]]; then
  echo "Elevating privileges with sudo..."
  exec sudo "$0" "$@"
fi

# ─── Globals ─────────────────────────────────────────────
DESKTOP_FILE="$HOME/.local/share/applications/flatpak-manager.desktop"
LOCAL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/flatpak-manager"
SCRIPT_VER=3
VER_FILE="$LOCAL_DIR/version"
flatpak_list="$HOME/flatpaks-installed.txt"
REAL_USER="${SUDO_USER:-$(logname)}"
USER_HOME=$(eval echo "~$REAL_USER")

mkdir -p "$LOCAL_DIR"

# ─── Helper: My Print separator ─────────────────────────────
line() { printf '%*s\n' "${COLUMNS:-80}" '' | tr ' ' -; }

# ─── Setup ───────────────────────────────────────────────
first_run_setup() {
  echo "🛠️ Running initial Flatpak Manager setup..."

  # Add Flathub if missing
  flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

  declare -a default_flatpaks=(
    app/com.dec05eba.gpu_screen_recorder/x86_64/stable
    app/com.heroicgameslauncher.hgl/x86_64/stable
    app/com.valvesoftware.Steam/x86_64/stable
    app/io.github.ilya_zlobintsev.LACT/x86_64/stable
    app/net.davidotek.pupgui2/x86_64/stable
    app/net.lutris.Lutris/x86_64/stable
    com.github.tchx84.Flatseal
    com.obsproject.Studio
    com.obsproject.Studio.Plugin.{OBSVkCapture,GStreamerVaapi}
    io.github.aandrew_me.ytdn
    io.github.flattool.Warehouse
    io.missioncenter.MissionCenter
    org.gnome.Connections
    org.gnome.DejaDup
    org.gnome.Rhythmbox3
    org.gnome.World.PikaBackup
    org.gnome.baobab
    org.gtk.Gtk3theme.Arc-Dark
    org.gtk.Gtk3theme.Yaru-Blue
    org.gtk.Gtk3theme.Yaru-Deepblue
    runtime/com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable
    runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08
    runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08
    runtime/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08
    runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08
    runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08
  )

  for app in "${default_flatpaks[@]}"; do
    echo "📦 Installing $app ..."
    flatpak install -y --system --or-update flathub "$app" || echo "$error Failed: $app"
  done

  # Theme override
  sudo flatpak override org.gnome.Rhythmbox3 --env=GTK_THEME=Arc-Dark --filesystem=host || true

  echo "$SCRIPT_VER" >"$VER_FILE"

  mkdir -p "$(dirname "$DESKTOP_FILE")"
  cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=LinuxTweaks Flatpak Manager
Comment=Manage and reinstall Flatpaks
Exec=$HOME/flatpak-manager.sh
Icon=system-software-install
Terminal=true
Type=Application
Categories=Utility;System;
EOF

  sudo -u "$REAL_USER" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u "$REAL_USER")/bus" \
    DISPLAY=:0 notify-send "Flatpak Manager" "✅ Setup complete. Launcher created!"

  echo "Setup complete."
}

# ─── Export Flatpak List ─────────────────────────────
export_flatpak_list() {
  flatpak list --app --columns=application >"$flatpak_list"
  echo "✅ Flatpak list exported to: $flatpak_list"
}

# ─── Import Flatpak List ─────────────────────────────
import_flatpak_list() {
  read -rp "Enter path to Flatpak list file: " file
  [[ -z "$file" || ! -f "$file" ]] && { echo "$error Invalid file"; return; }
  while read -r app; do
    flatpak install -y flathub "$app" || echo "$error Failed: $app"
  done <"$file"
  echo "📥 Imported Flatpaks from: $file"
}

# ─── Reinstall from Saved List ───────────────────────
reinstall_flatpaks() {
  if [[ -f "$flatpak_list" ]]; then
    while read -r app; do
      flatpak install -y flathub "$app" || echo "$error Failed: $app"
    done <"$flatpak_list"
    echo "🔁 Reinstalled Flatpaks from list."
  else
    echo "❌ List not found: $flatpak_list"
  fi
}

# ─── Remove Flatpaks ─────────────────────────────────
remove_all_flatpaks() {
  echo "⚠️ Remove ALL System Flatpaks? [y/N]"
  read -r ans
  [[ $ans != [yY] ]] && return

  mapfile -t system_flatpaks < <(flatpak list --system --app --columns=application)
  for app in "${system_flatpaks[@]}"; do
    flatpak uninstall --system -y --delete-data "$app"
  done
  echo "🗑️ All System Flatpaks removed."
}

remove_all_user_flatpaks() {
  echo "⚠️ Remove ALL User Flatpaks? [y/N]"
  read -r ans
  [[ $ans != [yY] ]] && return

  mapfile -t user_flatpaks < <(flatpak list --user --app --columns=application)
  for app in "${user_flatpaks[@]}"; do
    flatpak uninstall --user -y --delete-data "$app"
  done
  echo "🗑️ All User Flatpaks removed."
}

# ─── Show Lists ─────────────────────────────────────
show_flatpak_list() {
  echo "📋 Installed System Flatpaks:"
  flatpak list --system --app
}

show_flatpak_user_list() {
  echo "📋 Installed User Flatpaks:"
  flatpak list --user --app
}

# ─── Main Menu ──────────────────────────────────────
main_menu() {
  clear
  line
  echo "LinuxTweaks Flatpak Manager"
  line
  echo "1) Initial Setup"
  echo "2) Export Flatpak List"
  echo "3) Import Flatpak List"
  echo "4) Reinstall from List"
  echo "5) Remove ALL System Flatpaks"
  echo "6) Remove ALL User Flatpaks"
  echo "7) Show Installed System Flatpaks"
  echo "8) Show Installed User Flatpaks"
  echo "9) Exit"
  line
  read -rp "Select an option: " choice

  case "$choice" in
    1) first_run_setup ;;
    2) export_flatpak_list ;;
    3) import_flatpak_list ;;
    4) reinstall_flatpaks ;;
    5) remove_all_flatpaks ;;
    6) remove_all_user_flatpaks ;;
    7) show_flatpak_list ;;
    8) show_flatpak_user_list ;;
    9) exit 0 ;;
    *) echo "$error Invalid choice" ;;
  esac
}

while true; do
  main_menu
  read -rp "Press Enter to continue..."
done