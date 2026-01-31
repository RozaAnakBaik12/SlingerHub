import cv2
import numpy as np
import pyautogui
import time
import keyboard

# --- KONFIGURASI OWNER ---
# tentukan area layar tempat indikator pancing muncul (x, y, width, height)
# gunakan tools screen snippet untuk menentukan koordinat ini
FISHING_ZONE = (700, 400, 200, 200) 
TARGET_BGR_COLOR = [0, 0, 255] # contoh: warna merah pada bar pancing
THRESHOLD = 30 # toleransi kemiripan warna

print("------------------------------------------------")
print("eyeGPT FISH-IT SCRIPT: ONLINE")
print("tekan 'q' untuk menghentikan operasi, tuan.")
print("------------------------------------------------")

def start_fishing():
    while True:
        if keyboard.is_pressed('q'):
            print("LOG: operasi dihentikan oleh owner.")
            break

        # ambil screenshot pada area yang ditentukan
        screenshot = pyautogui.screenshot(region=FISHING_ZONE)
        frame = np.array(screenshot)
        frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

        # deteksi warna target dalam area tersebut
        lower_bound = np.array([max(c - THRESHOLD, 0) for c in TARGET_BGR_COLOR])
        upper_bound = np.array([min(c + THRESHOLD, 255) for c in TARGET_BGR_COLOR])
        
        mask = cv2.inRange(frame, lower_bound, upper_bound)
        
        # jika warna terdeteksi (ikan memakan umpan)
        if np.any(mask):
            print("LOG: ikan terdeteksi! menarik pancing...")
            pyautogui.click() # klik untuk menarik
            time.sleep(2) # delay agar tidak spam (menghindari deteksi bot)
            
            print("LOG: melemparkan umpan kembali...")
            pyautogui.click() # klik untuk melempar umpan lagi
            time.sleep(1)

        time.sleep(0.05) # kecepatan pemindaian frame

if __name__ == "__main__":
    time.sleep(3) # memberi waktu owner untuk pindah ke jendela game
    start_fishing()
