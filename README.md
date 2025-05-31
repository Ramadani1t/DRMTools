# 🔑 DRMTools
A 2in1 Script To Download DRM Media &amp; Decryptor DRM Widevine API Solution
![](https://github.com/Ramadani1t/DRM-DL-nd-DRM-DEC/blob/main/image/smintty.2025-05-31_19-37-15.png?raw=true)

## Isi File
Pastikan kedua skrip ini ditempatkan pada script yang sama agar pemecahan kunci widevine dengan API ini bisa berfungsi dengan semestinya
- DRMTools.sh
- get_keys.py

## ✨ Fitur
![](https://github.com/Ramadani1t/DRM-DL-nd-DRM-DEC/blob/main/image/thumnail.png?raw=true)
##### DRM Downloader
DRM Downloader adalah skrip untuk mendowload file media seperti audio, video atau subtitle menggunakan yt-dlp dengan dukungan https dan cookie oleh aria2c serta python
- Download Audio
- Download Video
- Download Audio dan Video Bersamaan
- Pemilihan Kualitas File dengan yt-dlp format
- External download manager oleh aria2c
- Penggabungan, pemberian nama audio dan video oleh ffmpeg

##### DRM Decryptor
DRM Decryptor adalah skrip untuk decrypt file media seperti audio dan video yang dilindungi, terenkripsi atau terkunci oleh DRM yang hanya bisa diakses oleh satu arah saja oleh perangkat pemutar dengan sertifikasi khusus oleh konten hak cipta dengan teknologi widevine
- Pemecahan Kunci Widevine Otomatis Online dengan API (cdrm-project.com)
- Python API cdrm-project Response POST dan GET
- Dekriptor support hingga 3 baris kunci widevine oleh mp4decrypt
- Ekstrak codec media audio dan video oleh ffmpeg
- Tidak butuh file sertifikasi widevine perangkat untuk bisa mencari kunci DRM Widevine
- Dibutuhkan PSSH, dan URL License dengan User Agent untuk pemecahan kunci oleh API

## ❗ Perhatian
Harap install depedensi ini agar skrip bisa digunakan dengan lancar
- Python / python3
- Python requests
- ffmpeg
- aria2c
- mp4decript / bento4
- yt-dlp
