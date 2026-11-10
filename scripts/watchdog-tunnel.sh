#!/usr/bin/env bash
# Cek tunnel tiap 60 detik; restart kalau port tidak listening.
PORT="${1:-1001}"
while true; do
  ss -tln | grep -q ":$PORT " || { systemctl restart reverse-ssh; logger -t watchdog "tunnel $PORT mati, direstart"; }
  sleep 60
done
