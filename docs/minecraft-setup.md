# Setup Minecraft (Paper + Via*)

1. Install Java 17: `apt install openjdk-17-jre-headless`
2. Download Paper 1.20.4 dan simpan sebagai `server.jar`
3. `eula.txt` -> `eula=true`
4. Plugin wajib di `plugins/`:
   - ViaVersion (klien versi baru)
   - ViaBackwards (klien versi lama)
   - ViaRewind (1.8 ke bawah)
5. `server.properties` penting:
   - `view-distance=16`, `simulation-distance=12`
   - `online-mode=false` (kalau pemain pakai cracked/offline)
   - `motd=` pakai kode warna §a §b §e
6. Jalankan: `screen -dmS mc java -Xms512M -Xmx1G -jar server.jar nogui`
