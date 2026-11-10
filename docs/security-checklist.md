# Security Checklist

- [ ] Ganti password root VPS (jangan kata umum)
- [ ] SSH key only: `PasswordAuthentication no`
- [ ] Rate-limit port 22 (iptables SSH_GUARD)
- [ ] `PermitRootLogin prohibit-password`
- [ ] Batasi port tunnel ke IP tertentu bila memungkinkan
- [ ] Aktifkan 2FA untuk PVE (`root@pam`)
- [ ] Backup world/config secara rutin (`scripts/backup-world.sh`)
- [ ] Revoke token/API key yang tidak terpakai
