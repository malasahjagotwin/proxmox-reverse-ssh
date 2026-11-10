# Proxmox Reverse SSH Tunnel

Panduan akses **Proxmox (PVE)** dan **LXC container (CT)** yang berada di balik NAT / tanpa IP publik, lewat sebuah VPS dengan IP publik — menggunakan **Reverse SSH Tunnel** (`ssh -R`).

---

## Konsep

```
 [ Laptop kamu ]                        [ VPS (IP publik) ]                      [ Rumah / Lab ]
       |                                        |                                        |
       |  ssh -p 1001 root@<VPS_IP>  -------->  :1001  --- tunnel --->  CT.local:22 (sshd)
       |  https://<VPS_IP>:8006      -------->  :8006  --- tunnel --->  PVE.local:8006
       |                                        |                                        |
```

Server lokal (CT / PVE) **mendial keluar** ke VPS dan membuat *listener* di VPS.
Siapa pun yang konek ke port tersebut di VPS akan diteruskan ke server lokal.
Tidak perlu port-forwarding di router / ISP.

---

## 1. Setup sisi VPS (sekali saja)

Agar tunnel boleh bind ke `0.0.0.0` (bisa diakses dari internet), VPS perlu `GatewayPorts`.

```bash
# /etc/ssh/sshd_config.d/99-reverse-tunnel.conf
GatewayPorts clientspecified
```

```bash
sshd -t && systemctl restart ssh
sshd -T | grep -i '^gatewayports'   # harus: gatewayports clientspecified
```

Pastikan port yang dipakai bebas & firewall terbuka:

```bash
ss -tlnp | grep ':1001'      # cek port terpakai
ufw allow 1001/tcp           # kalau pakai ufw
```

---

## 2. Setup sisi klien (server lokal)

Template systemd service — otomatis nyala saat boot & reconnect kalau putus.

```bash
VPS=root@<VPS_IP>
KEY=/root/.ssh/id_tunnel

ssh-keygen -t ed25519 -N '' -f "$KEY" -C "$(hostname)-tunnel"
ssh-copy-id -i "$KEY.pub" "$VPS"

cat >/etc/systemd/system/reverse-ssh.service <<'EOF'
[Unit]
Description=Reverse SSH tunnel ke VPS
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/ssh -N \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o StrictHostKeyChecking=accept-new \
  -i /root/.ssh/id_tunnel \
  -R 0.0.0.0:1001:localhost:22 \
  root@<VPS_IP>
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable --now reverse-ssh
systemctl is-active reverse-ssh
```

Ganti `1001` dengan port yang diinginkan di VPS, dan `localhost:22` dengan target (mis. `192.168.1.15:8006` untuk web UI PVE).

---

## 3. Cara akses

| Layanan | Perintah |
|---|---|
| SSH ke sebuah CT | `ssh -p 1001 root@<VPS_IP>` |
| Web UI Proxmox | `https://<VPS_IP>:8006` |
| RDP ke Windows (tunnel 3389) | `mstsc /v:<VPS_IP>:3389` |

> Port di VPS = "pintu" ke server lokal. Kredensial login adalah kredensial **server lokal**, bukan VPS.

---

## 4. Contoh: RDP Windows lewat tunnel

Di Windows (PowerShell admin):

```powershell
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

ssh -N -o ServerAliveInterval=30 -o ServerAliveCountMax=3 `
  -i C:\ProgramData\ssh-tunnel\id_tunnel `
  -R 0.0.0.0:3389:localhost:3389 root@<VPS_IP>
```

---

## 5. Troubleshooting

| Gejala | Penyebab umum | Solusi |
|---|---|---|
| `Connection refused` di port VPS | tunnel belum jalan / service mati | `systemctl restart reverse-ssh`, cek `is-active` |
| `Permission denied (publickey,password)` | `PermitRootLogin` dibatasi di target | `PermitRootLogin yes` + restart sshd |
| Mutus-mutus sendiri | NAT/router buang koneksi idle | `ServerAliveInterval 30`, `Restart=always` |
| `No route to host` | CT/VM belum punya internet | cek IP/gateway/DNS di Proxmox |
| sshd nolak koneksi baru saat ramai | `MaxStartups` limit | rate-limit SSH di VPS |

---

## 6. Hardening (penting!)

- **Jangan pakai password lemah / root langsung** kalau bisa — pakai SSH key.
- Rate-limit port 22 di VPS (bot brute-force itu normal & terus-menerus):
  ```bash
  iptables -N SSH_GUARD
  iptables -A SSH_GUARD -m recent --name sshguard --update --seconds 60 --hitcount 8 -j DROP
  iptables -A SSH_GUARD -m recent --name sshguard --set -j RETURN
  iptables -I INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j SSH_GUARD
  ```
- Kalau bisa, batasi port tunnel hanya untuk IP publik kamu: `iptables -A INPUT -p tcp --dport 1001 ! -s <IP_KAMU> -j DROP`.
- Jangan pernah commit token/private key/password ke repo ini.

---

## Struktur

```
.
├── README.md
└── scripts/
    ├── reverse-ssh.service      # template systemd
    └── install-tunnel.sh        # script setup cepat
```
