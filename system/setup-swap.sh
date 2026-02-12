#!/bin/bash
set -euo pipefail

echo "[*] Setting up 4GB swap..."
SWAPFILE="/swapfile"
swapon --show | grep -q "$SWAPFILE" && { echo "[!] Swap exists"; exit 0; }

fallocate -l 4G $SWAPFILE && chmod 600 $SWAPFILE && mkswap $SWAPFILE && swapon $SWAPFILE
grep -q "$SWAPFILE" /etc/fstab || echo "$SWAPFILE none swap sw 0 0" >> /etc/fstab
sysctl vm.swappiness=60
grep -q "vm.swappiness" /etc/sysctl.conf || echo "vm.swappiness=60" >> /etc/sysctl.conf
echo "[✓] Swap ready"; free -h
