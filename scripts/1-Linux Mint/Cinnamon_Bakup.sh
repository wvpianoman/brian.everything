#!/bin/bash
# Tolga Erok
# Version: 5
# My Cinnamon Backup & Restore Script
# So far, it works with LMDE7, Linux Mint, and Fedora Cinnamon

# colours for output
blue='\033[0;34m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[1;33m'
nc='\033[0m'

# where to save backups
backup_dir="$HOME/cinnamon_backup"
dconf_path="/org/cinnamon/"

# what to backup
applets="$HOME/.local/share/cinnamon/applets"
extensions="$HOME/.local/share/cinnamon/extensions"
fonts="$HOME/.fonts"
icons="$HOME/.icons"
nemo_actions="$HOME/.local/share/nemo/actions"
themes="$HOME/.themes"

# print messages
msg() {
    echo -e "${green}[info]${nc} $1"
}

error() {
    echo -e "${red}[error]${nc} $1"
}

warn() {
    echo -e "${yellow}[warning]${nc} $1"
}

section() {
    echo -e "\n${blue}=== $1 ===${nc}\n"
}

# check if cinnamon is running
check_desktop() {
    if [ "$XDG_CURRENT_DESKTOP" != "X-Cinnamon" ] && [ -z "$CINNAMON_VERSION" ]; then
        warn "not running cinnamon desktop, but continuing anyway"
    fi
}

# list applets
show_applets() {
    section "installed applets"
    if [ -d "$applets" ]; then
        count=0
        for item in "$applets"/*; do
            if [ -d "$item" ]; then
                basename "$item"
                ((count++))
            fi
        done
        echo -e "\n${green}total: $count${nc}"
    else
        warn "no applets found"
    fi
}

# list extensions
show_extensions() {
    section "installed extensions"
    if [ -d "$extensions" ]; then
        count=0
        for item in "$extensions"/*; do
            if [ -d "$item" ]; then
                basename "$item"
                ((count++))
            fi
        done
        echo -e "\n${green}total: $count${nc}"
    else
        warn "no extensions found"
    fi
}

# list nemo actions
show_actions() {
    section "nemo actions"
    if [ -d "$nemo_actions" ]; then
        count=0
        for item in "$nemo_actions"/*.nemo_action; do
            if [ -f "$item" ]; then
                basename "$item"
                ((count++))
            fi
        done
        echo -e "\n${green}total: $count${nc}"
    else
        warn "no nemo actions found"
    fi
}

# list icons
show_icons() {
    section "installed icons"
    if [ -d "$icons" ]; then
        count=0
        for item in "$icons"/*; do
            if [ -d "$item" ]; then
                basename "$item"
                ((count++))
            fi
        done
        echo -e "\n${green}total: $count${nc}"
    else
        warn "no icons directory found"
    fi
}

# list fonts
show_fonts() {
    section "installed fonts"
    if [ -d "$fonts" ]; then
        count=0
        for item in "$fonts"/*; do
            if [ -f "$item" ] || [ -d "$item" ]; then
                basename "$item"
                ((count++))
            fi
        done
        echo -e "\n${green}total: $count${nc}"
    else
        warn "no fonts directory found"
    fi
}

# list themes
show_themes() {
    section "installed themes"
    if [ -d "$themes" ]; then
        count=0
        for item in "$themes"/*; do
            if [ -d "$item" ]; then
                basename "$item"
                ((count++))
            fi
        done
        echo -e "\n${green}total: $count${nc}"
    else
        warn "no themes directory found"
    fi
}

# backup everything for the brotherhood
do_backup() {
    section "starting backup"
    
    timestamp=$(date +%Y%m%d_%H%M%S)
    archive="$backup_dir/cinnamon_backup_${timestamp}.tar.gz"
    settings="$backup_dir/cinnamon_dconf_${timestamp}.conf"
    
    mkdir -p "$backup_dir"
    
    # figure out what exists
    items=""
    [ -d "$applets" ] && items="$items .local/share/cinnamon/applets"
    [ -d "$extensions" ] && items="$items .local/share/cinnamon/extensions"
    [ -d "$nemo_actions" ] && items="$items .local/share/nemo/actions"
    [ -d "$icons" ] && items="$items .icons"
    [ -d "$fonts" ] && items="$items .fonts"
    [ -d "$themes" ] && items="$items .themes"
    
    if [ -z "$items" ]; then
        error "brother, there's nothing to backup!"
        return 1
    fi
    
    # create the archive
    msg "creating backup archive..."
    tar -czf "$archive" -C "$HOME" \
        --exclude='*/.cache' \
        --exclude='*/cache' \
        $items 2>/dev/null
    
    if [ $? -eq 0 ]; then
        msg "files backed up successfully"
    else
        error "backup failed, SHIT!"
        return 1
    fi
    
    # save settings
    msg "saving cinnamon settings..."
    dconf dump "$dconf_path" > "$settings" 2>/dev/null
    if [ $? -eq 0 ]; then
        msg "settings saved"
    else
        warn "couldn't save settings"
    fi
    
    # create symlinks to latest backup
    rm -f "$backup_dir/latest.tar.gz" "$backup_dir/latest_dconf.conf"
    ln -sf "$archive" "$backup_dir/latest.tar.gz"
    ln -sf "$settings" "$backup_dir/latest_dconf.conf"
    
    section "backup complete"
    msg "archive: $archive"
    msg "settings: $settings"
    msg "size: $(du -h "$archive" | cut -f1)"
}

# restore from backup
do_restore() {
    section "starting restore"
    
    # show available backups
    echo "available backups:"
    backups=()
    index=1
    
    if [ -d "$backup_dir" ]; then
        for file in "$backup_dir"/cinnamon_backup_*.tar.gz; do
            if [ -f "$file" ]; then
                size=$(du -h "$file" | cut -f1)
                echo " $index) $(basename "$file") - $size"
                backups+=("$file")
                ((index++))
            fi
        done
    fi
    
    if [ ${#backups[@]} -eq 0 ]; then
        error "no backups found in $backup_dir"
        return 1
    fi
    
    echo " 0) cancel"
    read -p "select backup (0-$((index-1))): " choice
    
    if [ "$choice" = "0" ]; then
        msg "cancelled"
        return 0
    fi
    
    if [ "$choice" -lt 1 ] || [ "$choice" -ge "$index" ]; then
        error "invalid choice"
        return 1
    fi
    
    selected="${backups[$((choice-1))]}"
    msg "selected: $(basename "$selected")"
    
    # confirm
    warn "this will replace your current setup!"
    read -p "continue? (Type: yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        msg "cancelled"
        return 0
    fi
    
    # extract the archive
    msg "restoring files..."
    tar -xzf "$selected" -C "$HOME" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        msg "files restored"
    else
        error "restore failed"
        return 1
    fi
    
    # refresh fonts if needed
    if [ -d "$fonts" ]; then
        msg "updating font cache..."
        fc-cache -f -v > /dev/null 2>&1
        msg "fonts updated"
    fi
    
    # check for settings/donf file
    backup_name=$(basename "$selected" .tar.gz)
    settings_file="$backup_dir/${backup_name/backup/dconf}.conf"
    
    if [ -f "$settings_file" ]; then
        warn "found settings file"
        read -p "restore cinnamon settings? (y/n): " restore_settings
        if [ "$restore_settings" = "y" ]; then
            dconf load "$dconf_path" < "$settings_file" 2>/dev/null
            if [ $? -eq 0 ]; then
                msg "settings restored"
            else
                warn "couldn't restore settings"
            fi
        else
            msg "skipped settings"
        fi
    fi
    
    section "restore complete"
    warn "restart cinnamon to see changes"
    msg "press alt+f2, type 'r', and hit enter"
}

# menu
show_menu() {
    clear
    section "  LinuxTweaks Cinnamon backup & restore"
    echo " ---------------------------------------"
    echo "  1) list applets"
    echo "  2) list extensions"
    echo "  3) list nemo actions"
    echo "  4) list icons"
    echo "  5) list fonts"
    echo "  6) list themes"
    echo "  7) show everything"
    echo "  8) backup all"
    echo "  9) restore from backup"
    echo "  10) exit"
    echo
    echo " ---------------------------------------"
    read -p "  choose option (1-10): " option
    echo
    
    case $option in
        1)
            show_applets
            echo
            read -p "press return to continue..."
            ;;
        2)
            show_extensions
            echo
            read -p "press return to continue..."
            ;;
        3)
            show_actions
            echo
            read -p "press return to continue..."
            ;;
        4)
            show_icons
            echo
            read -p "press return to continue..."
            ;;
        5)
            show_fonts
            echo
            read -p "press return to continue..."
            ;;
        6)
            show_themes
            echo
            read -p "press return to continue..."
            ;;
        7)
            show_applets
            show_extensions
            show_actions
            show_icons
            show_fonts
            show_themes
            echo
            read -p "press return to continue..."
            ;;
        8)
            do_backup
            echo
            read -p "press return to continue..."
            ;;
        9)
            do_restore
            echo
            read -p "press return to continue..."
            ;;
        10)
            msg "goodbye brother"
            exit 0
            ;;
        *)
            error "invalid option, brother"
            echo
            read -p "press return to continue..."
            ;;
    esac
}

# run my menu
check_desktop
while true; do
    show_menu
done

