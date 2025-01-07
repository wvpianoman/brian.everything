# -------------------------------------------------
# .bashrc Configuration
# -------------------------------------------------

# ----- PATH Configuration -----
# Add custom and standard binary locations to PATH for command execution
# PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/usr/games:/sbin:$HOME/bin:$HOME/.local/bin"

# Only apply the following settings if bash is running interactively
case $- in
*i*) ;;      # Continue if interactive
*) return ;; # Exit if not interactive
esac

# ----- Color Support & Aliases -----
# Enable color support for commands and define aliases for enhanced readability
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    # Customize colors for "other-writable" directories
    LS_COLORS+=':ow=01;33'
fi

# Additional aliases for 'ls' to simplify common directory listings
alias ll='ls -l' # Long listing format
alias la='ls -A' # Show all entries except '.' and '..'
alias l='ls -CF' # Classify entries and display directories with trailing slash

# Load ble.sh for an enhanced interactive shell experience
if [[ -f /usr/share/blesh/ble.sh ]] && [[ ! -f ~/.bash-normal ]] && [[ $TERM != linux ]]; then
    source /usr/share/blesh/ble.sh --noattach --rcfile /etc/bigblerc

    # ----- GRC-RS Configuration -----
    # Enable colorized output for various commands
    GRC_ALIASES=true
    GRC="/usr/bin/grc-rs"
    if tty -s && [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && [ -n "$GRC" ]; then
        alias colourify="$GRC"
        alias ant='colourify ant'
        alias blkid='colourify blkid'
        alias configure='colourify configure'
        alias df='colourify df'
        alias diff='colourify diff'
        alias dig='colourify dig'
        alias dnf='colourify dnf'
        alias docker-machinels='colourify docker-machinels'
        alias dockerimages='colourify dockerimages'
        alias dockerinfo='colourify dockerinfo'
        alias dockernetwork='colourify dockernetwork'
        alias dockerps='colourify dockerps'
        alias dockerpull='colourify dockerpull'
        alias dockersearch='colourify dockersearch'
        alias dockerversion='colourify dockerversion'
        alias du='colourify du'
        alias fdisk='colourify fdisk'
        alias findmnt='colourify findmnt'
        alias go-test='colourify go-test'
        alias ifconfig='colourify ifconfig'
        alias iostat_sar='colourify iostat_sar'
        alias ip='colourify ip'
        alias ipaddr='colourify ipaddr'
        alias ipneighbor='colourify ipneighbor'
        alias iproute='colourify iproute'
        alias iptables='colourify iptables'
        alias irclog='colourify irclog'
        alias iwconfig='colourify iwconfig'
        alias kubectl='colourify kubectl'
        alias last='colourify last'
        alias ldap='colourify ldap'
        alias lolcat='colourify lolcat'
        alias lsattr='colourify lsattr'
        alias lsblk='colourify lsblk'
        alias lsmod='colourify lsmod'
        alias lsof='colourify lsof'
        alias lspci='colourify lspci'
        alias lsusb='colourify lsusb'
        alias mount='colourify mount'
        alias mtr='colourify mtr'
        alias mvn='colourify mvn'
        alias netstat='colourify netstat'
        alias nmap='colourify nmap'
        alias ntpdate='colourify ntpdate'
        alias ping='colourify ping'
        alias ping2='colourify ping2'
        alias proftpd='colourify proftpd'
        alias pv='colourify pv'
        alias semanageboolean='colourify semanageboolean'
        alias semanagefcontext='colourify semanagefcontext'
        alias semanageuser='colourify semanageuser'
        alias sensors='colourify sensors'
        alias showmount='colourify showmount'
        alias sockstat='colourify sockstat'
        alias ss='colourify ss'
        alias stat='colourify stat'
        alias sysctl='colourify sysctl'
        alias tcpdump='colourify tcpdump'
        alias traceroute='colourify traceroute'
        alias tune2fs='colourify tune2fs'
        alias ulimit='colourify ulimit'
        alias uptime='colourify uptime'
        alias vmstat='colourify vmstat'
        alias wdiff='colourify wdiff'
        alias yaml='colourify yaml'
    fi

    # Set GCC color settings for error and warning messages
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

    # Use 'bat' as a replacement for 'cat' with improved output formatting if available
    if [ -f /usr/bin/bat ]; then
        cat() {
            local use_cat=false
            # Check if any argument contains -v, -e, -t or their combinations
            for arg in "$@"; do
                if [[ "$arg" =~ ^-[vet]+$ ]]; then
                    use_cat=true
                    break
                fi
            done

            # If no special options, use bat
            if [ "$use_cat" == true ]; then
                command cat "$@"
            else
                bat --paging=never --style=plain "$@"
            fi
        }
        # Customize the 'help' command to display colorized output
        help() {
            if [ $# -eq 0 ]; then
                command help
            else
                "$@" --help 2>&1 | bat --paging=never --style=plain --language=help
            fi
        }
    fi

fi

# ----- History Configuration -----
# Configure shell history settings
HISTCONTROL=ignoreboth # Ignore duplicate and space-prefixed commands
shopt -s histappend    # Append to history file instead of overwriting it
HISTSIZE=10000          # Number of commands to remember in memory
HISTFILESIZE=20000      # Number of commands to store in the history file
shopt -s checkwinsize  # Check and adjust the terminal window size after each command

# ----- NVM Configuration -----
# Load Node Version Manager (NVM) if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ----- Auto-completion Configuration -----
# Enable programmable auto-completion if supported
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ----- FZF Configuration -----
# Load FZF key bindings and define custom search functions
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    eval "$(fzf --bash)"
    # Define a 'find-in-file' (fif) function using FZF and ripgrep
    fif() {
        if [ ! "$#" -gt 0 ]; then
            echo "Need a string to search for!"
            return 1
        fi
        fzf --preview "highlight -O ansi -l {} 2> /dev/null | rga --ignore-case --pretty --context 10 '$1' {}" < <(rga --files-with-matches --no-messages "$1")
    }
fi

# Attach ble.sh if loaded
if [[ ${BLE_VERSION-} ]]; then
    # Fix if use old snapshot with new blesh cache
    if grep -q -m1 _ble_decode_hook ~/.cache/blesh/*/decode.bind.*.bind; then _bleCacheVersion=new; else _bleCacheVersion=old; fi
    if grep -q -m1 _ble_decode_hook /usr/share/blesh/lib/init-bind.sh; then _bleInstalledVersion=new; else _bleInstalledVersion=old; fi
    [[ $_bleInstalledVersion != $_bleCacheVersion ]] && rm ~/.cache/blesh/*/[dk]*
    ble-attach
    # FZF Configuration
    if [ -f /usr/share/fzf/key-bindings.bash ]; then
        _ble_contrib_fzf_base=/usr/share/fzf/
    fi
else
    # Default PS1 for non-ble.sh interactive sessions
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# ┌───────────────────────────────────────────────────────────────────────────────────────────────┐
# |                                          Nvidia session                                       |
# └───────────────────────────────────────────────────────────────────────────────────────────────┘
 #       export LIBVA_DRIVER_NAME=nvidia
 #       export WLR_NO_HARDWARE_CURSORS=1
 #       export __GLX_VENDOR_LIBRARY_NAME=nvidia
 #       export __GL_SHADER_CACHE=1
 #       export __GL_THREADED_OPTIMIZATION=1

# ┌───────────────────────────────────────────────────────────────────────────────────────────────┐
# |                                          Custom alias                                         |
# └───────────────────────────────────────────────────────────────────────────────────────────────┘

        # Define color codes
        GREEN="\033[1;32m"
        RED="\033[1;31m"
        RESET="\033[0m"

        alias tline='echo -e "\n${GREEN}┌───────────────────────────────────────────────────────────────────────────────────────────────┐ ${RESET}\n"'
        alias bline='echo -e "\n${GREEN}└───────────────────────────────────────────────────────────────────────────────────────────────┘ ${RESET}\n"'

        alias blue="tline && sudo systemctl status disable-bluetooth-before-sleep.service --no-pager || true && bline && echo "" && tline && sudo systemctl status enable-bluetooth-after-resume.service --no-pager || true && bline"
        alias cake2='interface=$(ip link show | awk -F: '\''$0 ~ /wlp|wlo|wlx/ && $0 !~ /NO-CARRIER/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}'\''); sudo systemctl daemon-reload && sudo systemctl restart apply-cake-qdisc.service && sudo systemctl restart apply-cake-qdisc-wake.service && tline && sudo tc -s qdisc show dev $interface && sudo systemctl status apply-cake-qdisc.service --no-pager || true && sudo systemctl status apply-cake-qdisc-wake.service --no-pager || true && bline'
        alias check1="interface=\$(ip link show | awk -F: '\$0 ~ \"wlp|wlo|wlx\" && \$0 !~ \"NO-CARRIER\" {gsub(/^[ \t]+|[ \t]+$/, \"\", \$2); print \$2; exit}'); tline && sudo tc qdisc show dev \"\$interface\" && bline"
        alias check2="tline && ~/check-interface.sh || true && bline"
        alias cl="clear"
        alias clear-temp="$HOME/clear-temp.sh"
        alias find="history | grep "
        alias gitup="$HOME/gitup.sh"
        alias rc='source ~/.bashrc && cl && echo "" && fortune | lolcat && echo "" && echo ""'
        alias tolga-cong="sysctl net.ipv4.tcp_congestion_control"
        alias tolga-io="cat /sys/block/sda/queue/scheduler"
        alias tolga-io="tline && cat /sys/block/sda/queue/scheduler && bline"
        alias tolga-sys="tline && echo && tolga-io && echo && tolga-cong && echo && echo 'ZSWAP status: ( Y = ON )' && cat /sys/module/zswap/parameters/enabled && bline"
        alias tolga-trim="sudo fstrim -av"

        # Alias for Btrfs Frequent Maintenance (daily/weekly)
        alias btrfsMaintFrequent='
            echo "### Frequent Btrfs Maintenance ###";
            sudo fstrim -v /; # Trim (inform SSD which blocks are free)
            echo "--- Trim Completed ---";
            # **Modified Balance Command for Safety**
            sudo btrfs balance start -dusage=5 -musage=5 /; 
            echo "--- Balance Started (this may take some time, balancing data and metadata usage) ---";
            # **Optional: Uncomment for periodic filesystem check (adjust frequency as needed)**
            # sudo btrfs check --progress /
        '
        alias btrfsMaintInfrequent='
            clear
            echo "### Btrfs Infrequent Maintenance ###"
            read -p "Start Background Scrub and optional Filesystem Check? (y/n) " -n 1 -r
            echo    
            if [[ $REPLY =~ ^([yY][eE][sS]|[yY]) ]]; then
                echo "Starting Scrub..."
                sudo btrfs scrub start -B /
                echo "Scrub started in background. Waiting for 5 minutes before checking status..."
                sleep 300
                sudo btrfs scrub status /
                read -p "Run Filesystem Check now? (y/n) " -n 1 -r
                echo    
                if [[ $REPLY =~ ^([yY][eE][sS]|[yY]) ]]; then
                    sudo btrfs check --progress /dev/* # **Assuming / is on a single device, adjust as necessary**
                fi
            fi
        '
        alias btrfsMaint='
            echo "### Btrfs Maintenance: Trim, Scrub, Balance ###";
    
            # Step 1: Trim (inform SSD which blocks are free)
            sudo fstrim -v /;
            echo "--- Trim Completed ---";
    
            # Step 2: Start Scrub
            echo "Starting Scrub...";
            sudo btrfs scrub start -B /;
            echo "Scrub started in background.";

            # Step 3: Start Balance (if not already running)
            echo "Checking if Balance is already running...";
            if sudo btrfs balance status / | grep -q "No balance found"; then
                echo "Starting Balance...";
                sudo btrfs balance start -dusage=5 -musage=5 /;
                # Check if balance started successfully
                if [[ $? -eq 0 ]]; then
                    echo "--- Balance Started (this may take some time, balancing data and metadata usage) ---";
                else
                    echo "--- Failed to start Balance. Please check the system logs for more details. ---";
                fi
            else
                echo "--- Balance is already in progress, skipping... ---";
            fi
        '
        alias alert='notify-send --urgency=low "$(history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//")"'

alias systcl="sudo /home/brian/scripts/systcl.sh"

###---------- my tools ----------###
alias htos="sudo ~/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh"
alias mount="sudo ~/scripts/Mounting-Options/MOUNT-ALL.sh"
alias stoh="sudo ~/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh"
alias umount="sudo ~/scripts/Mounting-Options/UMOUNT-ALL.sh"

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
alias rebootforce='sudo shutdown -r -n now'
alias rebootsafe='sudo shutdown -r now'

###---------- Tools ----------###
alias rc='source ~/.bashrc && clear && echo "" && fortune | lolcat  && echo ""'
alias bashrc='kwrite  ~/.bashrc'
alias cong="sysctl net.ipv4.tcp_congestion_control"
alias fmem="echo && echo 'Current mem:' && free -h && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' && echo && echo 'After: ' && free -h"
alias fmem2="echo && echo 'Current mem:' && free -h && sudo /bin/sh -c '/bin/sync && /sbin/sysctl -w vm.drop_caches=3' && echo && echo 'After: ' && free -h"
alias fstab="sudo mount -a && sudo systemctl daemon-reload && echo && echo \"Reloading of fstab done\" && echo"
alias grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg"
alias io="cat /sys/block/sda/queue/scheduler"
alias line="echo '## ------------------------------ ##'"
alias nvidia='sudo systemctl enable --now akmods --force && sudo dracut --force && echo && echo "Force akmods and Dracut on NVIDIA done" && echo'

alias pdfcompress='bash $HOME/scripts/pdf1.sh'
alias samba='gum spin --spinner dot --title "Restarting Samba" -- sleep 2 && sudo systemctl enable smb.service nmb.service && sudo systemctl restart smb.service nmb.service'
alias swapreload="cl && echo && echo 'Turning swap off:' && echo 'Turning swap on:' && line && sudo swapon --all && sudo swapon --show && echo && echo 'Reload Swap(s):' && line && sudo mount -a && sudo systemctl daemon-reload && sudo swapon --show && echo && echo 'Free memory:' && line && free -h && echo && duf && sys && fmem"
alias sys="echo && io && echo && cong && echo && echo 'ZSWAP status: ( Y = ON )' && cat /sys/module/zswap/parameters/enabled && systemctl restart earlyoom && systemctl status earlyoom --no-pager"
alias trim="sudo fstrim -av"

# Assign a color variable based on the RANDOM number
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'

alias sysctl-reload="sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system && sudo sysctl -p && sudo mount -a && sudo systemctl daemon-reload"

###---------- file access ----------###
alias bconf="vim ~/.config/bash/.bashrc"
alias cp="cp -riv"
alias htos='sudo ~/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh'
alias mkdir="mkdir -vp"
alias mount='sudo ~/scripts/Mounting-Options/MOUNT-ALL.sh'
alias mse='sudo ~/scripts/MYTOOLS/MAKE-SCRIPTS-EXECUTABLE.sh'
alias mv="mv -iv"
alias mynix='sudo ~/scripts/COMMAN-NIX-COMMAND-SCRIPT/MyNixOS-commands.sh'
alias stoh='sudo ~/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh'
alias trimgen='sudo ~/scripts/GENERATION-TRIMMER/TrimmGenerations.sh'
alias umount='sudo ~/scripts/Mounting-Options/UMOUNT-ALL.sh'
alias zconf="vim ~/.config/zsh/.zshrc"

alias cj="sudo journalctl --rotate; sudo journalctl --vacuum-time=1s"

alias batt='clear && echo "Battery: $(acpi -b | awk '\''{print $3}'\'')" && echo '' && echo "Battery Percentage: $(acpi -b | awk '\''{print $4}'\'')" && echo '' && echo "Remaining Time: $(acpi -b | awk '\''{print $5,$6,$7 == "until" ? "until fully charged" : $7}'\'')"'

###---------- session ----------###
alias sess='session=$XDG_SESSION_TYPE && echo "" && gum spin --spinner dot --title "Current XDG session is: [ $session ] """ -- sleep 2'

        cl && echo "" && fortune | lolcat && echo "" && echo ""
