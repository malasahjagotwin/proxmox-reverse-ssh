#!/usr/bin/env bash
# Setup reverse SSH tunnel ke VPS. Jalankan sebagai root di server lokal.
set -euo pipefail

VPS="${VPS:-root@<VPS_IP>}"
PORT="${PORT:-1001}"        # port listener di VPS
TARGET="${TARGET:-localhost:22}"
KEY="${KEY:-/root/.ssh/id_tunnel}"

[ -f "$KEY" ] || ssh-keygen -t ed25519 -N '' -f "$KEY" -C "$(hostname)-tunnel"
ssh-copy-id -i "$KEY.pub" "$VPS"

cat >/etc/systemd/system/reverse-ssh.service <<EOF
[Unit]
Description=Reverse SSH tunnel ke VPS
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/ssh -N -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=accept-new -i $KEY -R 0.0.0.0:$PORT:$TARGET $VPS
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now reverse-ssh
systemctl is-active reverse-ssh
