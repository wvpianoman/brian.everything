
Getting Started
1. Update your system:
1. Updating System with Octopi:

Octopi is a graphical package manager for Arch-based distributions that provides a convenient way to manage packages and updates. To update your system with Octopi, follow these steps:

    Launch Octopi from the application menu
    In the main window, click on the “System Upgrade” button
    Octopi will check for available updates and present them to you.
    To proceed with the update, click the “Apply” button.
    Octopi will download and install the updates.
    It is advised to reboot your computer after a big update (especially if the kernel version changes).

2. Updating System with Pacman:

    Open a terminal emulator (or press ctrl + alt + t - mod + return in Cachy’s WMs)
    Run the following command to update the system:

Terminal window

sudo pacman -Syu

That’s it! Now your system is up-to-date and ready for use.
2. Enable Firewall protection:

To enable firewall protection, follow these steps:

    1  # Install the ufw (Uncomplicated Firewall) package using Pacman:
sudo pacman -S ufw

    2  # Enable the firewall with this command:
sudo ufw enable

    3  By default, ufw allows all incoming and outgoing traffic, you can add specific rules to the firewall to block or allow specific connections.
Terminal window

# For example:
sudo ufw allow ssh
    4   # To check the status of the firewall, use the following command:
sudo ufw status verbose

# Note

Be careful when configuring firewall rules, as improperly configured rules can lock you out of your own system.

3. Install apps:

CachyOS comes pre-installed with many useful apps, but you may want to install additional ones to match your workflow. Here are some popular apps you may consider installing:

    GIMP (image processor)
    VLC (media player)
    Stacer (system monitor)
    Skype, Telegram, Discord, Signal (messenger apps)
    Steam (for gaming)
    Spotify (music)
    MailSpring (email client)
    Super Productivity (to-do list manager and Pomodoro timer)
    Visual Studio Code (code editor)
    Blender (3D software)
    Krita (digital painting)

You can easily install these apps using the command line. For example:
Terminal window

paru -S vlc mailspring spotify gimp

If you get an error message, try using a different command or check the name of the app in the database.
4. Enable global menu:

For some apps like Visual Studio Code, the global menu may not work or may be attached to the parent app instead of the panel.
Terminal window

# To enable global menu support, run the command and restart the app.
sudo pacman -S appmenu-gtk-module libdbusmenu-glib

5. Enable trim operations on SSD/NVME:

If you have an SSD or NVME, it would be highly recommended to enable fstrim to ensure your SSD or NVME stays in good working condition.
Terminal window

sudo systemctl enable --now fstrim.timer

Some filesystems such as F2FS (continuous TRIM) have a built-in trim operation, meaning that fstrim is not needed.
6. Set up Bluetooth headphones:

To auto-connect your headphones, follow the steps in the Arch wiki guide: https://wiki.archlinux.org/title/bluetooth_headset#Headset_via_Bluez5/PulseAudio. If Pulseaudio doesn’t work, you may need to manually reconnect the headphones each time you restart your computer. 



General System Tweaks
General System Tweaks
1. Reduce Swappiness and vfs_cache_pressure

The system’s swap space preference can be adjusted using the vm.swappiness sysctl parameter. The default value is “30”, which means that the kernel will avoid swapping processes to disk as much as possible and will instead try to keep as much data as possible in memory. A lower swappiness value generally leads to improved performance but may lead to decreased stability if the system runs out of memory.

The vm.vfs_cache_pressure is a kernel parameter that sets the tendency of the kernel to reclaim inode and dentry cache. By default, it is set to “100” and a lower value means the kernel will tend to cache more inode and dentry information in memory. To improve performance, you can try to lower the value of vm.vfs_cache_pressure to improve file system performance by having more file system metadata cached in memory.

Both values can be changed in the /etc/sysctl.d/99-cachyos-settings.conf file.
2. Zram or Zswap tweaking

Zswap is a kernel feature that caches swap pages in RAM, compressing them before storing. It improves performance by reducing disk I/O when the system needs to swap. Zram is a RAM-based swap device that does not require a backing swap device.

For zswap, use the following recommended configurations:

Note

Run as root user
Terminal window

echo zstd > /sys/module/zswap/parameters/compressor
echo 10 > /sys/module/zswap/parameters/max_pool_percent

To make the changes persist, add zswap.compressor=zstd zswap.max_pool_percent=10 to your bootloader’s kernel command line options

For SSDs, set the page-cluster value to 1 in /etc/sysctl.d/99-cachyos-settings.conf. For HDDs, set it to 2.
3. CPU Mitigations for retbleed

A public speculative execution attack exploiting return instructions (retbleed) was revealed in July 2022. The kernel has fixed this, but it results in a significant performance overhead (14-39%).

The following CPU’s are affected:

    AMD: Zen 1, Zen 1+, Zen 2
    Intel: 6th to 8th Generation, Skylake, Caby Lake, Coffee Lake

Check which mitigations your CPU is affected by: grep . /sys/devices/system/cpu/vulnerabilities/*
Disabling mitigations

While disabling the mitigations increases performance, it also introduces security risks.

Caution

Do so at your own risk.

Add the following to your kernel command line: retbleed=off or to disable all mitigations: mitigations=off

Edit the appropriate file to persist the changes:

    GRUB: /etc/default/grub
    systemd boot: /etc/sdboot-manage.conf

Caution

Disabling these mitigations poses a security risk to your system.

For more information:

    https://www.phoronix.com/review/retbleed-benchmark
    https://www.phoronix.com/review/xeon-skylake-retbleed

Downfall

Downfall is characterized as a vulnerability due to a memory optimization feature that unintentionally reveals internal hardware registers to software. With Downfall, untrusted software can access data stored by other programs that typically should be off-limits: the AVX GATHER instruction can leak the contents of the internal vector register file during speculative execution. Downfall was discovered by security researcher Daniel Moghimi of Google. Moghimi has written demo code for Downfall to show 128-bit and 256-bit AES keys being stolen from other users on the local system as well as the ability to steal arbitrary data from the Linux kernel.

This affects following CPU’s:

    Skylake
    Tiger Lake
    Ice Lake

Disabling Downfall

Add gather_data_sampling=off to your kernel cmdline options. mitigations=off will also disable downfall.
4. AMD P-State Driver

For improved performance and power efficiency, you can enable the AMD P-State EPP driver. The default AMD P-State driver may not provide the same benefits as the acpi-cpufreq driver.

Add one of the following options to your kernel command line:

    AMD P-State: amd_pstate=passive
    AMD P-State-GUIDED: amd_pstate=guided
    AMD P-State EPP: amd_pstate=active

You can switch between modes at runtime to test the options:

    echo active | sudo tee /sys/devices/system/cpu/amd_pstate/status - Autonomous mode, platform considers only the values set for Minimum performance, Maximum performance, and Energy Performance Preference.

    echo guided | sudo tee /sys/devices/system/cpu/amd_pstate/status - Guided-autonomous mode, platform sets operating performance level according to the current workload and within limits set by the OS through minimum and maximum performance registers.

    echo passive | sudo tee /sys/devices/system/cpu/amd_pstate/status - Non-autonomous mode, platform gets desired performance level from OS directly through Desired Performance Register.

For more information:

    https://lore.kernel.org/lkml/20221110175847.3098728-1-Perry.Yuan@amd.com/
    https://lore.kernel.org/lkml/20230119115017.10188-1-wyes.karny@amd.com/

5. Using AMD P-State EPP

To use the P-State EPP, there are two CPU frequency scaling governors available: powersave and performance. It is recommended to use the powersave governor and set a preference.

    Set powersave governor: sudo cpupower frequency-set -g powersave
    Set performance governor: sudo cpupower frequency-set -g performance

To set a preference, run the following command with the desired preference:

echo power | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

Available preferences: performance, power, balance_power, balance_performance

Benchmarks for each preference can be found here: https://lore.kernel.org/lkml/20221219064042.661122-1-perry.yuan@amd.com/
6. AMD P-State Preferred Core Handling

AMD Pstate driver will provide an initial core ordering at boot time. It relies on the CPPC interface to communicate the core ranking to the operating system and scheduler to make sure that OS is choosing the cores with highest performance firstly for scheduling the process. When AMD Pstate driver receives a message with the highest performance change, it will update the core ranking.

This can result into a better performance and process handling. More information here: https://lore.kernel.org/linux-pm/20230808081001.2215240-1-li.meng@amd.com/

The AMD P-State Preferred Core Handling is now enabled by default.

You can use the following command to check if your CPU supports it:
Terminal window

cat /sys/devices/system/cpu/amd-pstate/prefcore

or
Terminal window

cat /sys/devices/system/cpu/amd-pstate/status

to see if it is enabled
7. Disabling Split Lock Mitigate

In some cases, split lock mitigate can slow down performance in applications and games. A patch is available to disable it via sysctl.

    Disable split lock mitigate: sudo sysctl kernel.split_lock_mitigate=0
    Enable split lock mitigate: sudo sysctl kernel.split_lock_mitigate=1

To set the value permanently, add the following line to /etc/sysctl.d/99-splitlock.conf:

kernel.split_lock_mitigate=0

For more information on split lock, see:

    https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming
    https://github.com/doitsujin/dxvk/issues/2938




net.core.somaxconn = 8192
net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_syncookies = 1
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr2
