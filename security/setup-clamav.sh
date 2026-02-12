#!/bin/bash
set -euo pipefail

echo "[*] Setting up ClamAV..."
command -v clamscan &>/dev/null || { apt-get update && apt-get install -y clamav clamav-daemon clamdscan; }

systemctl stop clamav-freshclam 2>/dev/null || true
freshclam --quiet || true
systemctl start clamav-freshclam 2>/dev/null || true

mkdir -p /root/quarantine && chmod 700 /root/quarantine

cat > /usr/local/bin/smart_clamscan.sh << 'INNER'
#!/bin/bash
LOG="/var/log/clamav/smart_scan.log"
mkdir -p "$(dirname "$LOG")"
echo "=== Scan: $(date) ===" >> "$LOG"
clamscan -r --infected --no-summary --exclude-dir="^/proc" --exclude-dir="^/sys" --exclude-dir="^/dev" --exclude-dir="^/var/lib/docker" --move=/root/quarantine /root /home /tmp /var/tmp /etc 2>&1 >> "$LOG"
echo "=== Done: $(date) ===" >> "$LOG"
INNER
chmod +x /usr/local/bin/smart_clamscan.sh

echo "[✓] ClamAV configured"
