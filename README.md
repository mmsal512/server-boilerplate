```markdown
<div align="center">

# Server Boilerplate

### One-command full-stack server deployment with Docker & security hardening

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/Docker-29.2-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

<br>

```
git clone https://github.com/mmsal512/server-boilerplate.git
cd server-boilerplate
cp .env.example .env && nano .env
sudo bash setup.sh
```

</div>

---

## Overview

A production-ready server boilerplate that deploys a complete stack of applications behind Traefik reverse proxy with automatic SSL, multi-layer security hardening, VPN access, and system optimizations — all configured through a single `.env` file.

Designed for **Ubuntu 24.04 LTS** servers with **2+ vCPUs** and **8GB+ RAM**.

---

## Architecture

```
                    Internet
                       │
                  ┌────▼────┐
                  │Cloudflare│
                  └────┬────┘
                       │
              ┌────────▼────────┐
              │   UFW Firewall  │ ← Cloudflare-only HTTP/HTTPS
              │   CrowdSec IDS  │ ← Auto-ban attackers
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │     Traefik     │ ← Auto SSL (Let's Encrypt)
              │  Reverse Proxy  │
              └───┬──┬──┬──┬───┘
                  │  │  │  │
       ┌──────┐  │  │  │  │  ┌──────────┐
       │ n8n  │◄─┘  │  │  └─►│Portainer │
       │+Redis│     │  │     └──────────┘
       └──────┘     │  │
          ┌─────────┘  └──────────┐
          ▼                       ▼
   ┌──────────────┐      ┌──────────────┐
   │   Odoo 16    │      │Evolution API │
   │ + PostgreSQL │      │ + PostgreSQL │
   │ + Redis Cache│      │ + Redis      │
   │ + Next.js    │      └──────────────┘
   └──────────────┘
          │
     Tailscale VPN ←── Secure remote access
```

---

## What's Included

### Applications

| Service | Description | Subdomain |
|---------|-------------|-----------|
| **n8n** | Workflow automation | `domain.com` |
| **Odoo 16** | ERP system + PostgreSQL | `odoo.domain.com` |
| **Evolution API** | WhatsApp integration + PostgreSQL + Redis | `evo.domain.com` |
| **Next.js** | Frontend application | `next.domain.com` |
| **Portainer** | Docker management UI | `portainer.domain.com` |
| **Glances** | Real-time system monitoring | `monitor.domain.com` |

### Infrastructure

| Component | Purpose |
|-----------|---------|
| **Traefik** | Reverse proxy with automatic Let's Encrypt SSL |
| **Tailscale** | Zero-config mesh VPN |
| **Cloudflare Tunnel** | Secure tunnel (optional) |

### Security

| Layer | Tool | Function |
|-------|------|----------|
| Firewall | **UFW** | Cloudflare-only HTTP/HTTPS access |
| IDS/IPS | **CrowdSec** | Auto-detect & ban attackers |
| Antivirus | **ClamAV** | Daily malware scanning |
| SSH | **Hardened** | Custom port, key-only auth, no root login |

### System Optimizations

| Feature | Details |
|---------|---------|
| **Swap** | 4GB swapfile |
| **Kernel** | Optimized sysctl parameters |
| **Updates** | Automatic security patches |
| **Logging** | Logrotate + JSON Docker logs (10MB max) |
| **Monitoring** | Resource alerts every 2 minutes via cron |
| **Resource Limits** | CPU & memory limits per container |

---

## Requirements

| Resource | Minimum |
|----------|---------|
| **OS** | Ubuntu 24.04 LTS |
| **CPU** | 2 vCPUs |
| **RAM** | 8 GB |
| **Disk** | 100 GB SSD |
| **Network** | Public IP + Domain with DNS configured |

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/mmsal512/server-boilerplate.git
cd server-boilerplate
```

### 2. Configure your environment

```bash
cp .env.example .env
nano .env
```

Fill in all required variables. See [Variable Reference](#variable-reference) below.

### 3. Generate strong passwords

```bash
# Generate random passwords for your .env file
openssl rand -hex 32    # For API keys
openssl rand -base64 24 # For database passwords
```

### 4. Deploy everything

```bash
sudo bash setup.sh
```

The script will automatically:
1. Update system & install dependencies
2. Install Docker & create networks
3. Harden SSH & configure UFW firewall
4. Install CrowdSec IDS/IPS & ClamAV antivirus
5. Generate all config files from your `.env`
6. Deploy all Docker stacks
7. Setup cron jobs & Cloudflare Tunnel (if configured)

---

## Project Structure

```
server-boilerplate/
│
├── .env.example                    # Master config template (copy to .env)
├── setup.sh                        # Main deployment script
│
├── my-stack/
│   ├── docker-compose.yml          # All application services
│   ├── odoo-config/
│   │   └── odoo.conf               # Odoo ERP configuration
│   └── postgres-config/
│       └── postgresql.conf          # PostgreSQL tuning
│
├── tailscale-stack/
│   └── docker-compose.yml          # Tailscale VPN service
│
├── security/
│   ├── setup-ufw.sh                # Firewall rules (Cloudflare IPs)
│   ├── setup-ssh.sh                # SSH hardening
│   ├── setup-crowdsec.sh           # IDS/IPS installation
│   ├── setup-clamav.sh             # Antivirus setup
│   └── crowdsec/
│       ├── acquis.yaml             # Log acquisition sources
│       └── profiles.yaml           # Ban profiles
│
├── system/
│   ├── setup-swap.sh               # 4GB swap creation
│   ├── setup-sysctl.sh             # Kernel optimizations
│   └── setup-auto-upgrades.sh      # Auto security updates
│
├── scripts/
│   ├── monitor_resources.sh        # CPU/RAM/Disk monitoring
│   └── setup-cron.sh               # Cron job installation
│
└── docs/
    └── VARIABLES.md                # Complete variable reference
```

---

## Variable Reference

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DOMAIN_NAME` | Your main domain | `example.com` |
| `SSL_EMAIL` | Email for SSL certificates | `admin@example.com` |
| `GENERIC_TIMEZONE` | Server timezone | `Asia/Riyadh` |
| `SSH_PORT` | SSH port (avoid 22) | `2026` |
| `SSH_USERNAME` | Non-root SSH user | `mohammed` |
| `EVOLUTION_DB_PASSWORD` | Evolution PostgreSQL password | *random* |
| `ODOO_DB_PASSWORD` | Odoo PostgreSQL password | *random* |
| `ODOO_ADMIN_PASSWORD` | Odoo master password | *random* |
| `EVOLUTION_API_KEY` | Evolution API auth key | `openssl rand -hex 32` |
| `TS_AUTHKEY` | Tailscale auth key | [Get from dashboard](https://login.tailscale.com/admin/settings/keys) |

### Optional Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `EVOLUTION_REDIS_PREFIX_KEY` | `evolution_v2` | Redis cache prefix |
| `TS_HOSTNAME` | `server-tailscale` | Tailscale device name |
| `N8N_EXECUTIONS_PROCESS` | `main` | n8n execution mode |
| `N8N_PUSH_BACKEND` | `websocketa` | n8n real-time method |
| `CLOUDFLARE_TUNNEL_TOKEN` | *(empty)* | Cloudflare Tunnel token |
| `NEXTJS_IMAGE` | `mohammed512/odoo-nextjs-frontend:latest` | Frontend Docker image |

> Full reference: [`docs/VARIABLES.md`](docs/VARIABLES.md)

---

## Post-Deployment

### Verify services are running

```bash
docker ps
```

### View logs

```bash
# All services
docker compose -f my-stack/docker-compose.yml logs -f

# Specific service
docker compose -f my-stack/docker-compose.yml logs -f n8n
```

### Check security status

```bash
# Firewall
sudo ufw status

# CrowdSec active bans
sudo cscli decisions list

# CrowdSec alerts
sudo cscli alerts list
```

### Tailscale status

```bash
docker exec tailscale tailscale status
```

---

## Container Resource Allocation

Optimized for a 2 vCPU / 8GB RAM server:

| Container | CPU Limit | Memory Limit | Memory Reserved |
|-----------|-----------|-------------|-----------------|
| Traefik | 0.5 | 256 MB | 128 MB |
| Portainer | 0.5 | 256 MB | 64 MB |
| Glances | — | 1 GB | 128 MB |
| n8n | 1.0 | 1.2 GB | 512 MB |
| Redis (n8n) | 0.2 | 256 MB | 64 MB |
| Evolution API | 0.5 | 512 MB | 256 MB |
| PostgreSQL (Evo) | 0.5 | 512 MB | 256 MB |
| Redis (Evo) | 0.2 | 256 MB | 64 MB |
| Odoo | 1.5 | 2.5 GB | 1 GB |
| PostgreSQL (Odoo) | 1.0 | 1.5 GB | 1 GB |
| Next.js | 0.8 | 1 GB | 256 MB |
| Redis (Odoo cache) | 0.2 | 256 MB | 64 MB |
| Tailscale | 0.1 | 128 MB | 64 MB |

---

## Security Details

### Firewall (UFW)

HTTP/HTTPS traffic is restricted to **Cloudflare IP ranges only**, preventing direct server access. SSH is allowed on the custom port from anywhere.

### CrowdSec

Monitors Traefik access logs, Odoo logs, PostgreSQL logs, and system auth logs. Automatically bans malicious IPs for 24 hours using iptables.

### ClamAV

Runs daily smart scans at 5 AM on critical directories (`/root`, `/home`, `/tmp`, `/etc`). Infected files are moved to `/root/quarantine`. Virus definitions update daily at 4 AM.

### SSH Hardening

Custom port, public key authentication only, password login disabled, root login disabled, single allowed user.

---

## Cron Jobs

| Schedule | Job |
|----------|-----|
| Every 2 min | Resource monitoring (CPU/RAM/Disk alerts) |
| Daily 3 AM | Clean quarantine (files > 30 days) |
| Daily 4 AM | Update ClamAV virus database |
| Daily 5 AM | Smart ClamAV scan |

---

## License

This project is licensed under the [MIT License](LICENSE).
```