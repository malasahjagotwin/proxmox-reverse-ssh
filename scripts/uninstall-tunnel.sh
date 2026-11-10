#!/usr/bin/env bash
# Hapus reverse tunnel service
set -e
systemctl disable --now reverse-ssh
rm -f /etc/systemd/system/reverse-ssh.service
systemctl daemon-reload
echo "Tunnel dihapus."
