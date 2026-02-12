<div align="center">

# Server Boilerplate

### One-command full-stack server deployment with Docker & security hardening

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/Docker-29.2-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

OverviewA production-ready server boilerplate that deploys a complete stack of applications behind Traefik reverse proxy with automatic SSL, multi-layer security hardening, VPN access, and system optimizations — all configured through a single .env file.Designed for Ubuntu 24.04 LTS servers with 2+ vCPUs and 8GB+ RAM.Architectureمقتطف الرمزgraph TD
    User((Internet)) --> Cloudflare
    Cloudflare --> Firewall[UFW Firewall + CrowdSec]
    Firewall --> Traefik[Traefik Reverse Proxy]
    
    subgraph "Docker Swarm / Compose"
        Traefik --> n8n
        Traefik --> Portainer
        Traefik --> Odoo
        Traefik --> Evolution[Evolution API]
        Traefik --> NextJS
    end
    
    Tailscale[Tailscale VPN] -.->|Secure Access| SSH
    Tailscale -.->|Internal Access| Portainer
What's IncludedApplicationsServiceDescriptionSubdomainn8nWorkflow automationdomain.comOdoo 16ERP system + PostgreSQLodoo.domain.comEvolution APIWhatsApp integration + PostgreSQL + Redisevo.domain.comNext.jsFrontend applicationnext.domain.comPortainerDocker management UIportainer.domain.comGlancesReal-time system monitoringmonitor.domain.com
