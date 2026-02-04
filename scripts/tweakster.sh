#!/bin/bash
# tolga erok - 29 jan 2026
# My Universal Performance Tweakser, Kernel & IO scheduler
# Works on: Arch/Manjaro, Debian/Ubuntu/LMDE, Fedora/RHEL
# FIXED: RAM-aware swappiness, fstab optimization, no rc.local, config existence checks

SCRIPT_NAME="    LinuxTweaks Universal Tweakser"
VERSION="3.0-fixed"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE} $SCRIPT_NAME v$VERSION${NC}"
    echo -e "${BLUE}====================================================${NC}\n"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script must be run as root${NC}"
        exit 1
    fi
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    elif [ -f /etc/arch-release ]; then
        DISTRO="arch"
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
    else
        DISTRO="unknown"
    fi
}

get_real_user() {
    if [ -n "$SUDO_USER" ]; then
        echo "$SUDO_USER"
    else
        echo "$USER"
    fi
}

run_as_user() {
    local user=$(get_real_user)
    if [ "$user" != "root" ] && [ -n "$user" ]; then
        sudo -u "$user" "$@"
    else
        echo -e "${RED}Error: Cannot determine non-root user${NC}"
        exit 1
    fi
}

# ============================================================================
# RAM DETECTION FUNCTIONS (NEW)
# ============================================================================

get_ram_gb() {
    free -g | awk '/^Mem:/{print $2}'
}

get_ram_category() {
    local ram=$(get_ram_gb)
    if [ "$ram" -le 8 ]; then
        echo "low"
    elif [ "$ram" -le 16 ]; then
        echo "medium"
    else
        echo "high"
    fi
}

get_recommended_swappiness() {
    local ram=$(get_ram_gb)
    local ram_category=$(get_ram_category)
    
    case $ram_category in
        low)
            # 8GB or less - use lower swappiness if zswap enabled
            if check_zswap_enabled; then
                echo "45"
            else
                echo "60"
            fi
            ;;
        medium)
            echo "60"  # 16GB - default is best
            ;;
        high)
            echo "60"  # 24GB+ - default is best
            ;;
    esac
}

get_recommended_commit() {
    local ram=$(get_ram_gb)
    
    if [ "$ram" -le 8 ]; then
        echo "30"
    elif [ "$ram" -le 16 ]; then
        echo "60"
    elif [ "$ram" -le 24 ]; then
        echo "90"
    else
        echo "120"  # 30GB+
    fi
}

check_zswap_enabled() {
    if [ -f /sys/module/zswap/parameters/enabled ]; then
        local enabled=$(cat /sys/module/zswap/parameters/enabled)
        [ "$enabled" = "Y" ] && return 0
    fi
    return 1
}

get_recommended_read_ahead() {
    local ram_gb=$(get_ram_gb)
    local device_type=$1  # nvme, ssd, or hdd
    
    case $device_type in
        nvme)
            if [ "$ram_gb" -ge 24 ]; then
                echo "1024"  # 30GB+ RAM - aggressive
            elif [ "$ram_gb" -ge 16 ]; then
                echo "512"   # 16-24GB RAM - balanced
            else
                echo "256"   # 8-16GB RAM - conservative
            fi
            ;;
        ssd)
            if [ "$ram_gb" -ge 24 ]; then
                echo "512"   # 30GB+ RAM - aggressive
            elif [ "$ram_gb" -ge 16 ]; then
                echo "256"   # 16-24GB RAM - balanced
            else
                echo "128"   # 8-16GB RAM - conservative
            fi
            ;;
        hdd)
            if [ "$ram_gb" -ge 16 ]; then
                echo "1024"  # 16GB+ RAM - larger reads for HDDs
            else
                echo "512"   # 8-16GB RAM - standard
            fi
            ;;
    esac
}

# ============================================================================
# KERNEL MANAGEMENT
# ============================================================================

get_current_kernel() {
    uname -r
}

list_installed_kernels() {
    echo -e "${GREEN}Installed kernels:${NC}"
    if command -v pacman &>/dev/null; then
        pacman -Q | grep "^linux" | grep -v firmware | grep -v api
    elif command -v dpkg &>/dev/null; then
        dpkg -l | grep -E "^ii\s+linux-(image|headers)" | awk '{print $2}'
    elif command -v rpm &>/dev/null; then
        rpm -qa | grep -E "^kernel-(core|devel|headers)"
    fi
}

detect_storage_devices() {
    echo -e "${BLUE}=== Detected Storage Devices ===${NC}"
    echo -e "\n${GREEN}NVMe Devices:${NC}"
    lsblk -d -o NAME,SIZE,MODEL,ROTA | grep nvme || echo "None found"

    echo -e "\n${GREEN}SATA SSDs:${NC}"
    for dev in /sys/block/sd*; do
        if [ -d "$dev" ]; then
            rota=$(cat $dev/queue/rotational 2>/dev/null)
            if [ "$rota" = "0" ]; then
                name=$(basename $dev)
                size=$(lsblk -d -n -o SIZE /dev/$name 2>/dev/null)
                model=$(cat $dev/device/model 2>/dev/null | xargs)
                echo "$name - $size - $model"
            fi
        fi
    done

    echo -e "\n${GREEN}HDDs:${NC}"
    for dev in /sys/block/sd*; do
        if [ -d "$dev" ]; then
            rota=$(cat $dev/queue/rotational 2>/dev/null)
            if [ "$rota" = "1" ]; then
                name=$(basename $dev)
                size=$(lsblk -d -n -o SIZE /dev/$name 2>/dev/null)
                model=$(cat $dev/device/model 2>/dev/null | xargs)
                echo "$name - $size - $model"
            fi
        fi
    done
}

has_only_ssds() {
    for dev in /sys/block/sd*; do
        if [ -d "$dev" ]; then
            rota=$(cat $dev/queue/rotational 2>/dev/null)
            [ "$rota" = "1" ] && return 1  # Found HDD
        fi
    done
    return 0  # Only SSDs
}

check_aur_helper() {
    local user=$(get_real_user)
    if ! run_as_user which yay &>/dev/null && ! run_as_user which paru &>/dev/null; then
        echo -e "${RED}Error: No AUR helper found${NC}"
        echo "Install yay or paru first"
        exit 1
    fi
}

install_xanmod() {
    echo -e "${YELLOW}Installing XanMod kernel...${NC}"
    detect_distro

    if [[ "$DISTRO" =~ (arch|manjaro|biglinux|endeavouros|garuda) ]]; then
        check_aur_helper
        local aur_helper="yay"
        run_as_user which paru &>/dev/null && aur_helper="paru"

        echo "XanMod variants:"
        echo "1) linux-xanmod (Main)"
        echo "2) linux-xanmod-lts"
        echo "3) linux-xanmod-edge"
        echo "4) linux-xanmod-rt"
        read -p "Choose [1-4]: " choice

        case $choice in
            1) KERNEL="linux-xanmod" ;;
            2) KERNEL="linux-xanmod-lts" ;;
            3) KERNEL="linux-xanmod-edge" ;;
            4) KERNEL="linux-xanmod-rt" ;;
            *) echo "Invalid"; return 1 ;;
        esac

        if run_as_user $aur_helper -S --needed $KERNEL ${KERNEL}-headers; then
            echo -e "${GREEN}XanMod kernel installed successfully${NC}"
        else
            echo -e "${RED}Failed to install XanMod kernel${NC}"
            return 1
        fi

    elif [[ "$DISTRO" =~ (debian|ubuntu|linuxmint|lmde|pop) ]]; then
        wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg
        echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list
        apt update && apt install -y linux-xanmod-x64v3

    elif [[ "$DISTRO" =~ (fedora|rhel|centos|rocky) ]]; then
        dnf copr enable -y rmnscnce/xanmod
        dnf install -y kernel-xanmod-edge
    fi

    rebuild_nvidia
    update_bootloader
    echo -e "${GREEN}XanMod installed. Reboot to use.${NC}"
}

install_zen() {
    echo -e "${YELLOW}Installing Zen kernel...${NC}"
    detect_distro

    if [[ "$DISTRO" =~ (arch|manjaro|biglinux|endeavouros|garuda) ]]; then
        check_aur_helper
        local aur_helper="yay"
        run_as_user which paru &>/dev/null && aur_helper="paru"
        
        if run_as_user $aur_helper -S --needed linux-zen linux-zen-headers; then
            echo -e "${GREEN}Zen kernel installed successfully${NC}"
        else
            echo -e "${RED}Failed to install Zen kernel${NC}"
            return 1
        fi
        
        rebuild_nvidia
        update_bootloader
        echo -e "${GREEN}Zen installed. Reboot to use.${NC}"
    else
        echo -e "${RED}Zen is Arch-specific${NC}"
    fi
}

install_liquorix() {
    echo -e "${YELLOW}Installing Liquorix kernel...${NC}"
    detect_distro

    if [[ "$DISTRO" =~ (arch|manjaro|biglinux|endeavouros|garuda) ]]; then
        check_aur_helper
        local aur_helper="yay"
        run_as_user which paru &>/dev/null && aur_helper="paru"
        
        if run_as_user $aur_helper -S --needed linux-lqx linux-lqx-headers; then
            echo -e "${GREEN}Liquorix kernel installed successfully${NC}"
        else
            echo -e "${RED}Failed to install Liquorix kernel${NC}"
            return 1
        fi

    elif [[ "$DISTRO" =~ (debian|ubuntu|linuxmint|lmde|pop) ]]; then
        curl -s 'https://liquorix.net/add-liquorix-repo.sh' | bash
        apt update && apt install -y linux-image-liquorix-amd64 linux-headers-liquorix-amd64
    fi

    rebuild_nvidia
    update_bootloader
    echo -e "${GREEN}Liquorix installed. Reboot to use.${NC}"
}

remove_kernel() {
    echo -e "${YELLOW}Available kernels:${NC}"
    list_installed_kernels
    echo ""
    echo "Current: $(get_current_kernel)"
    read -p "Enter kernel name to remove: " kernel_name

    if [ -z "$kernel_name" ]; then
        echo "Cancelled"
        return
    fi

    read -p "Remove $kernel_name? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        if command -v pacman &>/dev/null; then
            pacman -Rns ${kernel_name} ${kernel_name}-headers 2>/dev/null
        elif command -v apt &>/dev/null; then
            apt remove --purge -y ${kernel_name}
        elif command -v dnf &>/dev/null; then
            dnf remove -y ${kernel_name}
        fi
        update_bootloader
        echo -e "${GREEN}Kernel removed${NC}"
    fi
}

# ============================================================================
# I/O SCHEDULER CONFIGURATION
# ============================================================================

configure_io_scheduler_comprehensive() {
    echo -e "${YELLOW}Configuring I/O schedulers...${NC}"
    detect_storage_devices

    # Check if config exists
    if [ -f /etc/udev/rules.d/60-ioschedulers.rules ]; then
        echo -e "${YELLOW}I/O scheduler rules already exist${NC}"
        read -p "Overwrite existing config? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Skipping I/O scheduler configuration${NC}"
            return 0
        fi
        # Backup existing rules
        cp /etc/udev/rules.d/60-ioschedulers.rules /etc/udev/rules.d/60-ioschedulers.rules.bak.$(date +%Y%m%d_%H%M%S)
        echo -e "${GREEN}Backed up existing rules${NC}"
    fi

    echo ""
    echo "Profiles:"
    echo "1) Desktop Optimized - Best Interactivity (NVMe:kyber, SSD:bfq, HDD:bfq)"
    echo "2) Balanced Desktop/Server (NVMe:none, SSD:kyber, HDD:bfq)"
    echo "3) Maximum Throughput - Server (NVMe:none, SSD:mq-deadline, HDD:mq-deadline)"
    echo "4) All BFQ - Smoothest Experience (All:bfq)"
    read -p "Choose [1-4]: " profile_choice

    # Get RAM-aware read_ahead values
    local nvme_ra=$(get_recommended_read_ahead "nvme")
    local ssd_ra=$(get_recommended_read_ahead "ssd")
    local hdd_ra=$(get_recommended_read_ahead "hdd")
    local ram_gb=$(get_ram_gb)
    
    echo -e "${BLUE}Detected ${ram_gb}GB RAM - using optimized read_ahead values${NC}"
    echo -e "${BLUE}NVMe: ${nvme_ra}KB, SSD: ${ssd_ra}KB, HDD: ${hdd_ra}KB${NC}"

    case $profile_choice in
        1) # Desktop optimized - best for multitasking
           NVME_SCHED="kyber"; SSD_SCHED="bfq"; HDD_SCHED="bfq" 
           NVME_RA="$nvme_ra"; SSD_RA="$ssd_ra"; HDD_RA="$hdd_ra"
           echo -e "${GREEN}Profile: Desktop Optimized (best interactivity)${NC}" ;;
        2) # Balanced - raw speed NVMe, fair SSD
           NVME_SCHED="none"; SSD_SCHED="kyber"; HDD_SCHED="bfq"
           NVME_RA="$nvme_ra"; SSD_RA="$ssd_ra"; HDD_RA="$hdd_ra"
           echo -e "${GREEN}Profile: Balanced (speed + fairness)${NC}" ;;
        3) # Maximum throughput - server/benchmarks
           NVME_SCHED="none"; SSD_SCHED="mq-deadline"; HDD_SCHED="mq-deadline"
           NVME_RA="$nvme_ra"; SSD_RA="$ssd_ra"; HDD_RA="$hdd_ra"
           echo -e "${GREEN}Profile: Maximum Throughput (server workloads)${NC}" ;;
        4) # All BFQ - smoothest desktop
           NVME_SCHED="bfq"; SSD_SCHED="bfq"; HDD_SCHED="bfq"
           NVME_RA="$nvme_ra"; SSD_RA="$ssd_ra"; HDD_RA="$hdd_ra"
           echo -e "${GREEN}Profile: All BFQ (smoothest multitasking)${NC}" ;;
        *) echo "Invalid"; return 1 ;;
    esac

    cat >/etc/udev/rules.d/60-ioschedulers.rules <<EOF
# NVMe Devices
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="$NVME_SCHED"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/nr_requests}="256"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/read_ahead_kb}="$NVME_RA"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/add_random}="0"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/rq_affinity}="2"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/max_sectors_kb}="1024"

# SATA SSDs
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="$SSD_SCHED"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/nr_requests}="256"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/read_ahead_kb}="$SSD_RA"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/add_random}="0"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/rq_affinity}="2"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/max_sectors_kb}="512"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{device/queue_depth}="32"

# HDDs
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="$HDD_SCHED"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/nr_requests}="128"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/read_ahead_kb}="$HDD_RA"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/rq_affinity}="2"
EOF

    if udevadm control --reload-rules && udevadm trigger --subsystem-match=block; then
        echo -e "${GREEN}I/O schedulers configured and applied${NC}"
    else
        echo -e "${RED}Failed to apply udev rules${NC}"
        return 1
    fi
    
    sleep 2
    show_current_schedulers
}

show_current_schedulers() {
    echo -e "${BLUE}=== Current I/O Schedulers ===${NC}"

    echo -e "\n${GREEN}NVMe:${NC}"
    for dev in /sys/block/nvme*n*; do
        if [ -d "$dev" ] && [[ ! "$(basename $dev)" =~ p[0-9]+$ ]]; then
            name=$(basename $dev)
            sched=$(cat $dev/queue/scheduler 2>/dev/null | grep -o '\[.*\]' | tr -d '[]')
            nr=$(cat $dev/queue/nr_requests 2>/dev/null)
            ra=$(cat $dev/queue/read_ahead_kb 2>/dev/null)
            echo "  $name: $sched, nr_req=$nr, read_ahead=${ra}KB"
        fi
    done

    echo -e "\n${GREEN}SSDs:${NC}"
    for dev in /sys/block/sd*; do
        if [ -d "$dev" ] && [ "$(cat $dev/queue/rotational 2>/dev/null)" = "0" ]; then
            name=$(basename $dev)
            sched=$(cat $dev/queue/scheduler 2>/dev/null | grep -o '\[.*\]' | tr -d '[]')
            qd=$(cat $dev/device/queue_depth 2>/dev/null)
            ra=$(cat $dev/queue/read_ahead_kb 2>/dev/null)
            echo "  $name: $sched, queue_depth=$qd, read_ahead=${ra}KB"
        fi
    done

    echo -e "\n${GREEN}HDDs:${NC}"
    for dev in /sys/block/sd*; do
        if [ -d "$dev" ] && [ "$(cat $dev/queue/rotational 2>/dev/null)" = "1" ]; then
            name=$(basename $dev)
            sched=$(cat $dev/queue/scheduler 2>/dev/null | grep -o '\[.*\]' | tr -d '[]')
            ra=$(cat $dev/queue/read_ahead_kb 2>/dev/null)
            echo "  $name: $sched, read_ahead=${ra}KB"
        fi
    done
}

# ============================================================================
# PERFORMANCE TWEAKS (FIXED - RAM AWARE)
# ============================================================================

configure_performance_tweaks() {
    echo -e "${YELLOW}Applying performance tweaks...${NC}"
    
    local ram_gb=$(get_ram_gb)
    local ram_category=$(get_ram_category)
    local recommended_swappiness=$(get_recommended_swappiness)
    
    echo -e "${BLUE}System RAM: ${ram_gb}GB (Category: $ram_category)${NC}"
    echo -e "${BLUE}Recommended swappiness: $recommended_swappiness${NC}"
    
    # Check if config exists
    if [ -f /etc/sysctl.d/99-performance.conf ]; then
        echo -e "${YELLOW}Performance config already exists${NC}"
        current_swappiness=$(grep "vm.swappiness" /etc/sysctl.d/99-performance.conf 2>/dev/null | cut -d'=' -f2)
        echo -e "${BLUE}Current swappiness in config: ${current_swappiness:-not set}${NC}"
        
        read -p "Overwrite existing config? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Skipping performance tweaks${NC}"
            return 0
        fi
        # Backup existing config
        cp /etc/sysctl.d/99-performance.conf /etc/sysctl.d/99-performance.conf.bak.$(date +%Y%m%d_%H%M%S)
        echo -e "${GREEN}Backed up existing sysctl config${NC}"
    fi

    # Load tcp_bbr module if not loaded
    if ! lsmod | grep -q tcp_bbr; then
        echo -e "${YELLOW}Loading tcp_bbr module...${NC}"
        modprobe tcp_bbr 2>/dev/null || true
        echo "tcp_bbr" > /etc/modules-load.d/bbr.conf
    fi

    # RAM-based dirty ratios
    case $ram_category in
        low)
            dirty_ratio=10
            dirty_bg_ratio=5
            ;;
        medium)
            dirty_ratio=15
            dirty_bg_ratio=5
            ;;
        high)
            dirty_ratio=20
            dirty_bg_ratio=10
            ;;
    esac

    cat >/etc/sysctl.d/99-performance.conf <<EOF
# Performance tweaks for ${ram_gb}GB RAM system (category: $ram_category)
# Generated: $(date)

# Memory management - RAM aware
vm.swappiness=$recommended_swappiness
vm.vfs_cache_pressure=50
vm.dirty_ratio=$dirty_ratio
vm.dirty_background_ratio=$dirty_bg_ratio
vm.dirty_writeback_centisecs=1500
vm.dirty_expire_centisecs=3000
vm.min_free_kbytes=65536

# Network performance
net.core.netdev_max_backlog=16384
net.core.somaxconn=8192
net.core.rmem_default=1048576
net.core.rmem_max=16777216
net.core.wmem_default=1048576
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 1048576 2097152
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_congestion_control=bbr
net.core.default_qdisc=fq

# Filesystem
fs.file-max=2097152
fs.inotify.max_user_watches=524288
fs.aio-max-nr=1048576

# Scheduler
kernel.sched_autogroup_enabled=1
EOF

    if sysctl -p /etc/sysctl.d/99-performance.conf; then
        echo -e "${GREEN}Performance tweaks applied${NC}"
    else
        echo -e "${RED}Failed to apply some sysctl settings${NC}"
    fi

    # Verify critical settings
    echo -e "\n${BLUE}Verifying settings:${NC}"
    echo "  vm.swappiness = $(sysctl -n vm.swappiness)"
    echo "  tcp_congestion = $(sysctl -n net.ipv4.tcp_congestion_control)"
    echo "  scheduler_autogroup = $(sysctl -n kernel.sched_autogroup_enabled)"

    # Configure transparent hugepages via sysctl (NO rc.local!), beta
    echo -e "\n${YELLOW}Configure Transparent Hugepages?${NC}"
    echo "1) Always (can increase memory usage)"
    echo "2) Madvise (recommended - only when requested)"
    echo "3) Never (safest for low memory)"
    read -p "Choose [1-3, Enter to skip]: " thp_choice
    
    case $thp_choice in
        1) 
            # Use systemd service instead of rc.local, beta
            cat >/etc/systemd/system/thp-always.service <<'EOFTHP'
[Unit]
Description=Enable THP Always
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=basic.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo always > /sys/kernel/mm/transparent_hugepage/enabled"

[Install]
WantedBy=basic.target
EOFTHP
            systemctl daemon-reload
            systemctl enable thp-always.service
            echo always > /sys/kernel/mm/transparent_hugepage/enabled
            echo -e "${GREEN}THP set to 'always'${NC}"
            ;;
        2) 
            cat >/etc/systemd/system/thp-madvise.service <<'EOFTHP'
[Unit]
Description=Enable THP Madvise
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=basic.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo madvise > /sys/kernel/mm/transparent_hugepage/enabled"

[Install]
WantedBy=basic.target
EOFTHP
            systemctl daemon-reload
            systemctl enable thp-madvise.service
            echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
            echo -e "${GREEN}THP set to 'madvise' (recommended)${NC}"
            ;;
        3) 
            cat >/etc/systemd/system/thp-never.service <<'EOFTHP'
[Unit]
Description=Disable THP
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=basic.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"

[Install]
WantedBy=basic.target
EOFTHP
            systemctl daemon-reload
            systemctl enable thp-never.service
            echo never > /sys/kernel/mm/transparent_hugepage/enabled
            echo -e "${GREEN}THP disabled${NC}"
            ;;
        *) echo -e "${YELLOW}Skipping THP configuration${NC}" ;;
    esac

    # Preload - auto-detect SSD-only systems
    echo -e "\n${YELLOW}Preload configuration${NC}"
    if has_only_ssds; then
        echo -e "${BLUE}SSD-only system detected${NC}"
        echo -e "${YELLOW}Preload is NOT recommended for SSD-only systems${NC}"
        read -p "Install anyway? (y/N): " install_preload
    else
        echo -e "${BLUE}System has HDDs - preload may be beneficial${NC}"
        read -p "Install preload? (y/N): " install_preload
    fi
    
    if [[ "$install_preload" =~ ^[Yy]$ ]]; then
        detect_distro
        if [[ "$DISTRO" =~ (arch|manjaro|biglinux) ]]; then
            pacman -S --needed --noconfirm preload 2>/dev/null || true
            systemctl enable --now preload.service 2>/dev/null || true
        elif [[ "$DISTRO" =~ (debian|ubuntu|mint|lmde) ]]; then
            apt install -y preload 2>/dev/null || true
            systemctl enable --now preload.service 2>/dev/null || true
        fi
        echo -e "${GREEN}Preload installed${NC}"
    else
        echo -e "${BLUE}Skipping preload${NC}"
    fi
}

# ============================================================================
# FSTAB OPTIMIZATION (NEW)
# ============================================================================

optimize_fstab() {
    echo -e "${YELLOW}Optimize /etc/fstab commit values?${NC}"
    
    local ram_gb=$(get_ram_gb)
    local recommended_commit=$(get_recommended_commit)
    
    echo -e "${BLUE}System RAM: ${ram_gb}GB${NC}"
    echo -e "${BLUE}Recommended commit value: ${recommended_commit} seconds${NC}"
    echo ""
    echo "This will optimize ext4 filesystem commit intervals for better performance"
    echo "Current fstab will be backed up"
    
    read -p "Proceed? (y/N): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Skipping fstab optimization${NC}"
        return 0
    fi
    
    # Backup fstab
    cp /etc/fstab /etc/fstab.bak.$(date +%Y%m%d_%H%M%S)
    echo -e "${GREEN}Backed up /etc/fstab${NC}"
    
    echo -e "${YELLOW}Checking ext4 partitions...${NC}"
    
    # Find ext4 partitions that don't have commit set, beta
    local modified=0
    while IFS= read -r line; do
        if [[ "$line" =~ ^UUID.*ext4 ]] && [[ ! "$line" =~ commit= ]]; then
            echo -e "${BLUE}Found ext4 partition without commit:${NC}"
            echo "$line"
            read -p "Add commit=$recommended_commit to this partition? (y/N): " add_commit
            
            if [[ "$add_commit" =~ ^[Yy]$ ]]; then
                # Add commit to options, beta
                if [[ "$line" =~ (.*[[:space:]]ext4[[:space:]]+)([^[:space:]]+)([[:space:]]+.*) ]]; then
                    local before="${BASH_REMATCH[1]}"
                    local options="${BASH_REMATCH[2]}"
                    local after="${BASH_REMATCH[3]}"
                    local new_options="${options},commit=${recommended_commit}"
                    local new_line="${before}${new_options}${after}"
                    
                    # Replace in fstab, fingers crossed
                    sed -i "s|${line}|${new_line}|" /etc/fstab
                    modified=1
                    echo -e "${GREEN}Modified${NC}"
                fi
            fi
        fi
    done < /etc/fstab
    
    if [ $modified -eq 1 ]; then
        echo -e "${GREEN}fstab optimized${NC}"
        echo -e "${YELLOW}Reboot required to apply changes${NC}"
    else
        echo -e "${BLUE}No changes needed or no changes made${NC}"
    fi
}

# ============================================================================
# OTHER FUNCTIONS
# ============================================================================

set_cpu_governor() {
    echo -e "${YELLOW}Setting CPU governor...${NC}"

    if ! command -v cpupower &>/dev/null; then
        echo -e "${YELLOW}Installing cpupower...${NC}"
        if command -v pacman &>/dev/null; then
            pacman -S --needed --noconfirm cpupower
        elif command -v apt &>/dev/null; then
            apt install -y linux-cpupower
        elif command -v dnf &>/dev/null; then
            dnf install -y kernel-tools
        fi
    fi

    # Check available governors
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ]; then
        available=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
        echo -e "${BLUE}Available governors: $available${NC}"
        
        if [[ ! "$available" =~ "performance" ]]; then
            echo -e "${RED}Performance governor not available on this CPU${NC}"
            return 1
        fi
    fi

    if cpupower frequency-set -g performance; then
        echo -e "${GREEN}CPU governor set to performance${NC}"
    else
        echo -e "${RED}Failed to set CPU governor${NC}"
        return 1
    fi

    detect_distro
    if [[ "$DISTRO" =~ (arch|manjaro|biglinux) ]]; then
        systemctl enable cpupower.service
        mkdir -p /etc/default
        echo 'governor="performance"' >/etc/default/cpupower
    elif [[ "$DISTRO" =~ (debian|ubuntu|mint|lmde) ]]; then
        cat >/etc/systemd/system/cpupower.service <<'EOF'
[Unit]
Description=Set CPU governor to performance
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/cpupower frequency-set -g performance
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
        systemctl daemon-reload
        systemctl enable cpupower.service
    elif [[ "$DISTRO" =~ (fedora|rhel|centos) ]]; then
        systemctl enable cpupower.service
        mkdir -p /etc/sysconfig
        echo 'CPUPOWER_START_OPTS="frequency-set -g performance"' >/etc/sysconfig/cpupower
    fi

    # Verify
    current=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
    echo -e "${BLUE}Current governor: $current${NC}"
}

enable_trim_ssd() {
    echo -e "${YELLOW}Enabling TRIM...${NC}"
    
    if systemctl is-enabled fstrim.timer &>/dev/null; then
        echo -e "${BLUE}TRIM is already enabled${NC}"
        systemctl status fstrim.timer --no-pager | head -5
        return 0
    fi
    
    if systemctl enable fstrim.timer && systemctl start fstrim.timer; then
        echo -e "${GREEN}TRIM enabled (weekly)${NC}"
        systemctl status fstrim.timer --no-pager | head -5
    else
        echo -e "${RED}Failed to enable TRIM${NC}"
        return 1
    fi
}

show_kernel_info() {
    echo -e "${BLUE}=== System Info ===${NC}"
    detect_distro
    local ram_gb=$(get_ram_gb)
    local ram_category=$(get_ram_category)
    local current_swappiness=$(sysctl -n vm.swappiness 2>/dev/null || echo "unknown")
    local zswap_status="disabled"
    check_zswap_enabled && zswap_status="enabled"
    
    echo " Distribution    : $DISTRO"
    echo " Current kernel  : $(get_current_kernel)"
    echo " User            : $(get_real_user)"
    echo " RAM             : ${ram_gb}GB ($ram_category)"
    echo " Swappiness      : $current_swappiness"
    echo " zswap           : $zswap_status"
    echo ""
    list_installed_kernels
}

install_performance_tools() {
    echo -e "${YELLOW}Installing tools...${NC}"
    detect_distro

    if [[ "$DISTRO" =~ (arch|manjaro|biglinux) ]]; then
        if pacman -S --needed --noconfirm iotop htop nvtop sysstat cpupower lm_sensors; then
            echo -e "${GREEN}Tools installed${NC}"
        else
            echo -e "${RED}Failed to install some tools${NC}"
        fi
    elif [[ "$DISTRO" =~ (debian|ubuntu|mint|lmde) ]]; then
        if apt install -y iotop htop nvtop sysstat linux-cpupower lm-sensors; then
            echo -e "${GREEN}Tools installed${NC}"
        else
            echo -e "${RED}Failed to install some tools${NC}"
        fi
    elif [[ "$DISTRO" =~ (fedora|rhel|centos) ]]; then
        if dnf install -y iotop htop sysstat kernel-tools lm_sensors; then
            echo -e "${GREEN}Tools installed${NC}"
        else
            echo -e "${RED}Failed to install some tools${NC}"
        fi
    fi
}

rebuild_nvidia() {
    if ! lspci | grep -i nvidia &>/dev/null; then
        echo -e "${YELLOW}No NVIDIA GPU detected${NC}"
        return
    fi

    echo -e "${YELLOW}Configuring NVIDIA...${NC}"
    detect_distro

    if [[ "$DISTRO" =~ (arch|manjaro|biglinux) ]]; then
        if pacman -Q nvidia-dkms &>/dev/null; then
            if mkinitcpio -P; then
                echo -e "${GREEN}NVIDIA modules rebuilt${NC}"
            else
                echo -e "${RED}Failed to rebuild initramfs${NC}"
                return 1
            fi
            return
        fi

        read -p "Install nvidia-dkms? (y/n): " confirm
        if [ "$confirm" = "y" ]; then
            pacman -R --noconfirm nvidia nvidia-utils 2>/dev/null || true
            pacman -R --noconfirm $(pacman -Q | grep -E "linux[0-9]+-nvidia" | awk '{print $1}') 2>/dev/null || true
            if pacman -S --needed --noconfirm nvidia-dkms nvidia-utils; then
                mkinitcpio -P
                echo -e "${GREEN}NVIDIA DKMS installed${NC}"
            else
                echo -e "${RED}Failed to install NVIDIA DKMS${NC}"
                return 1
            fi
        fi
    elif [[ "$DISTRO" =~ (debian|ubuntu|mint|lmde) ]]; then
        apt install -y nvidia-kernel-dkms
    elif [[ "$DISTRO" =~ (fedora|rhel|centos) ]]; then
        dnf install -y akmod-nvidia
        akmods --force
    fi

    echo -e "${GREEN}NVIDIA configured${NC}"
}

update_bootloader() {
    echo -e "${YELLOW}Updating bootloader...${NC}"

    if command -v grub-mkconfig &>/dev/null; then
        if grub-mkconfig -o /boot/grub/grub.cfg; then
            echo -e "${GREEN}GRUB updated${NC}"
        else
            echo -e "${RED}Failed to update GRUB${NC}"
        fi
    elif command -v grub2-mkconfig &>/dev/null; then
        if grub2-mkconfig -o /boot/grub2/grub.cfg; then
            echo -e "${GREEN}GRUB2 updated${NC}"
        else
            echo -e "${RED}Failed to update GRUB2${NC}"
        fi
    elif command -v update-grub &>/dev/null; then
        if update-grub; then
            echo -e "${GREEN}GRUB updated${NC}"
        else
            echo -e "${RED}Failed to update GRUB${NC}"
        fi
    fi

    [ -d /boot/loader ] && bootctl update 2>/dev/null || true
}

rollback_config() {
    echo -e "${YELLOW}Rollback Configuration${NC}"
    echo -e "${BLUE}=======================${NC}\n"
    
    echo "Available backups:"
    echo ""
    echo "Sysctl configs:"
    ls -1 /etc/sysctl.d/99-performance.conf.bak.* 2>/dev/null || echo "  None"
    echo ""
    echo "I/O scheduler rules:"
    ls -1 /etc/udev/rules.d/60-ioschedulers.rules.bak.* 2>/dev/null || echo "  None"
    echo ""
    echo "fstab backups:"
    ls -1 /etc/fstab.bak.* 2>/dev/null || echo "  None"
    echo ""
    
    read -p "Restore from backup? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        return
    fi
    
    # Restore sysctl
    latest_sysctl=$(ls -t /etc/sysctl.d/99-performance.conf.bak.* 2>/dev/null | head -1)
    if [ -n "$latest_sysctl" ]; then
        cp "$latest_sysctl" /etc/sysctl.d/99-performance.conf
        sysctl -p /etc/sysctl.d/99-performance.conf
        echo -e "${GREEN}Restored sysctl config${NC}"
    fi
    
    # Restore udev rules
    latest_udev=$(ls -t /etc/udev/rules.d/60-ioschedulers.rules.bak.* 2>/dev/null | head -1)
    if [ -n "$latest_udev" ]; then
        cp "$latest_udev" /etc/udev/rules.d/60-ioschedulers.rules
        udevadm control --reload-rules
        udevadm trigger --subsystem-match=block
        echo -e "${GREEN}Restored I/O scheduler rules${NC}"
    fi
    
    # Restore fstab
    latest_fstab=$(ls -t /etc/fstab.bak.* 2>/dev/null | head -1)
    if [ -n "$latest_fstab" ]; then
        read -p "Restore fstab? (requires reboot) (y/N): " fstab_confirm
        if [[ "$fstab_confirm" =~ ^[Yy]$ ]]; then
            cp "$latest_fstab" /etc/fstab
            echo -e "${GREEN}Restored fstab${NC}"
        fi
    fi
    
    echo -e "${GREEN}Rollback complete${NC}"
}

# ============================================================================
# MAIN MENU
# ============================================================================

main_menu() {
    while true; do
        clear
        print_header
        show_kernel_info
        echo ""
        echo -e "${GREEN}Menu:${NC}"
        echo "1)  Install XanMod kernel"
        echo "2)  Install Zen kernel"
        echo "3)  Install Liquorix kernel"
        echo "4)  Remove kernel"
        echo "5)  Configure I/O scheduler"
        echo "6)  Show I/O schedulers"
        echo "7)  Apply performance tweaks (RAM-aware)"
        echo "8)  Optimize fstab commit values"
        echo "9)  Set CPU governor"
        echo "10) Enable SSD TRIM"
        echo "11) Install monitoring tools"
        echo "12) Rebuild NVIDIA"
        echo "13) Update bootloader"
        echo "14) Rollback configuration"
        echo "15) Exit"
        echo ""
        read -p "Choose [1-15]: " option

        case $option in
            1) install_xanmod ;;
            2) install_zen ;;
            3) install_liquorix ;;
            4) remove_kernel ;;
            5) configure_io_scheduler_comprehensive ;;
            6) show_current_schedulers ;;
            7) configure_performance_tweaks ;;
            8) optimize_fstab ;;
            9) set_cpu_governor ;;
            10) enable_trim_ssd ;;
            11) install_performance_tools ;;
            12) rebuild_nvidia ;;
            13) update_bootloader ;;
            14) rollback_config ;;
            15) echo "Exiting..."; exit 0 ;;
            *) echo -e "${RED}Invalid${NC}" ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

check_root
detect_distro
clear
main_menu
