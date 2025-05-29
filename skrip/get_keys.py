# get_keys.py
import requests
import sys
import json # Pastikan ini diimpor

def get_decryption_keys(pssh, licurl, user_agent=None):
    """
    Mengirim permintaan dekripsi ke cdrm-project.com API dan mengembalikan daftar kunci.
    """
    headers = {
        'Content-Type': 'application/json',
    }

    if user_agent is None:
        user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'
    
    # --- PERUBAHAN DI SINI ---
    # Buat dictionary dulu
    dict_payload_headers = {
        'User-Agent': user_agent,
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.5',
    }
    # Kemudian ubah dictionary ini menjadi string JSON
    json_string_payload_headers = json.dumps(dict_payload_headers)
    # --- AKHIR PERUBAHAN ---

    payload = {
        'pssh': pssh,
        'licurl': licurl,
        'headers': json_string_payload_headers # Sekarang ini adalah string JSON
    }

    try:
        response = requests.post(
            url='https://cdrm-project.com/api/decrypt',
            headers=headers,
            json=payload,
            timeout=30
        )
        response.raise_for_status()

        # --- DEBUG: Respons Mentah API (biarkan ini untuk jaga-jaga) ---
        print(f"\n--- DEBUG: Respons Mentah API ---", file=sys.stderr)
        print(response.text, file=sys.stderr)
        print(f"--- AKHIR DEBUG ---\n", file=sys.stderr)
        # --- AKHIR DEBUG ---

        data = response.json()
        
        if 'message' in data and data['message'] != 'No keys found':
            # Asumsikan 'message' berisi string kunci yang dipisahkan spasi atau newline
            keys_string = data['message']
            keys = [k.strip() for k in keys_string.split() if k.strip()]
            return keys
        elif 'error' in data:
            print(f"Error dari API: {data['error']}", file=sys.stderr)
            return []
        else:
            print("Tidak ada kunci yang ditemukan atau format respons tidak terduga.", file=sys.stderr)
            print(f"Respons lengkap: {json.dumps(data, indent=2)}", file=sys.stderr)
            return []

    except requests.exceptions.RequestException as e:
        print(f"Error saat menghubungi API: {e}", file=sys.stderr)
        return []
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON respons: {e}", file=sys.stderr)
        print(f"Respons mentah: {response.text if 'response' in locals() else 'Tidak ada respons'}", file=sys.stderr)
        return []

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Penggunaan: python get_keys.py <PSSH> <LICURL> [USER_AGENT]", file=sys.stderr)
        sys.exit(1)

    pssh_input = sys.argv[1]
    licurl_input = sys.argv[2]
    user_agent_input = sys.argv[3] if len(sys.argv) > 3 else None

    keys = get_decryption_keys(pssh_input, licurl_input, user_agent_input)
    if keys:
        for key_pair in keys:
            print(key_pair)
    else:
        sys.exit(1)