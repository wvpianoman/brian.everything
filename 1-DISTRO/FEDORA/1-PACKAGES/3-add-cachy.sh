# Make sure your CPU supports the higher target x86-64 architectures. 
# You need minimum x86-64-v3 for all kernels, except kernel-cachyos-lts 
# and kernel-cachyos-server that only require x86-64-v2.

# https://github.com/CachyOS/copr-linux-cachyos?tab=readme-ov-file

# install grubby
sudo dnf install grubby -y

# check cpu architecture
/lib64/ld-linux-x86-64.so.2 --help | grep "(supported, searched)"
(if output is x86-64-v3 proceed
else if output is NOT x86-64-v3  stop)


# Next, enable the COPR repository hosting the kernels.
sudo dnf copr enable bieszczaders/kernel-cachyos # For GCC built kernels
#sudo dnf copr enable bieszczaders/kernel-cachyos-lto # For LLVM-ThinLTO build kernels

# Now you can install the kernels
sudo dnf install kernel-cachyos kernel-cachyos-devel-matched # For GCC built kernels
#sudo dnf install kernel-cachyos-lto kernel-cachyos-lto-devel-matched # For LLVM-ThinLTO built kernels

## LTS Kernel
#sudo dnf install kernel-cachyos-lts kernel-cachyos-lts-devel-matched
#sudo dnf install kernel-cachyos-lts-lto kernel-cachyos-lts-lto-devel-matched

## Real-time Kernel
#sudo dnf install kernel-cachyos-rt kernel-cachyos-rt-devel-matched

## Server Kernel
#sudo dnf install kernel-cachyos-server kernel-cachyos-server-devel-matched

# 🚨 Lastly if you use SELinux, you need to enable the necessary policy to be able to load kernel modules.
sudo setsebool -P domain_kernel_load_modules on

# By default Fedora will use the kernel that was most recently updated by dnf which will lead to 
# inconsistent behaviour if you have multiple kernels installed, but we can tell Fedora to always 
# boot with the latest CachyOS kernel by running a script after kernel updates.
sudo mkdir /etc/kernel/postinst.d
sudo nano cp 99-default /etc/kernel/postinst.d/


# Make root the owner and make the script executable:
sudo chown root:root /etc/kernel/postinst.d/99-default ; sudo chmod u+rx /etc/kernel/postinst.d/99-default

# Enable the COPR repository hosting addon packages.
sudo dnf copr enable bieszczaders/kernel-cachyos-addons

#Now you can install the addon packages.   CachyOS-Settings
sudo dnf swap zram-generator-defaults cachyos-settings
sudo dracut -f

# scx-manager, scx-scheds and scx-tools
sudo dnf install scx-scheds-git scx-tools-git scx-manager
