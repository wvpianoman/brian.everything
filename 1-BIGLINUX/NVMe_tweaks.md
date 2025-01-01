By default Linux distros are unoptimized in terms of I/O latency. So, here are some tips to improve that.

Most apps still don't do multi-threaded I/O access, so it's a thread-per-app which makes per-app speed always bottlenecked by single-core CPU performance (that's not even accounting for stuttering on contention between multiple processes), so even with NVMe capable of 3-6 GB/s of linear read you may get only 1-2 GB/s with ideal settings and 50-150/100-400 MB/s of un/buffered random read (what apps actually use in real life) is the best you can hope for.

All writes are heavily buffered on 3 layers (OS' RAM cache, device's RAM cache, device's SLC-like on-NAND cache), so it's difficult to get real or stable numbers but writes are largelly irrelevant for system's responsiveness, so they may be sacrificed for better random reads.

The performance can be checked by:
* `fio --name=read --readonly --rw={read/randread} --ioengine=libaio --iodepth={jobs_per_each_worker's_command} --bs={4k/2M} --direct={0/1} --numjobs=<number_of_parallel_workers> --runtime={10/30/60} --group_reporting --filename=/dev/nvme<device>` - to simulate an optimized app;
* `dd_rescue /dev/nvme<device> /dev/null -b {4k/2M} {-d}` - to simulate a stupid app.

---
Appropriate settings are changed in appropriate places, such as:
* `/etc/tuned/<custom-profile>/tuned.conf`:
```ini
[main]
summary=Custom offshoot from latency-performance profile
#include=latency-performance

[variables]
# 'zswap.enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=25' to enable transparently compressed swap which is viable on NVMe but kernel may bug-out and hang on untested regressions
# zswap is cache for disk swap, zram should be used for actual compressed RAM-based swap: https://linuxreviews.org/Comparison_of_Compression_Algorithms
# is 'nohz_full=[core_range]' still required even with NO_HZ_FULL=y, as kernel docs said ?
# 'threadirqs' also may be still be required despite IRQ_FORCED_THREADING=y
# on desktop watchdog is only good for triggering accidentally and doing hot reset that corrupts all your data, so disable it with 'acpi_no_watchdog nmi_watchdog=0 nowatchdog'
# defraging and such on hugepages can lead to random latency spikes, so it can be disabled with 'hugetlb_free_vmemmap=off'
# 'autogroup' completely breaks nice/chrt priorities, so always disable it with 'noautogroup' !
# runtime numa_balancing options seems to have been removed and on desktop it can lead to detrimental thread migration, so disable it with 'numa_balancing=disable'
cmdline_main=sysrq_always_enabled noautogroup numa_balancing=disable gbpages transparent_hugepage=always nmi_watchdog=0 x2apic_phys
# experiment with RCU setup. timing values are "jiffie"-based values, so they should be adjusted for HZ-rate of the kernel
# see https://lwn.net/Articles/777214/ and https://lkml.org/lkml/2020/9/17/1243 also https://docs.kernel.org/RCU/stallwarn.html
cmdline_rcu=rcu_nocbs=all rcutree.kthread_prio=50 rcutree.use_softirq=0 rcutree.rcu_kick_kthreads=1 rcupdate.rcu_expedited=1 rcutree.blimit=8 rcutree.qlowmark=33 rcutree.qhimark=999 rcutree.jiffies_till_first_fqs=0 rcutree.jiffies_till_next_fqs=1 rcutree.jiffies_till_sched_qs=33 rcutree.rcu_idle_gp_delay=10 rcupdate.rcu_task_ipi_delay=4 rcutree.rcu_idle_lazy_gp_delay=3333
# also use some "RAM cache" for TLB with 'swiotlb=<slabs>' where slabs are 2KB in size for some reason, so 8192=16MB, 131072=256MB, 524288=1GB
cmdline_io=swiotlb=8192 iommu=noagp,nofullflush,memaper=3,merge amd_iommu=pgtbl_v2 intel-ishtp.ishtp_use_dma=1 ioatdma.ioat_pending_level=4 ioatdma.completion_timeout=999 ioatdma.idle_timeout=10000 idxd.sva=1 idxd.tc_override=1
# PCI[e] optimizations: 'pci=ecrc=on,ioapicreroute,assign-busses,check_enable_amd_mmconf,realloc,pcie_bus_perf,pcie_scan_all pcie_ports=auto/native'
# be wary of a lot of stuff, such as setting `pcie_ports=native` (as opposed to =auto) without `pci=noaer`
# or influence if pcie_bus_X settings on PCIe payload, which can be checked with `dmesg | grep -i Payload`
# ASPM may cause hanging under broken BIOS/EFI but disabling it will waste a lot of power with NVMe or GPU, also being "disabled" in BIOS may be a lie, therefore 'pcie_aspm=force pcie_aspm.policy=performance pcie_port_pm=off' may be needed to make sure
# but it is critical for NVMes for them not to cook themselves, so 'pcie_aspm.policy=powersave' is advices where it works
cmdline_pci=pcie_ports=native pci=noaer,ecrc=on,ioapicreroute,assign-busses,check_enable_amd_mmconf,realloc,pcie_bus_perf pcie_aspm.policy=powersave
# see https://github.com/torvalds/linux/commit/25de5718356e264820625600a9edca1df5ff26f8 - kernel was made to be more aggressive in downing frequency which is bad for latency-critical tasks
# https://bugzilla.redhat.com/show_bug.cgi?id=463285#c12 - 2 is default, 1 may give much better powersaving and 3 - better latency guarantees
# hacked BIOS for locked Intel CPUs may contain microcode that unlocks some higher performance states but that may require disabling OS microcode override with 'dis_ucode_ldr'
cmdline_power=processor.ignore_ppc=1 processor.ignore_tpc=1 processor.latency_factor=3 processor.max_cstate=7 intel_pstate=percpu_perf_limits,force intel_idle.use_acpi=1
# threaded interrrupts of 'nvme.use_threaded_interrupts=1' supposed to be better for performance and latency but they may fail miserably instead
# high nvme.io_queue_depth HW max is supposed to be 65535 but bigger numbers may increase NVMe I/O latency (and throughput ?)
# however, since kernel 5.14.3 nvme.io_queue_depth=65535 hangs at boot, it seems it was limited to 4095: https://lists.infradead.org/pipermail/linux-nvme/2014-July/001064.html and https://lore.kernel.org/all/31c4dc69-5d10-cc6a-4295-e42bbc0993d0@protonmail.com/
# see https://docs.microsoft.com/en-us/answers/questions/71713/a-good-queue-length-figure-for-premium-ssd.html for discerning optimal depth and nr_requests
# poll-based nvme access can only be enabled on boot-time BUT you HAVE to guess correct amount of queues for your specific device or it will silently fail, see `dmesg | grep -e nvme.*queues` or try something small like 'nvme.poll_queues=4 nvme.write_queues=2' by default
# See https://lists.openwrt.org/pipermail/linux-nvme/2017-July/011956.html and 'NVM Express 1.3d, Section 4.4 ("Scatter Gather List (SGL)")'
# nvme.sgl_threshold=1 should enable "Scatter-Gather List" on all I/O, 4096 - over 4KB, 65536 - over 64KB and 2097152 - over 2MB that is x86_64's hugepage size, nvme_core.streams is disabled by default, nvme_core.default_ps_max_latency_us=5500 disables deepest power-saving mode
# 'scsi_mod.scan=async' will cause changing letter-based device names for SATA devices and other weirness but you should not rely on them anyway, it should speed up boot
cmdline_storage=scsi_mod.scan=async nvme.use_threaded_interrupts=1 nvme.use_cmb_sqes=1 nvme.io_queue_depth=257 nvme.max_host_mem_size_mb=3072 nvme.poll_queues=8 nvme.write_queues=4 nvme.sgl_threshold=2097153 nvme_core.streams=1 nvme_core.admin_timeout=900 nvme_core.io_timeout=4294967295 nvme_core.shutdown_timeout=60
# MSI-capable NVMe running on old Intel system may result in boot failure "INTR-REMAP:[fault reason 38]" (https://bugs.launchpad.net/ubuntu/+source/linux/+bug/605686), workaround is 'intremap=nosid'
# amdgpu tends to completely shit itself on init on some systems when 64-bit PCIe adressing (AKA "above 4GB decoding") is enabled and "host bridge windows from ACPI" are "used" in PCI[e], so 'pci=nocrs' needs to be added
# amdgpu's "new output framework" shits the bed in pure UEFI video mode by permanently disabling the output port that was used by UEFI, so disable it by 'amdgpu.dc=0'
# 'efi=runtime' might be needed to stop disabling BIOS' background trojans
cmdline_workarounds=intremap=nosid,no_x2apic_optout pci=big_root_window,skip_isa_align mem_encrypt=off mce=recovery iomem=relaxed acpi_enforce_resources=lax
# ignore vulnerabilities (all with 'mitigations=off') and disable mitigations that result in huge loss in performance ? most danger comes from virtual machines with untrusted guests
cmdline_vulnerabilities=nopti nospectre_v1 nospectre_v2 spectre_v2_user=off tsx_async_abort=off l1tf=off kvm-intel.vmentry_l1d_flush=cond mds=off
# mirror module options from `/etc/modprobe.d/90-<tweaks>.conf` for potentially built-in modules
cmdline_options=drm_kms_helper.poll=0 virtio_blk.queue_depth=2048 virtio_blk.poll_queues=8 virtio_blk.num_request_queues=8

[bootloader]
cmdline=${cmdline_main} ${cmdline_rcu} ${cmdline_io} ${cmdline_pci} ${cmdline_power} ${cmdline_storage} ${cmdline_workarounds} ${cmdline_vulnerabilities} ${cmdline_options}

[cpu]
# see /usr/lib/python*/site-packages/tuned/plugins/plugin_cpu.py
#force_latency=6
# more dynamic approach
load_threshold=0.33
latency_low=1
# frequency and voltage are noticeably influenced by these 2 options
latency_high=99
pm_qos_resume_latency_us=111
# this setting is possibly no longer applicable.
# 'schedutil' is considered universal future-proof solution but it's undercooked and may decide to max-out frequency all the time, just like 'performance'
# 'ondemand' is safe legacy default for all cases.
# on some Intel CPUs only "performance" and "powersave" may be available and former completely disables frequency scaling '|' can be used for "if absent then try next"
# 'userspace' may be viable with things like thermald
governor=schedutil|ondemand|conservative|powersave
# https://lore.kernel.org/patchwork/patch/655892/ & https://lkml.org/lkml/2019/3/18/612
# dumbasses from Intel decided to hardcode this to 'normal' during kernel init and disregard BIOS settings: https://patchwork.kernel.org/project/linux-pm/patch/6369897.qxlu8PgE1t@house/
# bias is set from 0 to 15 where performance=0, balance-performance=4, normal=6, balance-power=8, power=15
# or numbers can be used directly; for desktop you may want 'performance' and for laptop - 'balance-power'
# 'performance' likes to always keep 1 core boosted to the max which helps latency in stupid 1-thread apps like some games
energy_perf_bias=performance|balance-performance
# see /sys/devices/system/cpu/cpufreq/policy*/energy_performance_available_preferences
energy_performance_preference=performance|balance-performance
sampling_down_factor=6
# for desktop you may want ≥63 and for laptop - ≤33 as power-draw rises non-linearly with frequency
min_perf_pct=63
#max_perf_pct=133
#hwp_dynamic_boost=1
#energy_efficiency=0
#no_turbo=0

[vm]
# https://www.kernel.org/doc/Documentation/vm/transhuge.txt
# use THP (transparent hugepages of 2M instead of default 4K on x86) to speed up RAM management by avoiding fragmentation & memory controller overload for price of more size overhead.
# 'always' forces them by default, use only with a lot of RAM to spare. Better used in conjunction with kernel boot option of 'transparent_hugepage=always' for early allocation.
# 'madvise' relies on software explicitly requesting them which is the safe option
# this became incompatible with kernel built with PREEMPT_RT=y
transparent_hugepages=always
# also try putting something like 'GLIBC_TUNABLES=glibc.malloc.hugetlb=1' into /etc/environment
# or install libhugetlbfs and preload it

[script]
# custom script for autoprobing sensors and configuring network devices
#script=script.sh

[sysfs]
# https://www.kernel.org/doc/Documentation/x86/x86_64/machinecheck
/sys/devices/system/machinecheck/machinecheck*/tolerant=2

# https://www.kernel.org/doc/html/latest/admin-guide/mm/ksm.html
# don't run KSM too often
/sys/kernel/mm/ksm/pages_to_scan=4096
/sys/kernel/mm/ksm/sleep_millisecs=111
/sys/kernel/mm/ksm/stable_node_chains_prune_millisecs=3333
/sys/kernel/mm/ksm/max_page_sharing=512
/sys/kernel/mm/ksm/merge_across_nodes=0
/sys/kernel/mm/ksm/use_zero_pages=1
/sys/kernel/mm/ksm/run=1

# accompanying options for THP
# get some 1GB-sized mega-pages on x86_64 too, 2MB ones are set via vm.nr_overcommit_hugepages
/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages=8
# tmpfs mounts also should have 'huge=' option with 'always', 'within_size' or 'advise', like in /etc/systemd/system/{dev-shm,tmp}.mount
/sys/kernel/mm/transparent_hugepage/shmem_enabled=advise
# 'defer+madvise' is the most preffered option but it has a small risk of delays breaking realtime, 'always' breaks realtime for sure and creates bad stutters.
# however, tuned may shit itself and refuse to use pure 'defer'.
/sys/kernel/mm/transparent_hugepage/defrag=defer+madvise
# separate periodic defrag call is also breaks realtime and creates bad stutters
#/sys/kernel/mm/transparent_hugepage/khugepaged/defrag=0
# make it often and not long to avoid stutters
# 512/1000/10000 values seem tolerable on weak old CPUs
/sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan=512
/sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs=111
/sys/kernel/mm/transparent_hugepage/khugepaged/alloc_sleep_millisecs=3333
# for x86_64 arch
/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none=65536
/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_swap=4096

### !!! THE IMPORTANT PART FOR NVMEs !!!
# conventional wisdom dictates using default of 'noop' which bypasses OS scheduling but they say that it may cause stuttering on heavy I/O
# 'mq-deadline' is known for tanking random reads which is the most important characteristic for system's responsiveness, see https://lore.kernel.org/linux-block/0ca63d05-fc5b-4e6a-a828-52eb24305545@acm.org/
# so, 'kyber' is advised, see https://github.com/pop-os/default-settings/pull/149 and https://www.phoronix.com/forums/forum/software/general-linux-open-source/1437578-mq-deadline-scheduler-optimized-for-much-better-scalability
/sys/block/nvme*n*/queue/scheduler=kyber
# add all NVMe devices as entropy sources ? this is very effective but may worsen I/O access latency
/sys/block/nvme*n*/queue/add_random=1
# 'nr_requests' supposedly is amount of sectors that can be requested at a time by an app
# max value is limited by 'nvme.io_queue_depth' minus 1
/sys/block/nvme*n*/queue/nr_requests=8
# max value is limited by 'max_hw_sectors_kb', usually 2M
/sys/block/nvme*n*/queue/max_sectors_kb=2048
# how this works is a mystery. you would think that anything >0 would ruin latency on SSD/NVMe but it seems 0 ruins throughput instead
# so it might be essential for linear reads, see https://lwn.net/Articles/897786/
# try 0/4/8/16/64/128/256/512/1024/2048 and up to max_sectors_kb
/sys/block/nvme*n*/queue/read_ahead_kb=2048
# https://events.static.linuxfound.org/sites/events/files/slides/lemoal-nvme-polling-vault-2017-final_0.pdf
# -1 is default (high CPU-load or has it changed?);
# 0 is "adaptive hybrid polling" (best latency with moderate CPU-load) - this doesn't seem to work anymore;
# >0 is fixed-time hybrid polling in ns (device-specific; 2 may be close to 0, 4 - minimal CPU load with latency as high as -1)
/sys/block/nvme*n*/queue/io_poll_delay=0
# doesn't work, requires booting with 'nvme.poll_queues=X'
#/sys/block/nvme*n*/queue/io_poll=1
# don't use CPU for the work of NVMe controller ?
# 1 means 'simple merges', 2 is to actually disable them
/sys/block/nvme*n*/queue/nomerges=1
# supposedly decreases CPU load due to caching. 0 to disable, 1 for "CPU group", 2 is strict CPU binding
# doesn't seem to prevent wild migration of I/O processes
/sys/block/nvme*n*/queue/rq_affinity=2
# this throttles writes if it detect latency above this, 0 is "disable"
# default seems to be 2000, so you may try things like 333/666/999/1333/3333/6666/7333/9999
/sys/block/nvme*n*/queue/wbt_lat_usec=3333
# try 3/7
/sys/block/nvme*n*/queue/throttle_sample_time=2
## KYBER options: defaults are 2000000 / 10000000
/sys/block/nvme*n*/queue/iosched/read_lat_nsec=3333111
/sys/block/nvme*n*/queue/iosched/write_lat_nsec=333111111
## MQ-DEADLINE options, so - irrelevant
/sys/block/nvme*n*/queue/iosched/front_merges=0
# must be lower for better latency
/sys/block/nvme*n*/queue/iosched/fifo_batch=4
/sys/block/nvme*n*/queue/iosched/writes_starved=4
/sys/block/nvme*n*/queue/iosched/read_expire=100
/sys/block/nvme*n*/queue/iosched/write_expire=1000

# same for legacy SATA ?
/sys/block/sd?/queue/nr_requests=64
/sys/block/sd?/queue/max_sectors_kb=2048
/sys/block/sd?/queue/read_ahead_kb=2048
/sys/block/sd?/queue/io_poll_delay=0
/sys/block/sd?/queue/io_poll=1
#/sys/block/sd?/queue/rq_affinity=2
/sys/block/sd?/queue/wbt_lat_usec=33111
/sys/block/sd?/queue/throttle_sample_time=11
/sys/block/sd?/device/ncq_prio_enable=1
/sys/block/sd?/device/queue_ramp_up_period=1111
## KYBER options: defaults are 2000000 / 10000000
/sys/block/sd?/queue/iosched/read_lat_nsec=1111333
/sys/block/sd?/queue/iosched/write_lat_nsec=3311111

# remove wasteful operations on zram/zswap (should complement sysctl settings)
/sys/block/zram?/queue/nr_requests=1024
# 4 or 2048 ?
/sys/block/zram?/queue/max_sectors_kb=2048
# 4 / 64 / 2048 ?
/sys/block/zram?/queue/read_ahead_kb=2048
/sys/block/zram?/queue/io_poll_delay=0
#/sys/block/zram?/queue/io_poll=1
/sys/block/zram?/queue/nomerges=1
/sys/block/zram?/queue/rq_affinity=2
/sys/block/zram?/queue/throttle_sample_time=8

# scheduling stuff
# https://www.phoronix.com/forums/forum/software/mobile-linux/1151560-the-xanmod-kernel-is-working-well-to-boost-ubuntu-desktop-workstation-performance/page3
# 0 / 1 / 3 / 9 / 18 / 33 / 50 / 111 / 500 / 1111 / 3333 / 6333 ?
/sys/devices/system/cpu/cpufreq/schedutil/rate_limit_us=33
/sys/devices/system/cpu/cpufreq/ondemand/sampling_rate=111
#/sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor=4
/sys/devices/system/cpu/cpufreq/ondemand/up_threshold=77
/sys/devices/system/cpu/cpufreq/ondemand/down_threshold=33
/sys/devices/system/cpu/cpufreq/ondemand/powersave_bias=11
/sys/devices/system/cpu/cpufreq/ondemand/io_is_busy=1
/sys/devices/system/cpu/cpufreq/conservative/freq_step=11
/sys/devices/system/cpu/cpufreq/conservative/down_threshold=33
/sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor=4

# intel_pstate hacks from https://www.kernel.org/doc/Documentation/cpu-freq/intel-pstate.txt
/sys/kernel/debug/pstate_snb/sample_rate_ms=3
/sys/kernel/debug/pstate_snb/setpoint=80
/sys/kernel/debug/pstate_snb/p_gain_pct=25

# sysctl settings that were imprisoned in debugfs
# https://github.com/zen-kernel/zen-kernel/issues/238
# https://serverfault.com/questions/925815/cpu-utilization-impact-due-to-granularity-kernel-parameter-rhel6-vs-rhel7
# supposedly, faster and bigger migration should do more usefull work on CPUs
# but it has shown to create conflicts for realtime multimedia tasks by preempting them too much
# try 2/4/16/24/32
/sys/kernel/debug/sched/nr_migrate=16
# default is 500000 (0.5 ms) which causes migration seesaw, try 0.01-0.2 ms or 3-33 ms
/sys/kernel/debug/sched/migration_cost_ns=11333
# "sched_tunable_scaling controls whether the scheduler can adjust sched_latency_ns. The values are 0 = do not adjust, 1 = logarithmic adjustment, and 2 = linear adjustment.
#  The adjustment made is based on the number of CPUs, and increases logarithmically or linearly as implied in the available values. This is due to the fact that with more CPUs there's an apparent reduction in perceived latency. "
/sys/kernel/debug/sched/tunable_scaling=0
/sys/kernel/debug/sched/latency_warn_once=0
/sys/kernel/debug/sched/latency_warn_ms=16
# previously, 100k was the lowest achievable value and defaults were 10 times that
# for desktop you may want ≤10k (such as 1000/3333/6666 with 33k/66k for wakeup/idle) and for laptop - ≥100k but no more than 1M
/sys/kernel/debug/sched/wakeup_granularity_ns=3333
/sys/kernel/debug/sched/idle_min_granularity_ns=333333
/sys/kernel/debug/sched/min_granularity_ns=11111
/sys/kernel/debug/sched/latency_ns=99999
# none / voluntary / full
#/sys/kernel/debug/sched/preempt=full
#/sys/kernel/debug/sched/verbose=Y
/sys/kernel/debug/sched/numa_balancing/scan_size_mb=16
/sys/kernel/debug/sched/numa_balancing/scan_period_max_ms=9999
/sys/kernel/debug/sched/numa_balancing/scan_period_min_ms=1111
/sys/kernel/debug/sched/numa_balancing/scan_delay_ms=1666

[sysctl]
# https://unix.stackexchange.com/questions/277505/why-is-nice-level-ignored-between-different-login-sessions-honoured-if-star
kernel.sched_autogroup_enabled=0
# https://bugzilla.redhat.com/show_bug.cgi?id=1797629
kernel.timer_migration=0
kernel.sched_cfs_bandwidth_slice_us=10000
kernel.sched_child_runs_first=1
#kernel.sched_energy_aware=0
kernel.sched_deadline_period_max_us=111111
kernel.sched_deadline_period_min_us=1111

# for better realtime
kernel.sched_rt_period_us=100000
# this doesn't work with CONFIG_RT_GROUP_SCHED and must be -1 (unlimited) which is dangerous due to system lock-ups
kernel.sched_rt_runtime_us=50000
# https://wiki.linuxfoundation.org/realtime/documentation/technical_basics/sched_policy_prio/start
# this is a very specific parameter: time-slice for RR processes of the same priority
kernel.sched_rr_timeslice_ms=1
# https://www.kernel.org/doc/html/latest/admin-guide/sysctl/kernel.html#sched-util-clamp-min
kernel.sched_util_clamp_max=999
# unfortunately, RT limits depend on generic limits
kernel.sched_util_clamp_min=1024
kernel.sched_util_clamp_min_rt_default=1024

### !!! THE IMPORTANT PART FOR RAM-related I/O latency !!!
# https://www.kernel.org/doc/html/latest/admin-guide/sysctl/vm.html
# this only leads to random memory errors
#vm.overcommit_memory=2
#vm.overcommit_ratio=90
# give 16GB to dynamic hugepage pool by setting '8192' for 2MB pages of x86_64 arch ?
vm.nr_overcommit_hugepages=8192
vm.admin_reserve_kbytes=262144
# try gid of 'users' group which is likely '100' or '1000' by default
#vm.hugetlb_shm_group=100
# default of this is based on RAM-size (66 MB with 16 GB for me, for example) and works well enough but we want more
vm.min_free_kbytes=262144
# disable for lower RAM access latency (may cause severe fragmentation) or enable for efficiency (may hurt realtime tasks)
# default is '1' for "enabled"
#vm.compact_unevictable_allowed=0
# default is 20
vm.compaction_proactiveness=5
#vm.hugepages_treat_as_movable=1
# clustered servers may want to keep it at 0 but 3 could be a safe compromise between latency and efficiency… if it worked BUT in reality it only wastes CPU and brings I/O to a crawl with no benefit
# https://blogs.dropbox.com/tech/2017/09/optimizing-web-servers-for-high-throughput-and-low-latency/
vm.zone_reclaim_mode=0
# how aggressive reclaim is, default is 1%
#vm.min_unmapped_ratio=3
# enable to keep processes in RAM that is controlled by CPU that is running them
# multi-socket systems must have this enabled
#kernel.numa_balancing=0
#kernel.numa_balancing_scan_period_min_ms=64
#kernel.numa_balancing_scan_period_max_ms=10000
#kernel.numa_balancing_scan_delay_ms=256
#kernel.numa_balancing_scan_size_mb=16
# If a workload mostly uses anonymous memory and it hits this limit, the entire working set is buffered for I/O, and any more write buffering would require swapping, so it's time to throttle writes until I/O can catch up.  Workloads that mostly use file mappings may be able to use even higher values.
# The generator of dirty data starts writeback at this percentage (system default is 20%)
vm.dirty_ratio=24
# Start background writeback (via writeback threads) at this percentage (system default is 10%)
vm.dirty_background_ratio=16
# give it a minute
vm.dirty_expire_centisecs=12000
vm.dirty_writeback_centisecs=6000
# https://unix.stackexchange.com/questions/30286/can-i-configure-my-linux-system-for-more-aggressive-file-system-caching
# 100 is default, <100 is "retain more fs directory caches", >100 up to 1000 is "retain less"
vm.vfs_cache_pressure=333
# The swappiness parameter controls the tendency of the kernel to move processes out of physical memory and onto the swap disk.
# 0 tells the kernel to avoid swapping processes out of physical memory for as long as possible.
# 100 tells the kernel to aggressively swap processes out of physical memory and move them to swap cache.
# 0-10 is good for systems with normal swap but with usage of zswap (compressed swap in RAM) higher values may be more desirable.
# this seems to have changed in recent years: <100 is "prefer dropping caches to avoid swapping" and >100-200 is "prefer swapping stale process memory"
# so 150-180 may be preferred nowadays with zram+nvme (swap file should have lower priority than 10 in fstab)
vm.swappiness=11
# higher values (4-5) may be better on systems with CPU power to spare for I/O BUT they may increase latencies on SSDs
# see https://www.reddit.com/r/Fedora/comments/mzun99/new_zram_tuning_benchmarks/ which says that anything >0 produces too much latency
# but 9 might result in 2048K (4k*2^[4]=64K) read-ahead which would coincide with most NVMEs sector size and desired read-ahead
vm.page-cluster=1
# aggressiveness of swap in freeing memory, 100 means try to keep 1% of memory free, 1000 is the maximum
vm.watermark_scale_factor=333

# better clock:
# http://wiki.linuxaudio.org/wiki/system_configuration
dev.hpet.max-user-freq=4096

# may be already selected as kernel's default
# https://wiki.gentoo.org/wiki/Traffic_shaping#Theory
# sfq is simple and safe, fq_codel and complex and robust, cake is even more complex but lacks some tunable parameters
net.core.default_qdisc=fq_codel

# some stuff inspired by stock tuned rt profile
# see https://www.kernel.org/doc/Documentation/sysctl/net.txt
# https://github.com/leandromoreira/linux-network-performance-parameters
kernel.hung_task_check_interval_secs=5
kernel.hung_task_timeout_secs=30
vm.stat_interval=10
net.ipv4.tcp_fastopen=3
# default is 64 with 1/1 for rx/tx, 39 seems safe for rx/tx bias 3/2, 472 seems fine
# set weight to [ netdev_budget / weight_rx_bias ] ?
net.core.dev_weight=16
net.core.dev_weight_rx_bias=3
net.core.dev_weight_tx_bias=2
# this may hang ethernet interface in a mysterious way
net.core.busy_read=0
# should be 100 for maximum network performance but anything ≥50 is a CPU strain
net.core.busy_poll=0
net.core.netdev_max_backlog=1024
# 700-871 may be optimal but will eat a lot of CPU-time
# <200 may lead to dropped packets even on slow links but 117 seems safe
net.core.netdev_budget=2048
# should be ≥5000 for maximum network performance, small values may result in dropped frames & packets
# 751 seems safe, 999 may be optimal, 1999 is decent for networking performance
net.core.netdev_budget_usecs=4999
# https://www.kernel.org/doc/Documentation/networking/scaling.txt
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/performance_tuning_guide/sect-red_hat_enterprise_linux-performance_tuning_guide-networking-configuration_tools#sect-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Configuration_tools-Configuring_Receive_Packet_Steering_RPS
# net.core.rps_sock_flow_entries should be a number of maximum expected system-wide simultaneous connections
net.core.rps_sock_flow_entries=1024
# BPF
#net.core.bpf_jit_enable=1
#net.core.bpf_jit_harden=1
net.core.bpf_jit_kallsyms=1
net.core.bpf_jit_limit=1073741824

```

* `/etc/udev/rules.d/61-io-schedulers.rules`:
```udev
# HDD / SSD
#ACTION=="add|change", KERNEL=="sd*[!0-9]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
ACTION=="add|change", KERNEL=="sd*[!0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber
# SDcard / eMMC
ACTION=="add|change", KERNEL=="mmcblk?", ATTR{removable}=="1", ATTR{queue/scheduler}="bfq"
ACTION=="add|change", KERNEL=="mmcblk?", ATTR{removable}=="0", ATTR{queue/scheduler}="kyber"
```

* `/etc/default/grub`:
```ini
# use GRUB_CMDLINE_LINUX_DEFAULT or additional variables for appending custom settings, like this
# use 'pci=nocrs' if your kernel does not boot (especially `amdgpu` driver) with >4GB PCIe I/O mapping support enabled (called "SAM", "Large BAR", etc.)
# use 'drm.edid_firmware=[<connector>:]<file>[,[<connector>:]<file>]' with path relative to '/lib/firmware' to replace EDID with custom one to overclock a monitor
GRUB_CMDLINE_LINUX_DEFAULT="drm.edid_firmware=X"
# 'nvme.*' settings must be hardcoded for a particular device, see `dmesg | grep -e nvme.*queues`
# use 'mitigations=off dis_ucode_ldr' to prevent overriding BIOS' CPU firmware to avoid performance hits from 'hardware vulnerability mitigations' or replacement of hacked firmware
GRUB_CMDLINE_LINUX_ADDITIONAL="nvme.poll_queues=24 nvme.write_queues=8"
GRUB_CMDLINE_LINUX_DEFAULT="${GRUB_CMDLINE_LINUX_DEFAULT:+$GRUB_CMDLINE_LINUX_DEFAULT }${LINUX_ROOT_DEVICE} \${tuned_params} ${GRUB_CMDLINE_LINUX_ADDITIONAL:+$GRUB_CMDLINE_LINUX_ADDITIONAL}"
```

* `/etc/sysctl.d/99-<tweaks>.conf`:
```ini
# make sure that Magic Keys are always enabled
# we can't deal with emergencies without them
kernel.sysrq=1

# https://unix.stackexchange.com/questions/14227/do-i-need-root-admin-permissions-to-run-userspace-perf-tool-perf-events-ar
# https://lwn.net/Articles/696216/
kernel.perf_event_paranoid=0

# https://www.kernel.org/doc/Documentation/security/Yama.txt
# https://superuser.com/questions/1293298/how-to-detach-ssh-session-without-killing-a-running-process
# '2' is good default… buuuut it breaks wine and its windoze trash, workaround with this:
# sudo setcap cap_sys_ptrace=eip `which wineserver`
# sudo setcap cap_sys_ptrace=eip `which wine-preloader`
kernel.yama.ptrace_scope=1

# make kernel to shit in console less
# https://unix.stackexchange.com/questions/117926/try-to-disable-console-output-console-null-doesnt-work
kernel.printk=3 4 1 3

# does it really do anything substantial?
# kernel.io_delay_type=3

# needed for iotop
kernel.task_delayacct=1

# allow more mappings
# see https://docs.actian.com/vector/5.0/index.html#page/User/Increase_max_map_count_Kernel_Parameter_(Linux).htm and https://github.com/yuzu-emu/yuzu/issues/7397#issuecomment-974834996
# "map_count should be around 1 per 128 KB of system memory"
vm.max_map_count=262144

# be frugal with RAM allocation
# https://www.kernel.org/doc/Documentation/sysctl/vm.txt
vm.oom_kill_allocating_task=1
# should be set in tuned.conf but it doesn't seem to be working there
# in fact, this whole stuff only leads to random memory errors
#vm.overcommit_memory=2
#vm.overcommit_ratio=90
# 4G of dynamic hugepages
# vm.nr_overcommit_hugepages=2048

# you may want to forbid core dumps because they may lead to massive stuttering
# no core dumps for suid
#fs.suid_dumpable=0
# or anyone
#kernel.core_pattern=|/bin/false

# and some more generous file limits too
fs.file-max=10000000
fs.inotify.max_user_watches=524288
#fs.file-nr=197600 1000 3624009
net.unix.max_dgram_qlen=8192
```

* `/etc/modprobe.d/90-<tweaks>.conf`:
```ini
# Intel broken backdoor that fails anyway on some X79 motherboards
blacklist mei_me

# prefer polling (0), which may be better for realtime scheduling, instead of NMI (1) which should be kept to minimum
options amd64_edac edac_op_state=0 ecc_enable_override=1
options sb_edac edac_op_state=0
options skx_edac edac_op_state=0
options i7core_edac edac_op_state=0 use_pci_fixup=1
options x38_edac edac_op_state=0
options pnd2_edac edac_op_state=0
options i82975x_edac edac_op_state=0

# KVM/iommu stuff
# https://www.reddit.com/r/VFIO/comments/fovu39/iommu_avic_in_linux_kernel_56_boosts_pci_device/
# https://bugzilla.redhat.com/show_bug.cgi?id=1812323
options kvm nx_huge_pages=1
options kvm_amd nested=0 avic=1 npt=1
options kvm_intel nested=1 enable_apicv=1 preemption_timer=1 enlightened_vmcs=1 fasteoi=1
options virtio_snd pcm_period_ms_max=24 pcm_period_ms_min=6 pcm_periods_max=6 pcm_periods_min=3
options virtio_mem unplug_online=1
# https://bbs.archlinux.org/viewtopic.php?id=283340 and https://superuser.com/questions/1767148/qemu-slow-network-performance-with-virtio-net-driver
options virtio_net napi_tx=1 gso=1 csum=1 napi_weight=6
options virtio_scsi virtscsi_poll_queues=8 
options virtio_blk queue_depth=2048 poll_queues=8 num_request_queues=8
options vkms enable_overlay=1 enable_writeback=1 enable_cursor=1

# USB core, most likely built-in and have to be configured in bootloader
# autosuspend=-1 to disable power-saving that either never works at all or switches off devices during their work
# usbfs_memory_mb=X to increase buffer size from measly default of 16MB, it's capped to 2G system-wide and hungry high I/O devices may easily want 256-1024MB (https://libusb-devel.narkive.com/EJweu22S/question-usbfs-limits)
# usbfs_snoop=1 previously logged debug info into dmesg but now requires 'usbmon' kernel module and 'usbmon' userspace program
# authorized_default=1 use_both_schemes=1 old_scheme_first=0 - some authorization nonsense for "security masturbation"
options usbcore usbfs_memory_mb=2048 autosuspend=-1 initial_descriptor_timeout=2000 authorized_default=1 use_both_schemes=1 old_scheme_first=0

# force USB mices and "joysticks" to use fastest polling rate because for some unexplaiend reason they don't, "gamer" keyboards are also 1000hz:
# https://wiki.archlinux.org/index.php/mouse_polling_rate
# however, some USB controllers may misbehave
options usbhid kbpoll=1 mousepoll=1 jspoll=1

# workaround for massive stuttering from mouse movement: https://superuser.com/questions/528727/how-do-i-solve-periodic-mouse-lag-on-linux-mint-mate
options drm_kms_helper poll=0

# amdgpu overrides; if there are "VM fault" errors or false "100% load" state then your vbios or overclock might be screwy
options radeon cik_support=0 si_support=0 msi=1 disp_priority=2 runpm=1 aspm=1 dynclks=1 auxch=1 mst=1 uvd=1 vce=1 deep_color=1 lockup_timeout=14900
options amdgpu cik_support=1 si_support=1 msi=1 disp_priority=2 ppfeaturemask=0xfffd7fff aspm=0 pcie_p2p=0 use_xgmi_p2p=0 exp_hw_support=1 hw_i2c=1 no_system_mem_limit=1 mes=1 mes_kiq=1 compute_multipipe=1 sdma_phase_quantum=4 sched_policy=1 sched_hw_submission=256 sched_jobs=4096 max_num_of_queues_per_device=16384 queue_preemption_timeout_ms=41 lockup_timeout=15000,66000,33000,15000 ras_enable=1 deep_color=1 freesync_video=1


# Bluetooth crap
#options btusb enable_autosuspend=0 reset=1
options bluetooth disable_esco=0 disable_ertm=0 enable_ecred=1
options rfcomm disable_cfc=0 l2cap_ertm=1
options bnep compress_dst=1 compress_src=1
```

* `/etc/rtirq.conf`:
```ini
RTIRQ_NAME_LIST="timer rtc snd drm amdgpu radeon i915 nvidia usb i8042 nvme ahci ioat-msi"
RTIRQ_PRIO_HIGH=80
RTIRQ_PRIO_DECR=2
RTIRQ_PRIO_LOW=50
# Whether to reset all IRQ threads to SCHED_OTHER.
RTIRQ_RESET_ALL=0
RTIRQ_NON_THREADED="rtc"
# Process names which will be forced to the # highest realtime priority range (99-91)
RTIRQ_HIGH_LIST="watchdogd oom_reaper timer rcu_preempt rcu_sched gfx sdma ttm ksoftirqd irq_work khugepaged"
```

* `/etc/rtkit.conf`:
```ini
# see /usr/libexec/rtkit/rtkit-daemon -h for garbage
RTKIT_ARGS="--scheduling-policy=FIFO
--our-realtime-priority=50
--max-realtime-priority=49
--min-nice-level=-19
--rttime-usec-max=-1
--users-max=100
--processes-per-user-max=1000
--threads-per-user-max=10000
--actions-burst-sec=10
--actions-per-burst-max=1000
--canary-cheep-msec=30000
--canary-watchdog-msec=60000
"
```

* `/etc/systemd/system/rtkit-daemon.service.d/limits.conf`:
```systemd
[Service]
EnvironmentFile=/etc/rtkit.conf
ExecStart=
ExecStart=/usr/libexec/rtkit/rtkit-daemon $RTKIT_ARGS
```

* `/etc/security/limits.d/realtime.conf`:
```ini
# limits to guarantee crisp sound in system-wide instance of PA
pulse - rtprio 25
pulse - memlock 262144
pulse - nice -15
# same for system-wide instance of PW
pulse - rtprio 50
pulse - memlock 4194304
pulse - nice -15
# default priority with favour of users
# works properly only with CONFIG_SCHED_AUTOGROUP & CONFIG_RT_GROUP_SCHED disabled
@root soft priority 5
@messagebus soft priority -10
@users soft priority -2
# limits for users, put kernel processes above that
@users soft rtprio 46
@users hard rtprio 49
@users soft nice -19
@users hard nice -20
# setting this may limit whole address space
#@users soft memlock 4194304
@users hard memlock unlimited
@users hard nproc 65536
# don't limit the amount of opened files and sockets
# 65536 is decent default for soft but we may want to set it close to hard
* soft nofile 1048576
# setting this higher than 1048576 makes PAM lose its shit and make system unusable !!!
* hard nofile 1048576
# and signals & message queues
# 131072 and 2097152 for soft or unlimited for all ?
* soft sigpending 65536
* hard sigpending unlimited
* soft msgqueue 2097152
* hard msgqueue unlimited
# to disallow useless core dumps that cause stuttering ?
# http://forums.fedoraforum.org/showthread.php?t=303659
#* - core 0
```

* `/etc/dracut.conf.d/99-<tweaks>.conf`:
```ini
# faster de/compression
compress="zstd -12 -T0"
#compress="lz4 --fast=6 -l"
#compress="lzop -v --crc32"
# strongest compression
#compress="xz --threads=0 -8 --check=crc32 --memlimit-compress=75%"
# strongest compression in parallel
#compress="pixz -p 8 -8"
# on /boot with transparrent compression you may want to have no compression in initrd
#compress="cat"
#enhanced_cpio=yes
# actually show traces for modules that load early
do_strip=no
nostrip=yes
# emergency utilities
install_optional_items+=" /sbin/testvbe /sbin/v86d /usr/bin/nano /usr/bin/disktype /usr/bin/grep /usr/share/kbd/consolefonts/ter-v16b* "
# for amdgpu and general optimizations
install_optional_items+=" /etc/modprobe.d/* /etc/sysctl.d/* /etc/udev/* /usr/lib/firmware/edid/* "
filesystems+=" btrfs xfs ext4 ntfs3 "
# init GPU driver early, so rtirq can boost up its sub-threads and tuned can tune its hidden variables at its init
add_drivers+=" amdgpu "
# allow place for binary nvidia driver
omit_drivers+=" nouveau "
# make sure to use actual system mount parameters
use_fstab=yes
# force it to actually use fstab !
hostonly_cmdline=yes
# this supposed to add kernel boot entries directly to BIOS/EFI BUT in reality it completely brakes dracut that silently refuses to create initrd and update grub.cfg
#uefi=no
# use this and 'mitigations=off dis_ucode_ldr' in cmdline to prevent overriding BIOS' CPU firmware to avoid performance hits from 'hardware vulnerability mitigations' or replacement of hacked firmware
#early_microcode=no
# pretty font
i18n_default_font=ter-v16b
```

* `/etc/environment`:
```ini
# https://www.gnu.org/software/libc/manual/html_node/Tunables.html
GLIBC_TUNABLES=glibc.malloc.hugetlb=1:glibc.elision.enable=1
# https://github.com/libhugetlbfs/libhugetlbfs/blob/master/HOWTO
# this may need '[Mount]\n Options=users,gid=users,exec,strictatime' in /etc/systemd/system/dev-hugepages.mount.d/override.conf and 'Options=mode=1777,strictatime,size=25%,huge=within_size' in /etc/systemd/system/dev-shm.mount
LD_PRELOAD=libhugetlbfs.so
# 'yes' when preloading or 'thp' when not
HUGETLB_MORECORE=thp
HUGETLB_MORECORE_SHRINK=yes
HUGETLB_SHM=yes
HUGETLB_FORCE_ELFMAP=yes
HUGETLB_ELFMAP=RW
#HUGETLB_SHARE=1
```

It may be advisable to build kernel in preempt-rt mode rather than default dynamic-preempt mode with the patch:
```patch
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d9830e7..013d5f8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@ config X86_64
 	def_bool y
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
+	select ARCH_SUPPORTS_RT
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_USE_CMPXCHG_LOCKREF
@@ -107,6 +108,7 @@ config X86
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
+	select ARCH_SUPPORTS_RT			if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
@@ -285,6 +287,9 @@ config STACKTRACE_SUPPORT
 config MMU
 	def_bool y
 
+config ARCH_SUPPORTS_RT
+	def_bool y if X86_64
+
 config ARCH_MMAP_RND_BITS_MIN
 	default 28 if 64BIT
 	default 8

```
