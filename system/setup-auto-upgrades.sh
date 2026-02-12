#!/bin/bash
set -euo pipefail

echo "[*] Setting up auto-upgrades..."
apt-get install -y -qq unattended-upgrades

cat > /etc/apt/apt.conf.d/20auto-upgrades << 'INNER'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
INNER

systemctl enable unattended-upgrades && systemctl start unattended-upgrades
echo "[✓] Auto-upgrades enabled"
