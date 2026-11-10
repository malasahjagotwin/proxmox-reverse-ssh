#!/usr/bin/env bash
set -e
systemctl disable --now reverse-ssh 2>/dev/null || true
rm -f /etc/systemd/system/reverse-ssh.service
systemctl daemon-reload
echo "Tunnel dihapus."
