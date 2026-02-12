#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "${SCRIPT_DIR}/monitor_resources.sh" /usr/local/bin/monitor_resources.sh
chmod +x /usr/local/bin/monitor_resources.sh

CRON_TMP="/tmp/bp_cron"
crontab -l 2>/dev/null | grep -v "BOILERPLATE" | grep -v "smart_clamscan\|monitor_resources\|freshclam\|quarantine" > "$CRON_TMP" || true

cat >> "$CRON_TMP" << 'INNER'
# BOILERPLATE CRON JOBS
0 3 * * * find /root/quarantine -type f -mtime +30 -delete
*/2 * * * * /usr/local/bin/monitor_resources.sh
0 4 * * * /usr/bin/freshclam --quiet
0 5 * * * /usr/local/bin/smart_clamscan.sh
INNER

crontab "$CRON_TMP" && rm "$CRON_TMP"
echo "[✓] Cron jobs installed"
