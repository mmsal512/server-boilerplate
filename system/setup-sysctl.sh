#!/bin/bash
set -euo pipefail

echo "[*] Optimizing kernel..."
cat > /etc/sysctl.d/99-server-boilerplate.conf << 'INNER'
net.core.default_qdisc = fq_codel
net.ipv4.ip_forward = 1
kernel.kptr_restrict = 1
kernel.yama.ptrace_scope = 1
vm.mmap_min_addr = 65536
vm.max_map_count = 1048576
vm.swappiness = 60
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
net.core.somaxconn = 4096
INNER
sysctl --system > /dev/null 2>&1
echo "[✓] Kernel optimized"
