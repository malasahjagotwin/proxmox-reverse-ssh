# Proxmox Reverse SSH Tunnel (English)

Expose local Proxmox/CT/VM services behind NAT via a public VPS using SSH reverse tunnels (`-R`).

- No port-forwarding needed (works with CGNAT ISPs)
- systemd service with auto-reconnect
- Server: `GatewayPorts clientspecified` in sshd_config
- Client: `ssh -N -R 0.0.0.0:PORT:localhost:TARGET root@VPS`

Full guide: see [README.md](README.md) (Bahasa Indonesia).
