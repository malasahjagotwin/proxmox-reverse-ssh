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

## FAQ

**Q: Kenapa harus reverse tunnel, bukan port-forwarding?**
A: Karena banyak ISP Indonesia pakai CGNAT (IP publik dibagi), jadi port-forwarding gak mungkin.

**Q: Tunnel putus pas listrik mati?**
A: Service `Restart=always` bikin dia nyambung otomatis begitu boot.

**Q: Bisa buat game lain selain Minecraft?**
A: Bisa. Format `-R 0.0.0.0:PORT_VPS:localhost:PORT_LOKAL` berlaku buat TCP apa aja (RDP, HTTP, dll).
