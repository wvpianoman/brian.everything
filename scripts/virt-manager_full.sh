#!/usr/bin/env bash
# tolga - virt-manager complete setup for brian 
# version: 1.0
# 20 Jan 26

# set -e

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;34m'
nc='\033[0m'

echo -e "${blue}[*] installing virtualization packages${nc}"
sudo dnf install -y @virtualization virt-manager virt-viewer libvirt qemu-kvm bridge-utils virt-top libguestfs-tools virt-install

echo -e "${blue}[*] installing guest tools${nc}"
sudo dnf install -y spice-vdagent qemu-guest-agent spice-webdavd

echo -e "${blue}[*] configuring selinux${nc}"
sudo setsebool -P virt_use_nfs 1
sudo setsebool -P virt_use_samba 1
sudo semanage fcontext -a -t virt_image_t "/var/lib/libvirt/images(/.*)?" 2>/dev/null || true
sudo restorecon -Rv /var/lib/libvirt/images/

echo -e "${blue}[*] configuring firewall${nc}"
sudo firewall-cmd --permanent --add-service=libvirt
sudo firewall-cmd --permanent --add-port=5900-5999/tcp
sudo firewall-cmd --permanent --zone=libvirt --set-target=ACCEPT
sudo firewall-cmd --reload

echo -e "${blue}[*] enabling libvirtd service${nc}"
sudo systemctl enable --now libvirtd

echo -e "${blue}[*] adding user to libvirt group${nc}"
sudo usermod -aG libvirt $USER

echo -e "${blue}[*] configuring default network${nc}"
sudo virsh net-autostart default
sudo virsh net-start default 2>/dev/null || true

echo -e "${blue}[*] setting permissions${nc}"
sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

echo -e "${blue}[*] enabling nested virtualization${nc}"
echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm.conf
echo "options kvm_amd nested=1" | sudo tee -a /etc/modprobe.d/kvm.conf

echo -e "${blue}[*] restarting libvirtd${nc}"
sudo systemctl restart libvirtd

echo -e "${green}[✓] complete - logout/login or run: newgrp libvirt${nc}"
echo -e "${yellow}[!] selinux: enforcing with virt policies enabled${nc}"
echo -e "${yellow}[!] firewall: libvirt service + vnc ports 5900-5999 open${nc}"