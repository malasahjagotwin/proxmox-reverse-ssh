# Proxmox Reverse SSH Tunnel 🚀

Secure, production-grade guide and scripts to expose local Proxmox VE & LXC/VM containers behind NAT via a public VPS.

## Features
- **Zero Port Forwarding**: Uses outbound SSH reverse tunnels (`-R`).
- **Auto-reconnect & Systemd**: Persistent connection with automatic recovery.
- **Hardened Security**: ED25519 authentication & rate-limiting guides.

## Repository Structure
- `README.md`: Comprehensive step-by-step documentation.
- `scripts/install-tunnel.sh`: Automated setup script.
- `.github/workflows/ci.yml`: Automated validation check.
