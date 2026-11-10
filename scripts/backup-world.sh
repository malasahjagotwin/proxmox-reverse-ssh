#!/usr/bin/env bash
# Backup world Minecraft + rotasi 7 hari. Jalankan via cron harian.
set -euo pipefail
DIR="${1:-/opt/minecraft}"; KEEP=7
STAMP=$(date +%F_%H%M)
tar -czf "$DIR/backups/world-$STAMP.tar.gz" -C "$DIR" world world_nether world_the_end 2>/dev/null || tar -czf "$DIR/backups/world-$STAMP.tar.gz" -C "$DIR" world
find "$DIR/backups" -name 'world-*.tar.gz' -mtime +$KEEP -delete
echo "Backup selesai: world-$STAMP.tar.gz"
