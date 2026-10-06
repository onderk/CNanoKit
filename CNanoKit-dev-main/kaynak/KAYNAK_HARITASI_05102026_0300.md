# KAYNAK HARİTASI — 05.10.2026 03:00

Bu dosya kaynak kütüphanesinin **içindekiler** sayfasıdır. Bir konuda çalışmaya başlamadan önce buraya bak, doğru belgeye doğrudan git. Dosya dosya tam liste: `KAYNAK_KATALOGU_05102026_0300.md`.

---

## 1. Kaynaklara nasıl ulaşılır? (3 yol)

| Yol | Kim kullanır | Nasıl |
|---|---|---|
| **A — Google Drive** | Bulut oturumu (Drive aracı varsa) ve masaüstü oturumu | Klasör adları bilgisayardakiyle **birebir aynı**. Aşağıdaki §2 tablosundaki klasör ID'si ile ya da `title contains '…'` aramasıyla dosyayı bul, sonra oku. |
| **B — Bilgisayardaki klasör** | Yalnızca masaüstü (Cowork) oturumu | `C:\<klasör adı>\…` — katalogdaki yol aynen geçerli. Kod (.bas/.c/.h/.ino), .zip, .hex dosyaları için en güçlü yol budur. |
| **C — Resmî web adresi** | Herkes | Katalogdaki 🔗 satırları, kısayol dosyalarının (.url) içindeki **gerçek adreslerdir** (Microchip, Espressif, GitHub, protoncompiler.com…). Belge Drive'da okunamıyorsa bu adresten okunur. |

**Okuma sınırları [A — Drive aracının kendi açıklaması]:** Drive aracı PDF, Word, Excel, PowerPoint, Google belgeleri ve resim okur. .bas/.c/.h/.ino/.zip/.hex için destek **belirsiz [C]**; .mp4 **okunamaz**. Okunamayan dosya gerekiyorsa: yol C'yi dene, olmazsa kullanıcıdan dosyayı iste. **Uydurma yasak.**

---

## 2. On kaynak klasörü

| # | Klasör (C:\ ve Drive'da aynı ad) | Drive klasör ID | Dosya / boyut | Ne var? |
|---|---|---|---|---|
| 1 | Microchip_Tools | `1k5Hac1RYkVHpDNA3c54YRP2U-u0BwQN0` | 2580 / 3,5 GB | PIC18 Q71/Q40 belgeleri, uygulama notları, MCC örnek bağlantıları, Positron8/16 örnek kodları, CIP/CLC, Harmony v3, Zephyr, BLE/Wi-Fi, Curiosity kartları |
| 2 | Random Nerd Tutorials LAB | `1bQtW2oOzz3ethka-dmT0Dv0Z-q8cfTfV` | 3926 / 3,5 GB | ESP32 / ESP8266 / ESP32-CAM / ESP-IDF / MicroPython / LVGL / Firebase / Web sunucu / Ev otomasyonu kursları (**ücretli, lisanslı**) |
| 3 | ESP_Tools | `1G3Q76u7g-66XFf3yz86fXukuCh4nwzLw` | 11 / 11 MB | ESP32 Teknik Referans Kılavuzu (TRM) + Espressif resmî bağlantıları |
| 4 | Arduino Tools | `1CTDi10FJV_gfHOGdIq5pGqW_D-VKX57p` | 1 / ~0 | Yalnızca Arduino donanım belgeleri bağlantısı |
| 5 | STM_Tools | `1rYxy-_NOFPzraokqzsMzQvZMKWIYVO-w` | 2 / 6 MB | STM32 aile özeti PDF + ürün seçici bağlantısı |
| 6 | DWIN_Tools | `1cRdSDz1jBy_cUYsYPG0cyHJVAvq8unXz` | 83 / 2,5 GB | DWIN geliştirme kılavuzları (T5L, DGUS II, Linux, Android, HMI), çekirdek güncelleme, araç sayfası |
| 7 | Dwin Dgus 28 Agustos 2026 | `19hBskvZsOkede9bD7ifA2R47itnBlbkc` | 390 / 3,1 GB | DGUS_V7650 araç seti, T5L UART/C51, sürücüler, belgeler (DWIN_Tools'un daha yeni/kapsamlı eşi) |
| 8 | FREELOADER Free PIC18 bootloader and uploader__by Jon Walker | `1ovo7mSJ560C6ek_zD2Jg7dzoNw3y4iJe` | 328 / 57 MB | PIC18 K20/K22/K40/K42/K83/Q43 bootloader kaynakları (.bas), test edilmiş paketler, P56Q71_MWBOOT, yükleyici C kaynağı + testler |
| 9 | KiCad MCP Server | `1ARYyicTFbzH7yYH-IJ4L1GUFxXyz_4Kt` | 470 / 98 MB | KiCad MCP sunucu projelerinin kaydedilmiş sayfaları (mixelpixx, Seeed, lamaalrajih, oaslananka kicad-mcp-pro), PCB Python bağları |
| 10 | Video_Paketi_02102026_1640 | `1QbKncTnLgyglepkkQZaZa3GsUt9UWlx-` | 118 / 4 MB | CNanoKit video çekim paketi: araç, örnekler, belgeler, günlükler |

---

## 3. Konu → nereye bakılır?

Yollar klasör köküne göredir. `MT` = Microchip_Tools, `DCS` = `Microchip_Tools/Docuements_Code_Sample_Files`, `Q71KIT` = `Microchip_Tools/PIC18F56Q71 Curiosity Nano evaluation kit`.

### 3.1 PIC18 Q serisi (Q71 / Q40 / Q43)
| Konu | Yer |
|---|---|
| PIC18F26/46/56Q71 veri sayfası (DS40002329) + errata (DS80001030) | `DCS/PIC18F56Q71/datasheets PIC18F56Q71` |
| PIC18F04/05/14/15Q40 veri sayfası (DS40002236) + errata (DS80000936) | `DCS/Datasheets` |
| PIC18F56Q71 Curiosity Nano donanım kılavuzu (DS50003481) | `Q71KIT` (Drive dosya ID: `1wSZq69QRCcdXEgkMS7q2wvSL4-mUdRhK`) |
| Q71 kart Altium projesi, Gerber, dizilim (PCBA Rev1/Rev2) | `Q71KIT/PIC18F56Q71-Curiosity-Nano-Design-Documentation` |
| Q71 uygulama notları (48 adet) | `DCS/PIC18F56Q71/Application Notes PIC18F56Q71` ve `Q71KIT/Application Notes` |
| Q71 GitHub örnekleri (APM, ADCC, OPA, DMA, SPI, I2C, FatFs, MTCH9010…) | `Q71KIT/Github Repos` (her alt klasörde GitHub adresi) |
| XC8 kod örnekleri (Q71) | `DCS/PIC18F56Q71/codes samples xc8 pic18f..q...71` |
| PIC18F16Q40 Curiosity Nano | `DCS/PIC18F16Q40 CURIOSITY NANO EVALUATION KIT` |
| 8-bit çevre birimi hızlı başvuru (PIC/AVR), dsPIC33 seçim kılavuzu | `MT/Peripheral Integration Quick Reference Guides` |

### 3.2 CIP / CLC / donanım durum makinesi
| Konu | Yer |
|---|---|
| Getting Started With CLC on PIC18 (90003273A), CLC Tips & Tricks, AN2912 (CLC gerçek zamanlı), TB3228 (CIP ile True RMS), Building Hardware State Machines Using CIPs | `Q71KIT/Application Notes` (hepsi bir arada); ayrıca `DCS/PIC18F56Q71/Application Notes PIC18F56Q71` ve `DCS/Application Notes PİC MCU and Battery Charging Designs` |
| CLC buton sıçrama önleme örneği (Q40) | 🔗 GitHub `pic18f16q40-clc-switch-debouncing` (katalogda) |

### 3.3 MCC / MCC Melody / MPLAB X
| Konu | Yer |
|---|---|
| MCC Melody hızlı başlangıç, Q71 OPA sürücü yürüyüşü (Developer Help kayıtları) | `Q71KIT/Code Examples` (🌐 .html) |
| Data Visualizer'ı MCC Classic projesine ekleme | `Q71KIT/Application Notes/Adding Data Visualizer…` |
| MPLAB Discover örnek arama | 🔗 mplab-discover.microchip.com (katalogda) |
| Compiler Advisor (DS50003215) | `MT/` kök |
| Harmony v3 + MCC (32-bit) | `MT/MPLAB® Harmony v3` |

### 3.4 Positron8 / Positron16
| Konu | Yer |
|---|---|
| Positron8 derleyici kılavuzu (**lisanslı sürüm — dışarı paylaşılmaz**) | `DCS/Positron8 Compiler User Manual Orginal Latest Lİcensed Version/0 - Positron8 manual.pdf` |
| Positron8/16 örnek kod kütüphanesi (~40 proje: WS2812B, DDS, FFT, RTC, INA219, TFT, SPI LCD, uyku…) | `DCS/Some Sample Source Codes  Positron8 and Positron16` |
| Positron16 dsPIC33CK yüksek çözünürlüklü PWM kütüphanesi | aynı klasör `…/Positron16 - High Resolution PWM library…` + 🔗 protoncompiler.com topic 3194 |
| Positron8 + Curiosity Nano tek tuş derle/yükle aracı | `Video_Paketi_02102026_1640/CNanoKit_02102026_1640` |

### 3.5 Bootloader (PIC18)
| Konu | Yer |
|---|---|
| Aile bazlı bootloader kaynakları (.bas) | `FREELOADER…/Bootloaders/<aile>_family/<parça>` |
| Test edilmiş bootloader + uygulama paketleri, HEX uç durum testleri | `FREELOADER…/Packed and Tested Bootloaders + APP` |
| PIC18F56Q71 bootloader HEX | `FREELOADER…/P56Q71_MWBOOT` |
| Yükleyici C kaynağı (Win/Linux) + Python testleri | `FREELOADER…/PV Build Files` |
| HTML belgeler, HEX aracı (Python) | `FREELOADER…/Documentens HTML`, `…/HEX Tool` |
| **Not:** üçüncü kişi yazılımı; kaynakları **birebir kopyalanıp yayınlanmaz**, yalnızca başvuru. |

### 3.6 dsPIC / 16-bit
| Konu | Yer |
|---|---|
| 16-bit Curiosity Nano kılavuzları | `MT/Curiosity-Nano-User-Guides for  16bit PIC MCU` |
| PIC24 / dsPIC33 hızlı başvuru, dsPIC33 parça numarası çözücü | `MT/Peripheral Integration Quick Reference Guides` |

### 3.7 ESP32
| Konu | Yer |
|---|---|
| ESP32 Teknik Referans Kılavuzu (TRM) | `ESP_Tools/esp32_technical_reference_manual_en.pdf` |
| Donanım tasarım kuralları, errata, ESP-IDF BluFi, ESP-AT, SDK indirmeleri | 🔗 `ESP_Tools` (resmî Espressif adresleri) |
| ESP-IDF başlangıç e-kitabı | `Random Nerd…/Learn ESP-IDF with ESP32 The Beginner’s Guide (eBook)` ve `…/ESP-IDF-ESP32-eBook-b` |
| ESP32 Arduino kursu (uyku modları, PWM, flash'a kalıcı veri, dokunmatik, web sunucu, sorun giderme) | `Random Nerd…/Welcome to Learn ESP32 with Arduino IDE/…` |
| Web sunucu (ESP32/ESP8266), Firebase web uygulaması | `Random Nerd…/Build Web Servers with ESP32 and ESP8266`, `…/Firebase Web App…` |
| LVGL arayüz | `Random Nerd…/Learn LVGL Build GUIs for ESP32 Projects` |
| FreeRTOS görevleri | 🔗 randomnerdtutorials.com/esp32-freertos-arduino-tasks (katalogda) |
| ESP32-CAM, MicroPython, Pico, Android (MIT App Inventor), ev otomasyonu | `Random Nerd…/` ilgili klasörler |
| **Lisans:** Random Nerd içeriği **ücretli**; yalnızca öğrenme ve başvuru için kullanılır, hiçbir herkese açık depoya, foruma ya da sayfaya **konmaz**. |

### 3.8 DWIN ekran (T5L / DGUS II)
| Konu | Yer |
|---|---|
| T5L DGUS II uygulama geliştirme kılavuzu (V2.921), T5F0 DGUS II (V6.5) | `DWIN_Tools/development-guide` ve `Dwin Dgus…/Documents/T5L UART` |
| T5L UART C51 programı (ekran içi 8051 çekirdek) | `DWIN_Tools/development-guide` ve `Dwin Dgus…/Documents/T5L UART` |
| T5L ASIC geliştirme kılavuzu (2024-09-25), DWIN OS (T5L CPU), değerlendirme kartı şeması | `DWIN_Tools/development-guide` ve `Dwin Dgus…/Documents/T5L UART` |
| DGUS_V7650 araç seti (yazı tipi, klavye, modbus, video→icl, çok dil) | `Dwin Dgus…/Tool Page/T5L DGUS/DGUS_V7650` |
| Çekirdek (kernel) güncelleme — DGUS / TA modu | `Dwin Dgus…/Kernel Upgrade`, `DWIN_Tools/Kernel Upgrade` |
| USB-UART sürücüsü (XR21X141X) | `Dwin Dgus…/Tool Page/T5L DGUS/XR21X141X-Driver` |
| Wi-Fi modülü arayüzü, termostat arayüzü | `DWIN_Tools/development-guide`, `Dwin Dgus…/Documents/Thermostat` |

### 3.9 KiCad / PCB
| Konu | Yer |
|---|---|
| KiCad MCP sunucuları (karşılaştırma için 6 proje) | `KiCad MCP Server/<proje>` (her birinde GitHub adresi) |
| KiCad PCB Python bağları | `KiCad MCP Server/PCB Python Bindings` |

### 3.10 Güç / şarj
| Konu | Yer |
|---|---|
| TP4056 / TPB4056A/B tek hücre Li-ion şarj, MIKROE Charger 3 Click (şema dahil) | `DCS/Datasheets`, `DCS/Schematics Sample Battery Charger and TP4056` |
| PIC MCU ve batarya şarj uygulama notları (24 adet) | `DCS/Application Notes PİC MCU and Battery Charging Designs` |

### 3.11 Diğer Microchip
| Konu | Yer |
|---|---|
| Zephyr RTOS (Microchip) | `MT/Zephyr® RTOS for Microchip` |
| BLE / Wi-Fi modülleri, PIC32 Curiosity kartları | `MT/Bluetooth…`, `MT/Plug-and-Play Bluetooth® Modules`, `MT/Wi-Fi® Link Controller Products`, `MT/Curiosity_Board_PIC32` |
| UART çevre birimi belgeleri | `DCS/Universal Asynchronous Receiver and Transmitter (UART) Peripherals` |

### 3.12 STM32 / Arduino
| Konu | Yer |
|---|---|
| STM32 aile özeti, ürün seçici | `STM_Tools` |
| Arduino donanım belgeleri | 🔗 `Arduino Tools` |

---

## 4. Eksikler — kütüphanede **olmayan** temel belgeler

Bu konularda çalışırken belge **resmî siteden** okunmalı; ya da kullanıcı ilgili klasöre ekleyebilir. [B]

| Eksik | Önerilen klasör |
|---|---|
| MPLAB XC8 C Compiler User's Guide (PIC) | Microchip_Tools |
| MPLAB XC16 C Compiler User's Guide | Microchip_Tools |
| MPLAB X IDE User's Guide | Microchip_Tools |
| MCC Melody kullanıcı kılavuzu (şu an yalnız birkaç web sayfası kaydı var) | Microchip_Tools |
| Positron16 derleyici kılavuzu | Microchip_Tools |
| dsPIC33CK veri sayfası + aile başvuru kılavuzları | Microchip_Tools |
| ESP32-C3 / ESP32-S3 / ESP32-C6 veri sayfaları ve TRM'ler (şu an yalnız klasik ESP32 TRM var) | ESP_Tools |
| ESP-IDF OTA, Secure Boot, Flash Encryption belgeleri | ESP_Tools |
| KiCad 9/10 kullanım kılavuzu | KiCad MCP Server |
| RS-485 / Modbus RTU belirtimleri | yeni klasör |
| İlgili ürün standartları (güvenlik, EMC, telsiz/siber güvenlik) | yeni klasör |
| STM32 ve Arduino tarafı neredeyse boş | STM_Tools / Arduino Tools |

---

## 5. Kullanım kuralları (her oturumda geçerli)

1. **Önce bu harita**, sonra katalog, sonra belge. Belge okunmadan teknik hüküm verilmez.
2. **Kaynak sırası:** üretici belgesi > hakemli yayın > yetkin forum. Her iddia etiketlenir: **[A]** kaynak (belge adı + numara + sayfa/bölüm), **[B]** yorum, **[C]** varsayım.
3. **Lisanslı içerik** (Random Nerd, Positron8 lisanslı kılavuzu, üçüncü kişi kodları) yalnızca başvuru içindir; herkese açık hiçbir yere konmaz, birebir kopyalanmaz.
4. **İsim kuralı:** bu dosyalardan üretilen hiçbir çıktıda kişi adı, şirket adı ya da yapay zekâ adı geçmez.
5. Kaynak klasörleri **salt okunurdur**; içlerinde değişiklik, silme, taşıma yapılmaz.
6. Kullanıcı kütüphaneye yeni belge eklediğinde katalog yeniden üretilir; dosya adı yeni tarih-saat ile güncellenir.
