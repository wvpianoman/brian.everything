###################################
###--- Tolga/Brian ALIASES -----###
###################################

# source ~/.bashrc

# echo "" && fortune && echo ""

# Assign a color variable based on the RANDOM number
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'

display_message() {
    clear
    echo -e "\n                  Tolga's cleanup && updater\n"
    echo -e "\e[34m|--------------------\e[33m Currently configuring:\e[34m-------------------|"
    echo -e "|${YELLOW}==>${NC}  $1"
    echo -e "\e[34m|--------------------------------------------------------------|\e[0m"
    echo ""
    gum spin --spinner dot --title "Stand-by..." -- sleep 1
}

# Debugging step: echo what will be passed to display_message
echo "Calling display_message with: [${GREEN}✔${NC}]  Cleanup complete, ENJOY!"
display_message "[${GREEN}✔${NC}]  Cleanup complete, ENJOY!"

cleanup_fedora() {
    # Clean package cache
    display_message "[${GREEN}✔${NC}]  Time to clean up system..."
    sudo dnf clean all

    # Remove unnecessary dependencies
    sudo dnf autoremove -y

    # Sort the lists of installed packages and packages to keep
    display_message "[${GREEN}✔${NC}]   Sorting out list of installed packages and dependencies to keep..."
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

alias update='
sudo /bin/bash -c '\''[[ "$(busctl get-property org.freedesktop.NetworkManager /org/freedesktop/NetworkManager org.freedesktop.NetworkManager Metered | cut -c 3-)" == "2" || "$(busctl get-property org.freedesktop.NetworkManager /org/freedesktop/NetworkManager org.freedesktop.NetworkManager Metered | cut -c 3-)" == "4" ]]'\'' && \
echo -e "\e[1;32m[✔]\e[0m Network is metered. Rotating and vacuuming journal logs...\n" && \
(sudo journalctl --rotate; sudo journalctl --vacuum-time=1s && sleep 1) && sleep 1 && \
cleanup_fedora && echo -e "\e[1;32m[✔]\e[0m Checking system updates .....\n" && \
sudo dnf5 update && sudo dnf update && \
display_message "[${GREEN}✔${NC}]  Checking flatpaks" && \
echo -e "\e[1;32m[✔]\e[0m Checking updates for installed flatpak programs...\n" && \
sudo flatpak update -y && \
sleep 1 && \
echo -e "\e[1;32m[✔]\e[0m Removing Old Flatpak Cruft...\n" && \
flatpak uninstall --unused && \
flatpak uninstall --delete-data && \
sudo rm -rfv /var/tmp/flatpak-cache-* && \
[ -f /usr/bin/flatpak ] && flatpak uninstall --unused --delete-data --assumeyes && \
flatpak --user uninstall --unused -y --noninteractive && \
/usr/bin/flatpak --user update -y --noninteractive && \
/usr/bin/flatpak --user repair && \
echo -e "\e[1;32m[✔]\e[0m All updates and cleanups are complete.\n" && \
echo -e "\e[1;32m[✔]\e[0m Updating Flatpak font cache...\n" && \
flatpak list --app --columns=application,runtime | grep org.gnome.Platform | awk -F "\t" '\''{ if (split($1, a, ".") >= 3) print "flatpak run --command=fc-cache " $1 " -f -v"}'\'' | sh && \
echo "" && \
echo -e "\e[1;32m[✔]\e[0m Flatpak font cache update complete.\n"'

alias alert='notify-send --urgency=low "$(history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//")"'

alias systcl="sudo /home/brian/.config/scripts/systcl.sh"

###---------- my tools ----------###
alias htos="sudo ~/.config/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh"
alias mount="sudo ~/.config/scripts/Mounting-Options/MOUNT-ALL.sh"
alias mse="sudo ~/.config/scripts/mse.sh"
alias stoh="sudo ~/.config/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh"
alias umount="sudo ~/.config/scripts/Mounting-Options/UMOUNT-ALL.sh"

###---------- fun stuff ----------###
alias pics="sxiv -t $HOME/Pictures/CUSTOM-WALLPAPERS/"
alias wp="sxiv -t $HOME/Pictures/Wallpaper/"

###---------- navigate files and directories ----------###
alias ..="cd .."
alias cl="clear"
alias copy="rsync -P"
alias la="lsd -a"
alias ll="lsd -l"
alias Ls="lsd"
alias ls="ls --color=auto"
alias dir="dir --color=auto"
alias lsla="lsd -la"

# alias chmod commands
alias 000='sudo chmod -R 000'
alias 644='sudo chmod -R 644'
alias 666='sudo chmod -R 666'
alias 755='sudo chmod -R 755'
alias 777='sudo chmod -R 777'
alias mx='sudo chmod a+x'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

###---------- Tools ----------###
alias ff="fastfetch -c brian.jsonc"
alias rc="source ~/.bashrc"
alias bashrc='kwrite  ~/.bashrc'
alias tweak='sudo bash -c "echo westwood > /proc/sys/net/ipv4/tcp_congestion_control && echo mq-deadline | sudo tee /sys/block/sda/queue/scheduler"'
alias cong="sysctl net.ipv4.tcp_congestion_control"
alias fmem="echo && echo 'Current mem:' && free -h && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' && echo && echo 'After: ' && free -h"
alias fmem2="echo && echo 'Current mem:' && free -h && sudo /bin/sh -c '/bin/sync && /sbin/sysctl -w vm.drop_caches=3' && echo && echo 'After: ' && free -h"
alias fstab="sudo mount -a && sudo systemctl daemon-reload && echo && echo \"Reloading of fstab done\" && echo"
alias grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg"
alias io="cat /sys/block/sda/queue/scheduler"
alias line="echo '## ------------------------------ ##'"
alias nvidia="sudo systemctl enable --now akmods --force && sudo dracut --force && echo && echo \"Force akmods and Dracut on nvidia done\" && echo"
alias pdfcompress='bash /home/brian/.config/scripts/pdf1.sh'
alias samba='gum spin --spinner dot --title "Restarting Samba" -- sleep 2 && sudo systemctl enable smb.service nmb.service && sudo systemctl restart smb.service nmb.service'
alias swapreload="cl && echo && echo 'Turning swap off:' && echo 'Turning swap on:' && line && sudo swapon --all && sudo swapon --show && echo && echo 'Reload Swap(s):' && line && sudo mount -a && sudo systemctl daemon-reload && sudo swapon --show && echo && echo 'Free memory:' && line && free -h && echo && duf && sys && fmem"
alias sys="echo && io && echo && cong && echo && echo 'ZSWAP status: ( Y = ON )' && cat /sys/module/zswap/parameters/enabled && systemctl restart earlyoom && systemctl status earlyoom --no-pager"
alias trim="sudo fstrim -av"

alias sysctl-reload="sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system && sysctl -p"
alias sysctl-arch="sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system"
alias sysctl-solus='sudo mount -a && sudo systemctl daemon-reload && sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system'

###---------- file access ----------###
alias bconf="vim ~/.config/bash/.bashrc"
alias cp="cp -riv"
alias htos='sudo ~/.config/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh'
alias mkdir="mkdir -vp"
alias mount='sudo ~/.config/scripts/Mounting-Options/MOUNT-ALL.sh'
alias mse='sudo ~/.config/scripts/MYTOOLS/MAKE-SCRIPTS-EXECUTABLE.sh'
alias mv="mv -iv"
alias mynix='sudo ~/.config/scripts/COMMAN-NIX-COMMAND-SCRIPT/MyNixOS-commands.sh'
alias samba='echo && line && echo "Restarting samba" && line && sleep 2 && sudo systemctl enable smb.service nmb.service && sudo systemctl restart smb.service nmb.service && sudo systemctl restart wsdd'
alias stoh='sudo ~/.config/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh'
alias trimgen='sudo ~/.config/scripts/GENERATION-TRIMMER/TrimmGenerations.sh'
alias umount='sudo ~/.config/scripts/Mounting-Options/UMOUNT-ALL.sh'
alias zconf="vim ~/.config/zsh/.zshrc"

###---------- session ----------###
alias sess='session=$XDG_SESSION_TYPE && echo "" && gum spin --spinner dot --title "Current XDG session is: [ $session ] """ -- sleep 2'

# ###---------- Nvidia session ----------###
# export LIBVA_DRIVER_NAME=nvidia
# export WLR_NO_HARDWARE_CURSORS=1
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export __GL_SHADER_CACHE=1
# export __GL_THREADED_OPTIMIZATION=1

###---------- Konsole effects ----------###
# PS1="\[\e[1;m\]┌[\[\e[1;32m\]\u\[\e[1;34m\]@\h\[\e[1;m\]] \[\e[1;m\]::\[\e[1;36m\] \W \[\e[1;m\]::\n\[\e[1;m\]└\[\e[1;33m\]➤\[\e[0;m\]  "

###---------- Vscoding ----------###
# eval "$(direnv hook bash)"

