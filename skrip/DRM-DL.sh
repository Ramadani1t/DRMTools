#!/bin/bash
set +H # Menonaktifkan history expansion untuk menghindari error '!'

# Direktori output untuk file yang diunduh dan didekripsi.
OUTPUT_DIR="C:/DRMDECRPYT"

# Pastikan Python terinstal dan bisa diakses.
PYTHON_CMD="python"

# Buat direktori jika belum ada
mkdir -p "$OUTPUT_DIR"

# --- Definisi Warna ANSI Escape Codes (Untuk Seluruh Skrip) ---
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
RESET='\033[0m'
DARK_GRAY='\033[90m' # Untuk bayangan ASCII art

# --- FUNGSI BANNER UTAMA (DRM-DL) ---
show_main_banner() {
    echo -e "${CYAN}===============================================================${RESET}"
    echo -e "${CYAN}         -- 2in1 DRM SCRIPT DOWNLOADER & DECRYPTOR --             ${RESET}"
    echo -e "${CYAN}                      DRM-DL & DRM-DEC                              ${RESET}"
    echo -e "${CYAN}===============================================================${RESET}"
    echo

    # ASCII ART huruf besar DRM-DL (lebar 9 karakter per huruf)
    # D
    D_ART=(
    " _____   "
    "|  __ \\  "
    "| |  | | "
    "| |  | | "
    "| |__| | "
    "|_____/  "
    )

    # R
    R_ART=(
    " _____   "
    "|  __ \\  "
    "| |__) | "
    "|  _  /  "
    "| | \\ \\  "
    "|_|  \\_\\ "
    )

    # M
    M_ART=(
    " __   __ "
    "|  \\/  | "
    "| \\  / | "
    "| |\\/| | "
    "| |  | | "
    "|_|  |_| "
    )

    # DASH (-)
    DASH_ART=(
    "         "
    "         "
    "  _____  "
    " |_____| "
    "         "
    "         "
    )

    # L
    L_ART=(
    " _       "
    "| |      "
    "| |      "
    "| |      "
    "| |____  "
    "|______| "
    )

    # Cetak baris per baris (horizontal) dengan warna dan tanpa bayangan di banner utama
    # Karena di banner utama, kita ingin lebih fokus pada nama skrip yang jelas
    for i in {0..5}; do
        echo -e "${RED}${D_ART[i]}${RESET}  ${GREEN}${R_ART[i]}  ${BLUE}${M_ART[i]}  ${CYAN}${DASH_ART[i]}  ${YELLOW}${D_ART[i]}  ${MAGENTA}${L_ART[i]}${RESET}"
    done

    echo
    echo -e "${CYAN}===============================================================${RESET}"
    echo -e "${CYAN}                       Oleh: @ramaja                        ${RESET}"
    echo -e "${CYAN}===============================================================${RESET}"
    echo
}

# --- FUNGSI BANNER DEKRIPSI (DRM-DEC) ---
show_decrypt_banner() {
    clear # Bersihkan layar saat menampilkan banner ini
    echo -e "${CYAN}==========================================================================${RESET}"
    echo -e "${CYAN}                    -- SCRIPT DECRYPTOR & DOWNLOADER --             ${RESET}"
    echo -e "${CYAN}                              DRM-DEC & DRM DL                           ${RESET}"
    echo -e "${CYAN}==========================================================================${RESET}"
    echo

    # Huruf ASCII DRM-DEC (lebar 9 karakter)
    D_DEC=(
    " _____   "
    "|  __ \\  "
    "| |  | | "
    "| |  | | "
    "| |__| | "
    "|_____/  "
    )
    R_DEC=(
    " _____   "
    "|  __ \\  "
    "| |__) | "
    "|  _  /  "
    "| | \\ \\  "
    "|_|  \\_\\ "
    )
    M_DEC=(
    " __   __ "
    "|  \\/  | "
    "| \\  / | "
    "| |\\/| | "
    "| |  | | "
    "|_|  |_| "
    )
    DASH_DEC=(
    "         "
    "         "
    "  _____  "
    " |_____| "
    "         "
    "         "
    )
    E_DEC=(
    " ______  "
    "|  ____| "
    "| |__    "
    "|  __|   "
    "| |____  "
    "|______| "
    )
    C_DEC=(
    "  _____  "
    " / ____| "
    "| |      "
    "| |      "
    "| |____  "
    " \\_____| "
    )

    # Cetak baris per baris
    for i in {0..5}; do
      echo -e "${RED}${D_DEC[i]}  ${GREEN}${R_DEC[i]}  ${BLUE}${M_DEC[i]}  ${CYAN}${DASH_DEC[i]}  ${YELLOW}${D_DEC[i]}  ${MAGENTA}${E_DEC[i]}  ${WHITE}${C_DEC[i]}${RESET}"
    done
    echo
    echo -e "${CYAN}==========================================================================${RESET}"
    echo -e "${CYAN}                               Oleh: @ramaja                        ${RESET}"
    echo -e "${CYAN}==========================================================================${RESET}"
    echo
}


# --- Fungsi untuk Meminta Kunci dari API (cdrm-project.com) ---
get_decryption_keys_from_api() {
    DECRYPTION_KEYS=() # Reset array kunci

    echo -e "\n\e[36m--- Pemecahan Kunci Otomatis dengan API (cdrm-project.com) ---\e[0m"
    echo -e "\e[33mPetunjuk:\e[0m"
    echo -e "\e[33m - Masukkan kode PSSH yang terdapat di dalam file stream MPD atau M3U8 Anda.\e[0m"
    echo -e "\e[33m - Masukkan License URL ketika pemutar video berjalan (disarankan menggunakan fitur Inspect/Developer Tools di browser).\e[0m"
    read -p "Masukkan PSSH: " pssh_input
    read -p "Masukkan License URL: " licurl_input
    read -p "Masukkan User-Agent (Opsional, tekan Enter untuk default): " user_agent_input

    echo -e "\e[36mMengirim permintaan kunci ke API...\e[0m"
    
    PYTHON_ARGS=("$pssh_input" "$licurl_input")
    if [ -n "$user_agent_input" ]; then
        PYTHON_ARGS+=("$user_agent_input")
    fi

    if ! mapfile -t raw_keys < <("$PYTHON_CMD" "${OUTPUT_DIR}/get_keys.py" "${PYTHON_ARGS[@]}"); then
        echo -e "\e[31mError: Gagal mendapatkan kunci dari API. Silakan cek pesan error di atas.\e[0m"
        return 1 # Mengindikasikan kegagalan
    fi

    if [ ${#raw_keys[@]} -eq 0 ]; then
        echo -e "\e[31mTidak ada kunci yang diterima dari API. Pastikan PSSH dan License URL benar.\e[0m"
        return 1 # Mengindikasikan kegagalan
    fi

    for key_pair in "${raw_keys[@]}"; do
        DECRYPTION_KEYS+=("--key" "$key_pair")
    done

    echo -e "\e[32mKunci berhasil didapatkan dari API!\e[0m"
    return 0 # Mengindikasikan keberhasilan
}

# --- Fungsi untuk Input Kunci Manual ---
get_decryption_keys_manual() {
    DECRYPTION_KEYS=() # Reset array kunci
    local num_keys

    echo -e "\n\e[36m--- Input Kunci Dekripsi Manual ---\e[0m"
    echo -e "\e[33mPilih jumlah kunci yang ingin dimasukkan:\e[0m"
    echo -e "\e[33m1. 1 Key DRM\e[0m"
    echo -e "\e[33m2. 2 Key DRM\e[0m"
    echo -e "\e[33m3. 3 Key DRM\e[0m"
    read -p "Pilihan Anda (1-3): " num_keys_choice

    case "$num_keys_choice" in
        1) num_keys=1 ;;
        2) num_keys=2 ;;
        3) num_keys=3 ;;
        *)
            echo -e "\e[31mPilihan tidak valid. Kembali ke menu utama.\e[0m"
            return 1 # Mengindikasikan kegagalan
            ;;
    esac

    for (( i=1; i<=num_keys; i++ )); do
        read -p "Masukkan Key DRM #${i} (format KID:KEY, contoh: 1234...:abcd...): " key_input
        if [ -n "$key_input" ]; then
            DECRYPTION_KEYS+=("--key" "$key_input")
        else
            echo -e "\e[31mKunci #${i} kosong. Membatalkan input kunci.\e[0m"
            return 1 # Mengindikasikan kegagalan
        fi
    done

    echo -e "\e[32mKunci manual berhasil diinput!\e[0m"
    return 0 # Mengindikasikan keberhasilan
}

# --- Fungsi untuk Proses Dekripsi (dipanggil setelah download) ---
process_decryption() {
    local encrypted_file="$1"
    local decrypted_file="$2"
    local file_type="$3" # "video" atau "audio"

    show_decrypt_banner # Tampilkan banner DRM-DEC

    echo -e "\n\e[36mPilih metode dekripsi untuk ${file_type}:\e[0m"
    echo -e "\e[33m1. Input Manual Key\e[0m"
    echo -e "\e[33m2. Pemecahan Kunci Otomatis dengan API (cdrm-project.com)\e[0m"
    read -p "Pilihan Anda (1 atau 2): " decrypt_option

    case "$decrypt_option" in
        1)
            get_decryption_keys_manual
            if [ $? -ne 0 ]; then return 1; fi # Keluar jika input manual gagal
            ;;
        2)
            get_decryption_keys_from_api
            if [ $? -ne 0 ]; then return 1; fi # Keluar jika API gagal
            ;;
        *)
            echo -e "\e[31mPilihan tidak valid. Dekripsi dibatalkan.\e[0m"
            return 1 # Mengindikasikan kegagalan
            ;;
    esac

    echo -e "\e[36mMendekripsi ${file_type}...\e[0m"
    mp4decrypt "$encrypted_file" "$decrypted_file" "${DECRYPTION_KEYS[@]}"
    if [ $? -ne 0 ]; then
        echo -e "\e[31mError: Dekripsi ${file_type} gagal. Pastikan kunci dan formatnya benar.\e[0m"
        return 1
    fi
    echo -e "\e[32mDekripsi ${file_type} berhasil!\e[0m"

    # --- TAMBAHAN BARU: Meminta Nama Baru Setelah Dekripsi ---
    echo -e "\e[36mDekripsi ${file_type} selesai. Ingin memberi nama baru pada file hasil dekripsi?\e[0m"
    read -p "Ya/Tidak (y/n): " rename_choice
    if [[ "$rename_choice" =~ ^[Yy]$ ]]; then
        echo "Masukkan nama baru untuk file ${file_type} (tanpa ekstensi):"
        read -r new_name
        local clean_new_name=$(echo "$new_name" | tr -d '\/*?<>|:"')
        local current_ext=$(echo "$decrypted_file" | sed 's/.*\.//') # Ambil ekstensi dari file_dekripsi
        mv "$decrypted_file" "${OUTPUT_DIR}/${clean_new_name}.${file_type}.decrypted.${current_ext}"
        if [ $? -ne 0 ]; then
            echo -e "\e[31mError: Gagal mengganti nama file. File asli tetap di: ${decrypted_file}\e[0m"
        else
            echo -e "\e[32mFile ${file_type} berhasil diganti nama menjadi: ${clean_new_name}.${file_type}.decrypted.${current_ext}\e[0m"
        fi
    else
        echo -e "\e[33mFile ${file_type} hasil dekripsi tetap bernama: $(basename "$decrypted_file")\e[0m"
    fi
    # --- AKHIR TAMBAHAN BARU ---

    return 0
}

# --- Loop Utama Menu ---
while true; do
    clear # Bersihkan layar setiap kali menu utama ditampilkan
    show_main_banner # Tampilkan banner utama DRM-DL

    echo -e "\e[36mOpsi Download:\e[0m"
    echo -e "\e[33m1. Download Audio Saja\e[0m"
    echo -e "\e[33m2. Download Video Saja\e[0m"
    echo -e "\e[33m3. Script Komplit Dijalankan (Download Video & Audio)\e[0m"
    echo -e "\e[33m4. Gabungkan Video dan Audio (File sudah terunduh & terdekripsi)\e[0m"
    echo -e "\e[33m5. Keluar\e[0m"
    echo
    read -r option

    case $option in
        1) # Download Audio Saja
            echo -e "\e[36mMasukkan URL MPD:\e[0m"
            read -r stream
            yt-dlp --list-formats --external-downloader aria2c --allow-unplayable-formats -F "$stream" -v
            echo -e "\e[36mID Kualitas Audio:\e[0m"
            read -r audio
            echo
            yt-dlp --external-downloader aria2c --allow-unplayable-formats --continue --verbose -f "$audio" "$stream" -o "${OUTPUT_DIR}/encrypted_Suara.%(ext)s"
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Download audio gagal.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo -e "\e[32mAudio berhasil diunduh!\e[0m"
            echo

            # Temukan dan ganti nama file yang diunduh
            find "${OUTPUT_DIR}" -maxdepth 1 -name "*.m4a" -exec mv {} "${OUTPUT_DIR}/encrypted_Suara.m4a" \;
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Gagal mengganti nama file audio. Pastikan file .m4a terunduh.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue # Kembali ke menu utama
            fi

            process_decryption "${OUTPUT_DIR}/encrypted_Suara.m4a" "${OUTPUT_DIR}/decrypt.audio.m4a" "audio"
            if [ $? -ne 0 ]; then # Cek apakah fungsi dekripsi berhasil
                read -r -p "Tekan enter untuk melanjutkan"
                continue # Kembali ke menu utama
            fi
            read -r -p "Tekan enter untuk melanjutkan"
            ;;

        2) # Download Video Saja
            echo -e "\e[36mMasukkan URL MPD:\e[0m"
            read -r stream
            yt-dlp --list-formats --external-downloader aria2c --allow-unplayable-formats -F "$stream" -v
            echo -e "\e[36mID Kualitas Video:\e[0m"
            read -r video
            echo
            yt-dlp --external-downloader aria2c --allow-unplayable-formats --continue --verbose -f "$video" "$stream" -o "${OUTPUT_DIR}/encrypted_Video.%(ext)s"
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Download video gagal.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo -e "\e[32mVideo Berhasil diunduh!\e[0m"
            echo

            # Temukan dan ganti nama file yang diunduh
            find "${OUTPUT_DIR}" -maxdepth 1 -name "*.mp4" -exec mv {} "${OUTPUT_DIR}/encrypted_Video.mp4" \;
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Gagal mengganti nama file video. Pastikan file .mp4 terunduh.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue # Kembali ke menu utama
            fi

            process_decryption "${OUTPUT_DIR}/encrypted_Video.mp4" "${OUTPUT_DIR}/decrypt.video.mp4" "video"
            if [ $? -ne 0 ]; then
                read -r -p "Tekan enter untuk melanjutkan"
                continue # Kembali ke menu utama
            fi
            read -r -p "Tekan enter untuk melanjutkan"
            ;;

        3) # Script Komplit Dijalankan (Download Video & Audio)
            echo -e "\e[36mMasukkan URL MPD:\e[0m"
            read -r stream
            yt-dlp --list-formats --external-downloader aria2c --allow-unplayable-formats -F "$stream" -v
            echo -e "\e[36mID Kualitas Video:\e[0m"
            read -r video
            echo
            echo -e "\e[36mID Kualitas Audio:\e[0m"
            read -r audio
            echo
            yt-dlp --external-downloader aria2c --allow-unplayable-formats --continue --verbose -f "$video"+"$audio" "$stream" -o "${OUTPUT_DIR}/encrypted.%(ext)s"
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Download video atau audio gagal.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo -e "\e[32mVideo dan audio berhasil diunduh!\e[0m"
            echo

            # Temukan dan ganti nama file yang diunduh
            find "${OUTPUT_DIR}" -maxdepth 1 -name "*.mp4" -exec mv {} "${OUTPUT_DIR}/encrypted_Video.mp4" \;
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Gagal mengganti nama file video. Pastikan file .mp4 terunduh.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            find "${OUTPUT_DIR}" -maxdepth 1 -name "*.m4a" -exec mv {} "${OUTPUT_DIR}/encrypted_Suara.m4a" \;
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Gagal mengganti nama file audio. Pastikan file .m4a terunduh.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo

            # Proses Dekripsi Video
            process_decryption "${OUTPUT_DIR}/encrypted_Video.mp4" "${OUTPUT_DIR}/decrypt.video.mp4" "video"
            if [ $? -ne 0 ]; then
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo

            # Proses Dekripsi Audio (gunakan kunci yang sama dari proses_decryption sebelumnya)
            # Jika ingin kunci berbeda untuk audio, panggil process_decryption lagi
            # Namun umumnya Widevine menggunakan satu set kunci untuk semua track dari satu PSSH
            echo -e "\e[36mMendekripsi audio dengan kunci yang sama...\e[0m"
            mp4decrypt "${OUTPUT_DIR}/encrypted_Suara.m4a" "${OUTPUT_DIR}/decrypt.audio.m4a" "${DECRYPTION_KEYS[@]}"
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Dekripsi audio gagal. Pastikan kunci dan formatnya benar.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo -e "\e[32mDekripsi audio berhasil!\e[0m"

            # --- TAMBAHAN BARU: Meminta Nama Baru Setelah Dekripsi Audio ---
            echo -e "\e[36mDekripsi audio selesai. Ingin memberi nama baru pada file hasil dekripsi?\e[0m"
            read -p "Ya/Tidak (y/n): " rename_audio_choice
            if [[ "$rename_audio_choice" =~ ^[Yy]$ ]]; then
                echo "Masukkan nama baru untuk file audio (tanpa ekstensi):"
                read -r new_audio_name
                local clean_new_audio_name=$(echo "$new_audio_name" | tr -d '\/*?<>|:"')
                mv "${OUTPUT_DIR}/decrypt.audio.m4a" "${OUTPUT_DIR}/${clean_new_audio_name}.audio.decrypted.m4a"
                if [ $? -ne 0 ]; then
                    echo -e "\e[31mError: Gagal mengganti nama file audio. File asli tetap di: ${OUTPUT_DIR}/decrypt.audio.m4a\e[0m"
                else
                    echo -e "\e[32mFile audio berhasil diganti nama menjadi: ${clean_new_audio_name}.audio.decrypted.m4a\e[0m"
                fi
            else
                echo -e "\e[33mFile audio hasil dekripsi tetap bernama: decrypt.audio.m4a\e[0m"
            fi
            # --- AKHIR TAMBAHAN BARU ---

            echo -e "\e[36mPenggabungan Video dan Audio .........\e[0m"
            ffmpeg -y -i "${OUTPUT_DIR}/decrypt.video.mp4" -i "${OUTPUT_DIR}/decrypt.audio.m4a" -c:v copy -c:a copy -map 0:v -map 1:a -metadata:s:a:0 language=id "${OUTPUT_DIR}/Hasil_Video.mkv"
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Penggabungan video dan audio gagal. Pastikan FFmpeg terinstal dan file dekripsi valid.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo
            echo -e "\e[32mDekripsi dan penggabungan selesai!\e[0m"
            echo "Masukkan nama akhir untuk file gabungan:"
            read -r nama
            nama_clean=$(echo "$nama" | tr -d '\/*?<>|:"')
            mv "${OUTPUT_DIR}/Hasil_Video.mkv" "${OUTPUT_DIR}/${nama_clean}.DUB.INDO.mkv"
            echo -e "\e[36mNama file telah diganti menjadi ${nama_clean}.DUB.INDO.mkv\e[0m"
            read -r -p "Tekan enter untuk melanjutkan"
            ;;

        4) # Gabungkan video dan Audio (File sudah terunduh & terdekripsi)
            echo -e "\e[36mPenggabungan file yang sudah didekripsi...\e[0m"

            if [ ! -f "${OUTPUT_DIR}/decrypt.video.mp4" ] || [ ! -f "${OUTPUT_DIR}/decrypt.audio.m4a" ]; then
                echo -e "\e[31mError: File 'decrypt.video.mp4' atau 'decrypt.audio.m4a' tidak ditemukan di ${OUTPUT_DIR}. Silakan unduh dan dekripsi terlebih dahulu melalui opsi 1, 2, atau 3.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi

            ffmpeg -y -i "${OUTPUT_DIR}/decrypt.video.mp4" -i "${OUTPUT_DIR}/decrypt.audio.m4a" -c:v copy -c:a copy -map 0:v -map 1:a -metadata:s:a:0 language=id "${OUTPUT_DIR}/Hasil_Video.mkv"
            if [ $? -ne 0 ]; then
                echo -e "\e[31mError: Penggabungan video dan audio gagal. Pastikan FFmpeg terinstal dan file dekripsi valid.\e[0m"
                read -r -p "Tekan enter untuk melanjutkan"
                continue
            fi
            echo "Masukkan nama baru untuk file gabungan:"
            read -r nama
            nama_clean=$(echo "$nama" | tr -d '\/*?<>|:"')
            mv "${OUTPUT_DIR}/Hasil_Video.mkv" "${OUTPUT_DIR}/${nama_clean}.DUB.INDO.mkv"
            echo -e "\e[36mNama file telah diganti menjadi ${nama_clean}.DUB.INDO.mkv\e[0m"
            read -r -p "Tekan enter untuk melanjutkan"
            ;;
        5) # Keluar
            echo -e "\e[32mTerima kasih telah menggunakan skrip DRM-DL! Sampai jumpa.\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[31mOpsi tidak valid, silakan coba lagi.\e[0m"
            read -r -p "Tekan enter untuk melanjutkan"
            ;;
    esac
done

echo -e "\e[36mSelesai .........\e[0m"
echo
read -r -p "Tekan enter untuk melanjutkan"