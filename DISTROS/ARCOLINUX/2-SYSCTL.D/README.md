# Arch (BigLinux, Manjaro)

#

## Custom `kernel` parameters for Biglinux 
- (Part A)

```bash
sudo nano /usr/lib/sysctl.d/50-default.conf
```
ADD:
```bash
# Use kernel.sysrq = 1 to allow all keys.
# See https://docs.kernel.org/admin-guide/sysrq.html for a list
# of values and keys.
kernel.sysrq = 16

# Append the PID to the core filename
kernel.core_uses_pid = 1

# Source route verification
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.*.rp_filter = 2
-net.ipv4.conf.all.rp_filter

# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.*.accept_source_route = 0
-net.ipv4.conf.all.accept_source_route

# Promote secondary addresses when the primary address is removed
net.ipv4.conf.default.promote_secondaries = 1
net.ipv4.conf.*.promote_secondaries = 1
-net.ipv4.conf.all.promote_secondaries

# ping(8) without CAP_NET_ADMIN and CAP_NET_RAW
# The upper limit is set to 2^31-1. Values greater than that get rejected by
# the kernel because of this definition in linux/include/net/ping.h:
#   #define GID_T_MAX (((gid_t)~0U) >> 1)
# That's not so bad because values between 2^31 and 2^32-1 are reserved on
# systemd-based systems anyway: https://systemd.io/UIDS-GIDS#summary
-net.ipv4.ping_group_range = 0 2147483647

# Fair Queue CoDel packet scheduler to fight bufferbloat
#net.core.default_qdisc = fq_codel
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = westwood 

# Enable hard and soft link protection
fs.protected_hardlinks = 1
fs.protected_symlinks = 1

# Enable regular file and FIFO protection
fs.protected_regular = 1
fs.protected_fifos = 1

# Disable NMI watchdog: This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
kernel.nmi_watchdog = 0

# Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
kernel.unprivileged_userns_clone=1

# To hide any kernel messages from the console
kernel.printk = 3 3 3 3

# the key combination of Alt+SysRq+<b/e/f/s/u> will result in Magic SysRQ invocation
kernel.sysrq=1

# Libvirt uses a default of 1M requests to allow 8k disks, with at most
# 64M of kernel memory if all disks hit an aio request at the same time.
fs.aio-max-nr = 1048576

# Bump the numeric PID range to make PID collisions less likely.
# 2^22 and 2^15 is possible maximum of 64bit and 32bit kernels respectively.
kernel.pid_max = 4194304

kernel.sched_cfs_bandwidth_slice_us = 3000

#  This is required due to some games being unable to reuse their TCP ports
#  if they're killed and restarted quickly - the default timeout is too large.

net.ipv4.tcp_fin_timeout = 5
# Raise inotify resource limits
fs.inotify.max_user_instances = 1024
fs.inotify.max_user_watches = 524288

# Increase the default vm.max_map_count value
vm.max_map_count=1048576
```

## Custom `kernel` parameters for Biglinux 
- (Part B)


```bash
sudo nano /etc/sysctl.d/11-network-tweaks.conf
```

ADD:
```bash
### TUNING NETWORK PERFORMANCE ###
# Tolga Erok
#        
# net.core.default_qdisc = fq_codel                                                  # Set the default queuing discipline (qdisc) for the kernel's network scheduler to "cake"
net.core.rmem_max = 1073741824                                          # Set the maximum socket receive buffer size for all network devices to 1073741824 bytes
net.core.wmem_max = 1073741824                                        # Set the maximum socket send buffer size for all network devices to 1073741824 bytes
net.ipv4.tcp_congestion_control = westwood                        # Set the TCP congestion control algorithm to "westwood"
net.ipv4.tcp_mem = 65536 1048576 16777216                      # Set TCP memory allocation limits
net.ipv4.tcp_mtu_probing = 1                                                    # Enable Path MTU Discovery
net.ipv4.tcp_notsent_lowat = 16384                                         # Minimum amount of data in the send queue below which TCP will send more data
net.ipv4.tcp_retries2 = 8                                                             # Set the number of times TCP retransmits unacknowledged data segments for the second SYN on a connection initiation to 8
net.ipv4.tcp_rmem = 4096 87380 1073741824                      # Set TCP read memory allocation for network sockets
net.ipv4.tcp_rmem = 8192 1048576 16777216                      # TCP read memory allocation for network sockets
net.ipv4.tcp_sack = 1                                                                   # Enable Selective Acknowledgment (SACK)
net.ipv4.tcp_slow_start_after_idle = 0                                      # Disable TCP slow start after idle
net.ipv4.tcp_tw_reuse = 1                                                           # Increase the tcp-time-wait buckets pool size to prevent simple DOS attacks
net.ipv4.tcp_window_scaling = 1                                               # Enable TCP window scaling
net.ipv4.tcp_wmem = 4096 87380 1073741824                     # Set TCP write memory allocation for network sockets
net.ipv4.tcp_wmem = 8192 1048576 16777216                     # TCP write memory allocation for network sockets
net.ipv4.udp_mem = 65536 1048576 16777216                    # Set UDP memory allocation limits
net.ipv4.udp_rmem_min = 16384                                             # Increase the read-buffer space allocatable for UDP
net.ipv4.udp_wmem_min = 16384                                           # Increase the write-buffer-space allocatable for UDP


```


Then:
```bash
sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system
```

#

## Change `Fair Queue CoDel packet` scheduler to fight bufferbloat from `fq_codel` to `cake`
- LOCATION: /usr/lib/sysctl.d/50-default.conf
- If this location dosnt exist then
`sudo nano /etc/sysctl.d/13-extra-tweak.conf`

ADD:

```bash
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = westwood
```

Then:
```bash
sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system
```

Then:
```bash
tc qdisc replace dev wlp3s0 root cake bandwidth 1Gbit
```

Then:
```bash
sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system
```
#
