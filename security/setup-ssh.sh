#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../.env"

echo "[*] Hardening SSH..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%s)

cat > /etc/ssh/sshd_config << SSHEOF
Include /etc/ssh/sshd_config.d/*.conf
Port ${SSH_PORT}
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PermitRootLogin no
AllowUsers ${SSH_USERNAME}
UsePAM yes
X11Forwarding no
PrintMotd no
ClientAliveInterval 300
ClientAliveCountMax 3
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
SSHEOF

mkdir -p /etc/ssh/sshd_config.d
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/60-hardened.conf

systemctl restart sshd
echo "[✓] SSH hardened (Port: ${SSH_PORT}, User: ${SSH_USERNAME})"
