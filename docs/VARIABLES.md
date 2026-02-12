# Variables Reference

## Required

| Variable | Description | Example |
|----------|-------------|---------|
| `DOMAIN_NAME` | Main domain | `example.com` |
| `SSL_EMAIL` | SSL cert email | `admin@example.com` |
| `GENERIC_TIMEZONE` | Timezone | `Asia/Riyadh` |
| `SSH_PORT` | SSH port | `2026` |
| `SSH_USERNAME` | SSH user | `mohammed` |
| `EVOLUTION_DB_PASSWORD` | Evolution DB pass | Random |
| `ODOO_DB_PASSWORD` | Odoo DB pass | Random |
| `ODOO_ADMIN_PASSWORD` | Odoo admin pass | Random |
| `EVOLUTION_API_KEY` | Evolution key | `openssl rand -hex 32` |
| `TS_AUTHKEY` | Tailscale key | From dashboard |

## Optional

| Variable | Default | Description |
|----------|---------|-------------|
| `TS_HOSTNAME` | `server-tailscale` | VPN hostname |
| `N8N_EXECUTIONS_PROCESS` | `main` | N8N mode |
| `CLOUDFLARE_TUNNEL_TOKEN` | empty | CF Tunnel |
| `NEXTJS_IMAGE` | `mohammed512/...` | Frontend image |

## Quick Start
```bash
git clone <repo> && cd server-boilerplate
cp .env.example .env && nano .env
sudo bash setup.sh

