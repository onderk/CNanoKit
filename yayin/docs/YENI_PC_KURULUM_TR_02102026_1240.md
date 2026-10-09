# Yeni bilgisayarda CNanoKit kurulumu — sırayla (Windows 11 Pro)

Sürümler: denediğimiz sürümlerdir (Ekim 2026). Daha yenisi büyük olasılıkla çalışır ama denenmedi.

## A. Önce bunlar (bir kez)
1. **Windows güncellemelerini** bitir, bilgisayarı yeniden başlat.
2. **Positron8 derleyicisi** (ücretli lisans, RosettaMicro): ana kurulum + son düzeltme güncellemesi → denenen **4.0.6.4**. Proton IDE (**2.0.3.3**) bununla birlikte gelir.
3. Bir IDE seç (biri yeter, hepsi de olur):
   - **Positron Studio 2.1.0.4** (ücretsiz, John Barrat), ya da
   - **Proton IDE 2.0.3.3** (2. adımla geldi), ya da
   - **VS Code 1.140** + eklenti **"Positron" (yayıncı atomix) 2.9.0**.
4. **Python 3.14.7, 64 bit** (python.org). Kurulumun ilk ekranında **"Add python.exe to PATH"** kutusunu işaretle.

## B. CNanoKit
5. Zip'i indir. **Açmadan önce:** zip'e sağ tık → Özellikler → **Engellemeyi kaldır** → Tamam.
6. `C:\CNanoKit` klasörüne aç.
7. Açık IDE'leri kapat. **`CNanoProg_Setup.bat`** dosyasına çift tıkla (internet gerekli, bir kez):
   - Microchip **pymcuprog** kurulur (denenen 3.19.4.61);
   - Microchip **PIC18F-Q_DFP** cihaz paketi indirilir (~40 MB, denenen 1.31.492);
   - kurulu IDE'lere düğmeler / kısayollar eklenir.
   Sonda kırmızı satır olmamalı.

## C. Kit
8. Kiti **veri taşıyan** bir USB (Micro-B) kabloyla tak. Sürücü kurma: Windows kendisi tanır.
   - Dosya Gezgini'nde **CURIOSITY** sürücüsü görünür,
   - Aygıt Yöneticisi → **Bağlantı noktaları** altında **"Curiosity Virtual COM Port (COMx)"** görünür.
9. Kablo, köprü, bootloader, MPLAB X **gerekmez**.

## D. İlk deneme
10. `C:\CNanoKit\examples\CNANO_HELLO_56Q71.bas` dosyasını IDE'nde aç.
11. Derle + programla:
    - Positron Studio: **F10** · Proton IDE: **CNano Program** düğmesi · VS Code: **Ctrl+Alt+M** (çalışmazsa **Ctrl+Alt+C** sonra **Ctrl+Alt+P**).
12. Monitörü aç (VS Code: **Ctrl+Alt+N**) → **Bağlan** → "Hello/Merhaba" satırları akmalı.
13. İstersen dış LED: **RD0 → 1 kΩ → LED → GND**.

## Bilmen gerekenler
- VS Code'da **Ctrl+Alt+P yalnız programlar, derlemez.** `.bas` değiştiyse önce derle; yoksa eski `.hex` yazılır ("hex is older than the .bas" uyarısı).
- Programlama çipi tamamen siler; çipte bootloader varsa o da gider.
