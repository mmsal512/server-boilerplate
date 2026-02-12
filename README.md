<div align="center">

# Server Boilerplate

### One-command full-stack server deployment with Docker & security hardening

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/Docker-29.2-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

graph TD
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

    Service,Description,Subdomain
n8n,Workflow automation,domain.com
Odoo 16,ERP system + PostgreSQL,odoo.domain.com
Evolution API,WhatsApp integration + PostgreSQL + Redis,evo.domain.com
Next.js,Frontend application,next.domain.com
Portainer,Docker management UI,portainer.domain.com
Glances,Real-time system monitoring,monitor.domain.com
