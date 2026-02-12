#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[*] Setting up CrowdSec..."

if ! command -v cscli &>/dev/null; then
    curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash
    apt-get install -y crowdsec
fi

command -v crowdsec-firewall-bouncer &>/dev/null || apt-get install -y crowdsec-firewall-bouncer-iptables

cscli collections install crowdsecurity/linux 2>/dev/null || true
cscli collections install crowdsecurity/traefik 2>/dev/null || true
cscli collections install crowdsecurity/http-cve 2>/dev/null || true
cscli collections install crowdsecurity/whitelist-good-actors 2>/dev/null || true
cscli collections install crowdsecurity/pgsql 2>/dev/null || true

[ -f "${SCRIPT_DIR}/crowdsec/acquis.yaml" ] && cp "${SCRIPT_DIR}/crowdsec/acquis.yaml" /etc/crowdsec/acquis.yaml
[ -f "${SCRIPT_DIR}/crowdsec/profiles.yaml" ] && cp "${SCRIPT_DIR}/crowdsec/profiles.yaml" /etc/crowdsec/profiles.yaml

systemctl restart crowdsec
systemctl restart crowdsec-firewall-bouncer
echo "[✓] CrowdSec configured"
