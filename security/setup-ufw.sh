#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../.env"

echo "[*] Setting up UFW..."

command -v ufw &>/dev/null || { apt-get update && apt-get install -y ufw; }

ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw default deny routed

ufw allow ${SSH_PORT}/tcp

CF4=("173.245.48.0/20" "103.21.244.0/22" "103.22.200.0/22" "103.31.4.0/22" "141.101.64.0/18" "108.162.192.0/18" "190.93.240.0/20" "188.114.96.0/20" "197.234.240.0/22" "198.41.128.0/17" "162.158.0.0/15" "104.16.0.0/13" "104.24.0.0/14" "172.64.0.0/13" "131.0.72.0/22")
CF6=("2400:cb00::/32" "2606:4700::/32" "2803:f800::/32" "2405:b500::/32" "2405:8100::/32" "2a06:98c0::/29" "2c0f:f248::/32")

for ip in "${CF4[@]}"; do ufw allow from "$ip" to any port 80; ufw allow from "$ip" to any port 443; done
for ip in "${CF6[@]}"; do ufw allow from "$ip" to any port 80; ufw allow from "$ip" to any port 443; done

ufw --force enable
echo "[✓] UFW configured"
