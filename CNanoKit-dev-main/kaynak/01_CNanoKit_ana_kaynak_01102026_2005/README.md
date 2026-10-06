# CNanoKit

**TR:** PIC18F56Q71 Curiosity Nano kitini **Positron** derleyicisiyle kullanın:

- **Positron Studio** (F10), **Proton IDE** (eklenti düğmeleri) ya da **VS Code** (Ctrl+Alt+M) ile tek tuşla derleyin ve programlayın.
- **CNano Monitor** ile kitin USB-COM portu üzerinden programınızla konuşun.
- MPLAB X IDE, kitte kablo ve başka birinin bootloader dosyası gerekmez. Arayüz Türkçe ve İngilizcedir. Ücretsizdir; garanti ve destek yükümlülüğü yoktur.

**EN:** Use the PIC18F56Q71 Curiosity Nano with the **Positron** compiler:

- Compile and program with one key from **Positron Studio** (F10), **Proton IDE** (plugin buttons) or **VS Code** (Ctrl+Alt+M).
- Talk to your program over the kit's USB COM port with **CNano Monitor**.
- No MPLAB X IDE, no wires on the kit and nobody else's bootloader files needed. Turkish and English UI. Free; no warranty, no support obligation.

| | |
|---|---|
| Kurulum (Türkçe) | [docs/KURULUM_TR_01102026_2030.md](docs/KURULUM_TR_01102026_2030.md) |
| Installation (English) | [docs/INSTALL_EN_01102026_2030.md](docs/INSTALL_EN_01102026_2030.md) |
| İlk program / first program | [examples/CNANO_HELLO_56Q71.bas](examples/CNANO_HELLO_56Q71.bas) |

## Hızlı başlangıç / Quick start

1. Python 3 (64-bit, "Add to PATH"), Positron8 ve bir IDE kurun.
   Install Python 3 (64-bit, "Add to PATH"), Positron8 and one IDE.
2. Zip'i `C:\CNanoKit` klasörüne açın, IDE'leri kapatın ve kiti takın.
   Extract the zip to `C:\CNanoKit`, close the IDEs and plug in the kit.
3. `CNanoProg_Setup.bat` dosyasına çift tıklayın ve **HEPSİ TAMAM** yazısını bekleyin.
   Double-click `CNanoProg_Setup.bat` and wait for **ALL OK**.
4. `examples\CNANO_HELLO_56Q71.bas` → programla / program → **CNano Monitor**.

## Test edilen / Tested

Windows 11 Pro · PIC18F56Q71 Curiosity Nano (nEDBG 1.27) · Positron8 4.0.6.4 · Positron Studio 2.1.0.4 · Proton IDE 2.0.3.3 · VS Code 1.140.0 + atomix.positron 2.9.0 · Python 3.14.7 · pymcuprog 3.19.4.61

## Nasıl çalışır / How it works

- **Programlama / Programming:** Microchip **pymcuprog**, kitin hata ayıklayıcısı üzerinden çalışır: sil, yaz, doğrula, reset. Python yoksa yedek yol olarak hex, CURIOSITY sürücüsüne sürüklenip bırakılır. Her yazmadan önce kitteki PIC ile hex'in PIC'i karşılaştırılır.
  Microchip **pymcuprog** works through the kit's debugger: erase, write, verify, reset. Without Python, the fallback is drag-and-drop of the hex onto the CURIOSITY drive. Before every write, the kit's PIC is checked against the hex's PIC.
- **Monitör / Monitor:** Port, hız ve biçimi siz seçip Bağlan'a basarsınız. Metin/HEX görünüm, metin/HEX gönderme, zaman damgası, kayıt ve reset düğmesi vardır.
  You choose port, baud and format, then press Connect. Text/HEX view, text/HEX send, timestamp, log and a reset button.

## Lisans / Licence

© 2026 okmn — `LICENSE.txt`.

pymcuprog (Microchip, MIT) ve Microchip cihaz paketleri (Apache-2.0) kurulum sırasında indirilir; pakete dahil değildir.
pymcuprog (Microchip, MIT) and the Microchip device packs (Apache-2.0) are downloaded during setup and are not included.

"Microchip", "PIC" ve "Curiosity", Microchip Technology Inc.'in ticari markalarıdır. Bu proje Microchip ile bağlantılı değildir.
"Microchip", "PIC" and "Curiosity" are trademarks of Microchip Technology Inc. This project is not affiliated with Microchip.
