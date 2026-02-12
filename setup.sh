#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/.env"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info()  { echo -e "${CYAN}[INFO]${NC}  $1"; }
log_ok()    { echo -e "${GREEN}[✓]${NC}     $1"; }
log_warn()  { echo -e "${YELLOW}[!]${NC}     $1"; }
log_error() { echo -e "${RED}[✗]${NC}     $1"; }

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Server Boilerplate - Full Setup     ║"
echo "╚══════════════════════════════════════╝"
echo ""

[ "$EUID" -ne 0 ] && { log_error "Run as root: sudo bash setup.sh"; exit 1; }
[ ! -f "$ENV_FILE" ] && { log_error ".env not found! Run: cp .env.example .env && nano .env"; exit 1; }

source "$ENV_FILE"

REQUIRED=("DOMAIN_NAME" "SSL_EMAIL" "GENERIC_TIMEZONE" "SSH_PORT" "SSH_USERNAME" "EVOLUTION_DB_PASSWORD" "ODOO_DB_PASSWORD" "ODOO_ADMIN_PASSWORD" "EVOLUTION_API_KEY" "TS_AUTHKEY")
MISS=0
for v in "${REQUIRED[@]}"; do [ -z "${!v:-}" ] && { log_error "Missing: $v"; MISS=1; }; done
[ "$MISS" -eq 1 ] && exit 1
log_ok "Variables validated"

# PHASE 1: System
log_info "=== Phase 1: System ==="
apt-get update -qq && apt-get upgrade -y -qq
apt-get install -y -qq curl wget git htop vim tmux apt-transport-https ca-certificates gnupg lsb-release jq bc inotify-tools net-tools
bash "${SCRIPT_DIR}/system/setup-swap.sh"
bash "${SCRIPT_DIR}/system/setup-sysctl.sh"
bash "${SCRIPT_DIR}/system/setup-auto-upgrades.sh"

# PHASE 2: Docker
log_info "=== Phase 2: Docker ==="
if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker && systemctl start docker
fi
docker network inspect web-public &>/dev/null 2>&1 || docker network create web-public
log_ok "Docker ready"

# PHASE 3: Security
log_info "=== Phase 3: Security ==="
bash "${SCRIPT_DIR}/security/setup-ssh.sh"
bash "${SCRIPT_DIR}/security/setup-ufw.sh"
bash "${SCRIPT_DIR}/security/setup-crowdsec.sh"
bash "${SCRIPT_DIR}/security/setup-clamav.sh"

# PHASE 4: Config Files
log_info "=== Phase 4: Config Files ==="

cat > "${SCRIPT_DIR}/my-stack/.env" << ENVGEN
DOMAIN_NAME=${DOMAIN_NAME}
SSL_EMAIL=${SSL_EMAIL}
GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
SUBDOMAIN=n8n
N8N_EXECUTIONS_PROCESS=${N8N_EXECUTIONS_PROCESS}
N8N_PUSH_BACKEND=${N8N_PUSH_BACKEND}
EVOLUTION_DB_PASSWORD=${EVOLUTION_DB_PASSWORD}
ODOO_DB_PASSWORD=${ODOO_DB_PASSWORD}
ODOO_ADMIN_PASSWORD=${ODOO_ADMIN_PASSWORD}
NEXTJS_IMAGE=${NEXTJS_IMAGE:-mohammed512/odoo-nextjs-frontend:latest}
ENVGEN

cat > "${SCRIPT_DIR}/my-stack/.env.evolution" << EVOGEN
AUTHENTICATION_API_KEY=${EVOLUTION_API_KEY}
SERVER_TYPE=http
SERVER_PORT=8080
SERVER_URL=https://evo.${DOMAIN_NAME}
DATABASE_ENABLED=true
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://postgres:${EVOLUTION_DB_PASSWORD}@db-evolution:5432/evolution?schema=public
CACHE_REDIS_ENABLED=true
CACHE_REDIS_URI=redis://redis-evolution:6379/1
CACHE_REDIS_PREFIX_KEY=${EVOLUTION_REDIS_PREFIX_KEY:-evolution_v2}
EVOGEN

ODOO_CONF="${SCRIPT_DIR}/my-stack/odoo-config/odoo.conf"
sed -i "s/ODOO_ADMIN_PASSWORD_CHANGE_ME/${ODOO_ADMIN_PASSWORD}/g" "$ODOO_CONF"
sed -i "s/ODOO_DB_PASSWORD_CHANGE_ME/${ODOO_DB_PASSWORD}/g" "$ODOO_CONF"

cat > "${SCRIPT_DIR}/tailscale-stack/.env" << TSGEN
TS_AUTHKEY=${TS_AUTHKEY}
TS_HOSTNAME=${TS_HOSTNAME:-server-tailscale}
TSGEN

log_ok "All config files generated"

# PHASE 5: Deploy
log_info "=== Phase 5: Deploy ==="
cd "${SCRIPT_DIR}/my-stack" && docker compose up -d
cd "${SCRIPT_DIR}/tailscale-stack" && docker compose up -d
log_ok "All stacks deployed"

# PHASE 6: Cron & Cloudflare
log_info "=== Phase 6: Final ==="
bash "${SCRIPT_DIR}/scripts/setup-cron.sh"

if [ -n "${CLOUDFLARE_TUNNEL_TOKEN:-}" ]; then
    command -v cloudflared &>/dev/null || { curl -fsSL https://pkg.cloudflare.com/cloudflared-stable-linux-amd64.deb -o /tmp/cf.deb && dpkg -i /tmp/cf.deb && rm /tmp/cf.deb; }
    cat > /etc/systemd/system/cloudflared.service << CFGEN
[Unit]
Description=cloudflared
After=network-online.target
Wants=network-online.target
[Service]
TimeoutStartSec=15
Type=notify
ExecStart=/usr/bin/cloudflared --no-autoupdate tunnel run --token ${CLOUDFLARE_TUNNEL_TOKEN}
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
CFGEN
    systemctl daemon-reload && systemctl enable cloudflared && systemctl restart cloudflared
    log_ok "Cloudflare Tunnel active"
else
    log_warn "Cloudflare Tunnel skipped (no token)"
fi

echo ""
echo "╔══════════════════════════════════════╗"
echo -e "║  ${GREEN}SETUP COMPLETE!${NC}                     ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "  n8n:        https://${DOMAIN_NAME}"
echo "  Odoo:       https://odoo.${DOMAIN_NAME}"
echo "  Evolution:  https://evo.${DOMAIN_NAME}"
echo "  NextJS:     https://next.${DOMAIN_NAME}"
echo "  Portainer:  https://portainer.${DOMAIN_NAME}"
echo "  Monitor:    https://monitor.${DOMAIN_NAME}"
echo ""
echo "  SSH: Port ${SSH_PORT} | User: ${SSH_USERNAME}"
echo ""
