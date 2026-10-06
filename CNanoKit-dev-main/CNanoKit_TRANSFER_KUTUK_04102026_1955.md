# CNanoKit — Transfer Kütüğü (yeni bulut oturumunun İLK MESAJI) — 04.10.2026 19:55

> **Yeni asistana:** CNanoKit, "Tarim" projesinin içinde 01.10.2026'da doğan, bugün başlı başına ayrı bir proje olan ücretsiz araç setidir. Bu dosya 04.10.2026 19:55'e kadar yapılan HER ŞEYİN eksiksiz devridir. Proje bundan sonra **"CNanoKit"** adıyla bulutta (bulut oturumu, özel depo **onderk/CNanoKit-dev**) sürecek. Önce bu dosyanın TAMAMINI oku, sonra kullanıcıya Türkçe kısa bir "anladım + ilk 3 adım" özeti ver.
> Yerel kopya: C:\Tarim\Transfer_04102026_1955\CNanoKit_TRANSFER_KUTUK_04102026_1955.md · Kardeş proje kütüğü: C:\Tarim\Transfer_04102026_1955\Tarim_TRANSFER_KUTUK_04102026_1955.md

---

## 0. Bir dakikada
- **Ne:** Microchip **PIC18F56Q71 Curiosity Nano (EV01G21A)** kitini **Positron8** ile **Positron Studio, Proton IDE veya VS Code** içinden TEK TUŞLA derleyip programlamak ve **CNano Monitor** ile USB üzerinden konuşmak. MPLAB X, programlayıcı, kablo, bootloader gerekmez. Kitin kendi hata ayıklayıcısı (nEDBG) + Microchip **pymcuprog** kullanılır.
- **Kim:** kullanıcı; dışarıya giden her şeyde yalnız **okmn** adı (GitHub hesabı **onderk** istisna — kalıcı karar).
- **Durum (04.10.2026):** v1.1 YAYINDA — GitHub (onderk/CNanoKit, public) + GitHub Pages + release + protoncompiler.com forum konusu **3440** (Useful Tools). Geliştirme arşivi gizli depoda (onderk/CNanoKit-dev).
- **Sıradaki:** 3. ders yüklemesi (README + index.html'e forum bağlantısı) → JonW DTR-hold bekleniyor → CNanoKit 2.0 planlaması (çoklu kit, daha zor kırılan sürüm).

## 1. KURALLAR (kalıcı, istisnasız — Tarim ile ortak)
1. Cevaplar **Türkçe**, kısa ama eksiksiz; adım anlatırken ne/tam nerede/nereye/ne görülecek. "Çok kolay kavranır" adım adım öğretim (kullanıcı GitHub'ı yeni öğreniyor, uzman olmak istiyor).
2. **TAM YOL:** her dosya/klasör bahsinde tam yol.
3. **Kanıt anayasası:** birincil kaynak (Microchip belgesi, Positron el kitabı, Les'in forum cevapları) > hakemli > forum; [A]/[B]/[C] etiketleri; uydurma yok.
4. **Hiçbir şey silinmez.** asistanın attığı kendi ürünleri → **C:\_silinecek** klasörüne TAŞINIR; o klasöre başka dokunulmaz; gerçek silmeyi kullanıcı yapar; her oturumda hatırlat.
5. Yazma yalnız proje çalışma klasör(ler)inde (bkz. §11); öğrenme/üretici depoları SALT-OKUNUR (C:\Microchip_Tools, C:\FREELOADER Free PIC18 bootloader and uploader__by Jon Walker, C:\Random Nerd Tutorials LAB, C:\KiCad MCP Server, vendor araç klasörleri).
6. **Adlandırma** `ad_GGAAYYYY_SSDD` (İstanbul saati); tek istisna README.md.
7. **Kütük** her turda güncel; yerel kopya + depoda Kutuk\.
8. **PAYLAŞIM KURALI (çok önemli):** paylaşılan hiçbir belgede, programda, kodda, dosya adında, ekran görüntüsünde, video ekranında kural 0'daki yasaklı adlar (bkz. kökteki CLAUDE.md) ve kişisel yollar GEÇMEZ. Yalnız "okmn". Her yayından önce otomatik tarama (UTF-8 + UTF-16 dizgileri, exe içleri dahil).
9. **Resim kuralı:** asistanın yazdığı/kopyaladığı PNG/JPG dosyalarına sistem **C2PA üretici** içerik kimliği ekleyebiliyor. asistan bu etiketi SİLMEZ. Paylaşılacak resimleri kullanıcı kendi kaynağından (Ekran Alıntısı/telefon) kendisi kaydedip yükler; asistan yalnız indirip denetler (c2pa/üretici adı/GPS taraması).
10. **Kaynak kod paylaşılmaz:** public depoda yalnız kullanım dosyaları (README, docs, examples, index.html, LICENSE). .ps1/.c kaynakları ve geliştirme arşivi yalnız gizli depoda.
11. **JonW lisansı:** JonW'nin dosyaları (P56Q71_MWBOOT.hex, FREELOADER) yeniden DAĞITILMAZ; değiştirilmiş test uygulaması özel kalır; mwtest_upload.py ve özel betikler asla paylaşılmaz. (Not [B]: gizli arşivde P56Q71_MWBOOT.hex kopyaları var — gizli depo dağıtım sayılmaz kabulüyle tutuluyor; depo herkese açılırsa önce çıkarılmalı.)
12. **GitHub:** kullanıcı, asistanın onderk hesabında onun adına iş yapmasına izin verdi (03.10.2026) — her adım çok kolay dille tek tek anlatılarak. Forumda asistan mesaj yazmaz; metni kullanıcı gönderir.
13. Pin/datasheet bilgisi her zaman Microchip'in kendi belgesinden (DigiKey'in 56Q71 datasheet bağlantısı yanlış belgeye gidiyor).
14. PIC anayasası: donanım önce (CIP: CRC, DMA, CLC, ADCC…); Positron8'de `delay_ms` yerine zamanlayıcı/CIP, `Proc`–`EndProc`.

## 2. Bileşenler (v1.1)
| Dosya | Görev |
|---|---|
| CNanoProg.ps1 (+ CNanoProg.exe başlatıcı) | derle/programla: pymcuprog ile kitin nEDBG'si üzerinden sil-yaz-doğrula-reset; `Device =` satırı ile kitteki PIC farklıysa YAZMAZ; settings.ini'den dil; ekrandaki kullanıcı klasörünü %USERPROFILE% olarak gizler (Log fonksiyonu) |
| CNanoMonitor.ps1 (+ CNanoMonitor.exe) | seri monitör EN/TR: port/baud/veri/eşlik/dur elle, yalnız "Connect" ile bağlanır, DTR açık tutar (Curiosity Nano DTR açıkken veri geçirir — DS50003481A 3.1.2.4); Metin/HEX/ikisi görünüm, zaman damgası, kayıt; metin (satır sonu seçimli) ve HEX gönderme (55 AA 0D 0A, 0x55,0xAA, 55AA0D0A); 4 hızlı düğme (Shift+tık = düzenle; varsayılan okmn, HEX:53, come, stop); Reset PIC |
| CNanoProg_Setup.bat / .ps1 | kurulum (idempotent, -Check): pymcuprog + PIC18F-Q_DFP kurar; Positron Studio araç girişleri (F10, Tools → CNano Monitor, "CNano Test"); Proton IDE eklentisi; VS Code görevleri (CNano Monitor, Ctrl+Alt+N) + files.associations *.bas=pos |
| CNanoProtonPlugin.exe | Proton IDE Plugin Manager eklentisi: "Program (CNanoProg)" ve "Monitor (CNanoMonitor)" düğmeleri (proton_mcp_ornek\CNano_Program.mcp, CNano_Monitor.mcp); belgelenmiş arayüz, Proton IDE'nin içi değiştirilmez |
| src\CNanoProg.c, src\CNanoProtonPlugin.c | exe kaynakları (MinGW i686-w64-mingw32-gcc 13; komutlar dosya başında) — GİZLİ |
| examples\CNANO_HELLO_56Q71.bas | "Hello/Merhaba n" 500 ms, UART2 (RB4 TX, RB5 RX), RD0 LED, yankı, SW0 |
| examples\CNANO_HELLO_56Q71_NOLED.bas | yalnız metin (her kablolamada güvenli) |
| examples\CNANO_KOMUT_56Q71.bas | komutlar: okmn (LED tık ×4 + 300 ms), HEX 53 (yazılım PWM fade + çubuk), come (250 ms DATA n SW0=x), stop, help; komut stop/yeni komuta kadar sürer; RB5–RC7 kablosunu ilk baytta IOC ile algılar → kablo varsa RC7 ASLA sürülmez, LED monitörde "sanal LED" |
| docs\ | INSTALL_EN_01102026_2030.md, KURULUM_TR_01102026_2030.md, NEW_PC_SETUP_EN_02102026_1240.md, YENI_PC_KURULUM_TR_02102026_1240.md (+ özelde GITHUB_PUBLISH_EN / GITHUB_YAYIN_TR) |
| LICENSE.txt | freeware (§6) |
| settings.ini | Baud=115200, Dtr=1, Lang=en, Port=COM8, Q1..Q4 hızlı düğmeler |
**Tuşlar:** Positron Studio **F10** · Proton IDE **Program (CNanoProg)** düğmesi · VS Code **Ctrl+Alt+M** (derle+programla; kullanıcının klavyesinde çalışmıyor → **Ctrl+Alt+C** derle, sonra **Ctrl+Alt+P** yalnız programla — P DERLEMEZ), **Ctrl+Alt+N** monitör. VS Code düğmeleri yalnız .bas dosyası Positron dilinde (resourceLangId == pos) açıkken görünür.

## 3. Test edilmiş sürümler (gereksinimler)
Windows 10/11 64-bit (Win11 Pro'da test) · Positron8 **4.0.6.4** · Positron Studio **2.1.0.4** · Proton IDE **2.0.3.3** · VS Code **1.140** + "Positron" eklentisi (atomix) **2.9.0** · Python **3.14.7** 64-bit ("Add python.exe to PATH") · pymcuprog **3.19.4.61** · PIC18F-Q_DFP **1.31.492** · USB **veri** kablosu (Micro-B). Süreler: programlama ≈2–3 sn, doğrulamalı.

## 4. Teknik bulgular (kanıtlı)
- **Positron8 4.0.6.4 bank hatası [A, kendi asm'mizden]:** `LATD.0 = BitDeğişken` (satır içi ve etiket sonrası) MOVLB almıyor → yazma RAM 0x543'e (sTx dizgisi) gidiyor, port değişmiyor; sabit atama `LATD.0 = 1` MOVLB 0x01 alıyor. Çözüm: If/Else + sabit atama. Les'e rapor: C:\Tarim\paylasim_01102026_1900\Les_Bank_Hatasi_Metni_02102026_1340.md + C:\Tarim\paylasim_01102026_1900\BANK_REPRO_56Q71_02102026_1240.bas/.asm — **henüz GÖNDERİLMEDİ** (kullanıcı ayrı konu açacak).
- `$endifm` yazım hatasını derleyici hata vermeden geçirdi → bozuk hex/config ("Verify config 0x300003") — düzeltildi; örneklerde her yayından önce derleme kontrolü.
- Türkçe Windows'ta "pıc" (büyük/küçük harf) hatası düzeltildi (01.10).
- Setup İngilizce dil hatası ($TR/$tr değişken çakışması) düzeltildi.
- **JonW mwboot (P56Q71_MWBOOT) gerçek 56Q71'de TÜMÜ GEÇTİ:** sync U→B, INFO (MWB, 0x23, flash 0x10000, slot 0xFCF8, DEVID 0x7760), 4 sayfa + EEPROM yazma, X, reset zinciri, R ile 64 KB okuma = beklenen = debugger okuması; TEST_B ≈0,36 s. R komutunda LEN = veri bayt sayısı (her komutta) — LEN≠0 veri taşımazsa sessiz (JonW #51).
- **FREELOADER.exe 1.1** kitin USB'siyle bağlanamıyor: portu açınca DTR'yi bırakıyor ("no bootloader answered in 30 s, bytes seen: none"). JonW DTR-hold seçeneği ekleyecek; UART2 sürümü "daha büyük iş".
- Normal programlama (F10/Ctrl+Alt+M/debugger) tüm çipi siler → bootloader da silinir; tekrar yüklenmeli. Uygulama 0xFCF8 altında bitmeli.
- **Kablolama:** FREELOADER/mwboot için iki kablo: **RC6 → RB4** (sol sıra 13 → sol sıra 25) ve **RB5 → RC7** (sol 26 → sağ 28, en alt); USB çıkarılıyken tak/çıkar. RC7 = LED0 → kablo takılıyken program RC7'yi ASLA sürmez. "K2" = iki kablo; "K1" = yalnız RB5–RC7 (RC7 ucu çekik); günlük kullanım K1. RD0 → 1 kΩ → LED → GND dış LED takılı. CNanoKit'in kendisi kablo istemez (UART2 = RB4/RB5 kit içinde CDC'ye bağlı).
- **.ps1 gerçeği:** program mantığının tamamı okunabilir .ps1'de → okuyan kopyalayabilir; .NET/C# exe de kolayca geri çözülür (obfuscator gerekir). Bu yüzden lisans + 2.0 planı (§9).
- SMF forum (protoncompiler.com, SMF 2.1.7 + SCEditor) Markdown işlemez, BBCode ister; tek satır sonlarını birleştirir → [list][li], [table], [url=] kullan; hücre sonuna bölünmez boşluk; konu başlığı kısa (~72 karakter kabul edildi).
- GitHub release'e "Source code (zip/tar.gz)" GitHub tarafından OTOMATİK eklenir (About releases belgesi), kaldırılamaz kabul edildi [zayıf kanıt: belgede seçenek yok]; içi yalnız release anındaki depo (LICENSE, README, index.html).

## 5. Yayın durumu (04.10.2026 19:35 doğrulandı)
| Ne | Adres / değer |
|---|---|
| Public depo | https://github.com/onderk/CNanoKit (main; docs\ 5 md, examples\ 3 bas, images\ 2 png, LICENSE.txt, README.md, index.html) |
| Web sayfası (Pages, main/root) | https://onderk.github.io/CNanoKit/ |
| Release | tag **CNanoKit_1.1** ("CNanoKit 1.1", Latest): https://github.com/onderk/CNanoKit/releases/latest → CNanoKit_v1.1_03102026_2000.zip (123 KB, SHA256 664c38fd2f7903ee84b8cf93e744b8f51b4114de9dab096cb882278989001b4f — yerel kopyayla aynı) |
| Gizli depo | https://github.com/onderk/CNanoKit-dev (Private; dışarıdan 404) — CNanoKit_Gelistirme_OZEL_arsiv_03102026_2010.zip (3,5 MB, 457 dosya); About açıklaması hâlâ public metin + arşiv adı (isteğe bağlı düzelt) |
| Forum | https://protoncompiler.com/index.php/topic,3440.0.html — Useful Tools, başlık "CNanoKit: one-key programming for PIC18F56Q71 Curiosity Nano + Positron8", msg 25105 (tanıtım) + 25106 (video notları); 21 bağlantı 200; yasak isim yok |
| Resimler | images\Wiring_JonW_mwboot_TR_04102026_1815.png, images\Kit_wiring_photo_04102026_1815.png — kullanıcının kendi yüklediği temiz kopyalar (C2PA yok); şemada Microchip pin çizimi (DS50003481A), kaynak satırıyla kullanılıyor (kullanıcı kararı) |
| **Bekleyen 3. ders** | yerelde hazır, GitHub'a henüz yüklenmedi: C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\repo\README.md ve ...\repo\index.html ("Forum topic" bağlantısı + düğme). Yükle: Add file → Upload files → commit "Add forum topic link" → kontrol |
| GitHub dersleri | C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\GITHUB_ADIM_ADIM_TR_03102026_2015.md, ...\GITHUB_DUZELTME_ADIM_ADIM_TR_04102026_1735.md, ...\GITHUB_DERS2_RESIM_EKLE_TR_04102026_1820.md |

## 6. Lisans (LICENSE.txt, freeware — MIT'in yerine, 03.10.2026)
1) Ücretsiz indir/kur/kullan (özel ve ticari). 2) DEĞİŞTİRİLMEMİŞ release zip'i lisansıyla ücretsiz paylaşabilirsin. 3) Yazılı izin olmadan değiştirme, çeviri, decompile/tersine mühendislik, değiştirilmiş sürüm/parça dağıtma, başka ürüne katma YOK. 4) Satış/ücret YOK. 5) examples\*.bas serbestçe değiştirilebilir. 6) Garanti yok. Üçüncü taraf: pymcuprog (MIT), Microchip DFP (Apache-2.0), Positron8/Studio/Proton IDE, VS Code, "Positron" eklentisi (sahipleri). İletişim: protoncompiler.com, okmn. Başlık satırları (.ps1, src\*.c, HELLO/NOLED .bas) "Freeware…" olarak güncellendi.

## 7. Videolar (YouTube, İngilizce altyazılı; oEmbed ile doğrulandı)
| IDE | HELLO | HELLO_NOLED | KOMUT |
|---|---|---|---|
| Positron Studio | 5oV3hNFtrQQ | Fr_1ISsT9pI | _-PZj2wlwPs |
| Proton IDE | HoQPmnRP7GU | 7u8eBAA3DyQ | cnKvcF5cFHo |
| VS Code | 9kIeRDDFuoc | gBkqgx5eyXM | dkm4jyVHdmw |
CNano Monitor turu: -UH7H_6zfKo · JonW mwboot Part 1 (upload) DtCk0OLhyhg · Part 2 (R read-back) RV5UpDS18VI · Part 3 (FREELOADER/DTR) Hw0ExDGAQg8 · Part 4 (test app alone) YuMxKAdu_NI. (https://youtu.be/<kimlik>)
- YouTube başlıkları "CNanoKit N –" numaralı; 1 ve 4 yüklenmedi (CNanoKit0 kısa, CNanoKit3a tekrar) → isteğe bağlı önek kaldırma; VS Code HELLO başlığı "Open the Monitor…" → önerilen "HELLO in VS Code: Compile, Program and Monitor" (kullanıcı yapacak).
- Altyazılı MP4 + SRT: C:\Videolar_02102026_1715\2_altyazili_cikti\ · YouTube metinleri: C:\Videolar_02102026_1715\YouTube_Metinleri_02102026_2010.md (JonW), C:\Videolar_02102026_1715\YouTube_Metinleri_CNanoKit_02102026_2030.md · betik: C:\Videolar_02102026_1715\_isleme_02102026_1900\altyazi_yap_02102026_1930.py (ffmpeg subtitles, libx264 veryfast crf21) · video bat paketi: C:\Video_Paketi_02102026_1640\

## 8. Zaman çizelgesi (CNanoKit turları; ayrıntı EK A)
01.10: CNanoProg 0.2→0.3 (F10, VS Code), MWBOOT yazıldı, CNanoKit 0.4 tek klasör (Proton eklentisi, monitör), 0.5 elle bağlanan monitör + HEX, 0.6 KOMUT + hızlı düğmeler · 02.10: 0.7 kablo algılama (IOC), 0.8 dış LED RD0 + VS Code görevleri, 0.9 files.associations; NOLED/KOMUT hataları ve bank hatası bulundu; TEST_B/TEST_R/FINAL testler GEÇTİ (C:\Tarim\Final_Test_Raporu_02102026_1410.md); v1.0 zip; video paketi; 16 video altyazılandı; JonW #51 · 03.10: YouTube eşleme; v1.1; GitHub planı; özel arşiv + yeniden inşa belgesi + SHA256; freeware lisans; Pages sayfası · 04.10: GitHub kuruldu (1. ders: docs/examples; 2. ders: resimler), C2PA bulgusu ve çözümü, forum BBCode, forum konusu 3440 YAYINDA, forum bağlantısı (3. ders hazır).

## 9. Kararlar ve yol haritası
**Verilmiş:** public onderk depo + Pages; onderk adı kalır (kesin); yalnız kullanım dosyaları paylaşılır; freeware lisans; v1.1 .ps1 ile yayında; "Source code" arşivleri kalır; Microchip pin çizimi kaynak satırıyla kullanılır; geliştirme arşivi gizli depoda ("kara kutu"); CNanoKit ayrı proje, bulutta sürecek.
**2.0 (karar AÇIK):** C# ya da daha zor kırılan lisanslı çözüm (C#/.NET de decompile edilir → obfuscator; ya da lisans anahtarı). **Büyüme mimarisi önerisi:** çekirdek + kit başına JSON profil (cihaz, UART pinleri, LED, DFP) + programlayıcı adaptörleri (pymcuprog/nEDBG, PICkit, MDFU/bootloader) + IDE modülleri (Positron Studio, Proton IDE, VS Code) — kullanıcının çip bağımsızlık anayasasıyla uyumlu. Hedef: diğer 8-bit ve 16-bit Curiosity Nano kitleri (Positron8/16); çok-kitli profil ("şimdi değil" denmişti, 2.0 ile).
**Bekleyenler:** 3. ders yüklemesi · JonW'ya 2. cevap (C:\Tarim\paylasim_01102026_1900\JonW_Cevap2_02102026_1945.md; JonW_Cevap_Son_02102026_1340.md önceki) · Les'e bank hatası konusu · JonW DTR-hold sürümü gelince: RC7 kablosunu tak, FREELOADER.exe ile COM üzerinden test, sonucu foruma · temiz PC'de COM sürücü testi · YouTube başlık/açıklama düzeltmeleri · CNanoKit-dev About açıklaması.

## 10. Yeniden inşa (gizli arşivden)
C:\Tarim\CNanoKit_Gelistirme_OZEL_03102026_1910\YENIDEN_INSA_v1.1_03102026_1935.md: MinGW-w64 GCC 13 (i686-w64-mingw32-gcc -O2 -s -o CNanoProg.exe CNanoProg.c; CNanoMonitor.exe: -mwindows -DGUI -DSCRIPT=\"CNanoMonitor.ps1\"; CNanoProtonPlugin.exe komutu src başlığında), PowerShell 5.1, Python 3.14.7, pymcuprog 3.19.4.61, PIC18F-Q_DFP 1.31.492. SHA256 listesi: ...\SHA256_v1.1_lisansli_03102026_2010.md. İçindekiler: ...\OKU_BENI_icindekiler_03102026_1910.md.

## 11. Klasörler (tam yollar)
| Yol | İçerik |
|---|---|
| C:\Tarim\CNanoKit_01102026_2005\ | ANA KAYNAK (en güncel): exe/ps1/bat, src\, docs\, examples\ (+asm/hex/lst), proton_mcp_ornek\, settings.ini, log\ |
| C:\Tarim\CNanoKit_Gelistirme_OZEL_03102026_1910\ | kara kutu: 01_CNanoKit_ana_kaynak_01102026_2005, 02_test_araclari, 03_Q71_bootloader_testleri_01102026_1706, 04_video_cekim_paketi_02102026_1640, 05_FREELOADER_analiz_02102026_1240, 06_paylasim_metinleri, 07_video_altyazi + OKU_BENI, YENIDEN_INSA, SHA256 |
| C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\ | repo\ (public depo kaynağı), release\CNanoKit_v1.1_03102026_2000.zip, ozel_depo_icin\CNanoKit_Gelistirme_OZEL_arsiv_03102026_2010.zip, _eski_readme\ (yedekler), GitHub ders dosyaları, YAYIN_REHBERI_TR_03102026_1910.md |
| C:\Tarim\paylasim_01102026_1900\ | forum/JonW/Les metinleri, sürüm zip'leri v0.4…v1.1 (eskiler kullanıcının silme kararında), CNanoKit_Forum_Kilavuzu_TR_04102026_1910.md (YAYINLANAN metin), _eski_kullanma\ |
| C:\Tarim\Q71_CNano_Test_01102026_1706\ | test .bas/.hex (WIREDIAG, BLINK, RD0, UART), P56Q71_MWBOOT.hex (JonW), TEST_B/TEST_R .bat |
| C:\Tarim\araclar\CNanoProg_01102026_1721, CNano_Prog_01102026_1706 | erken sürümler; test betikleri (mwtest_read_02102026_1340.py, mwmerge_02102026_0525.py — ÖZEL) |
| C:\Tarim\FREELOADER_Analiz_02102026_1240\ | FREELOADER kuralları + R test raporu |
| C:\Tarim\Final_Test_Listesi_02102026_1340.md, C:\Tarim\Final_Test_Raporu_02102026_1410.md | final testler |
| C:\Videolar_02102026_1715\, C:\Video_Paketi_02102026_1640\ | video çalışma alanları (asistana yazma izni verilmişti) |
| C:\FREELOADER Free PIC18 bootloader and uploader__by Jon Walker\ | JonW kaynakları — SALT-OKUNUR |
| C:\Microchip_Tools\ | kit kılavuzu DS50003481A, Q71 datasheet DS40002329F, errata DS80001030 — SALT-OKUNUR |
**Yeni yerel çalışma klasörü (kullanıcı onayladı 04.10.2026):** C:\CNanoKit\ — yukarıdaki CNanoKit dosyaları buraya KOPYALANACAK (hiçbir şey silinmez/taşınmaz). Henüz oluşturulmadı: kullanıcı boş klasörü açıp asistana erişim verecek.

## 12. BULUTA GEÇİŞ (04.10.2026)
- **Kredi [A, kullanıcının Usage ekranı]:** Cloud session credits — Included credit **$250 of $250 left**, son kullanma **5 Kasım 2026 10:59 GMT+3**; plan Max (5x). Yalnız cloud session'larda harcanır; bitince normal plan kullanımı. İki proje (Tarim + CNanoKit) aynı krediyi paylaşır.
- **Bulut oturumu GitHub deposunda çalışır**; kullanıcının PC'sini, kiti, IDE'leri, Positron derleyicisini GÖREMEZ [B]. → Derleme, kit programlama, monitör, video ve forum gönderimi kullanıcının PC'sinde; bulutta: belge, kod düzenleme (.ps1/.c/.bas), README/Pages, sürüm paketleme, GitHub işleri, planlama (2.0).
- **Depo:** onderk/CNanoKit-dev (Private, mevcut). Bugün içinde yalnız arşiv ZIP'i var → bulutta çalışmak için arşivin AÇILMIŞ hâli klasör olarak yüklenmeli (web yükleme: tek seferde ≤100 dosya, dosya başına ≤25 MB; 457 dosya → parça parça ya da GitHub Desktop). Kökte bu transfer kütüğü + Kutuk\ klasörü olmalı.
- Public depo onderk/CNanoKit yalnız yayın içindir; kaynak oraya ASLA konmaz.
- **İlk bulut oturumu:** 1) Bu dosyayı oku, özetle. 2) Depo yapısını denetle; Kutuk\CNanoKit_KUTUK_GGAAYYYY_SSDD.md aç. 3) 3. ders durumunu (forum bağlantısı) dışarıdan kontrol et. 4) 2.0 için seçenek raporu (C#/obfuscator vs lisans anahtarı vs mevcut; çoklu kit JSON profil mimarisi) — KOD YAZMADAN, önce plan ve kullanıcı onayı.

## 13. Açık hatırlatmalar
- C:\_silinecek ve eski zip'ler (C:\Tarim\paylasim_01102026_1900\CNanoKit_v0.4…v1.1_03102026_1845.zip, C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\release\_eski_kullanma\CNanoKit_v1.1_03102026_1845.zip) — kullanıcı siler.
- Paylaşım öncesi her zaman: isim taraması + C2PA taraması + bağlantı (HTTP 200) kontrolü.


## ⚠ BULUT KURALLARI — resmi belgelerle doğrulandı (04.10.2026 20:15)
Kaynaklar [A]: (üreticinin destek sitesi, "cloud sessions bonus credit promotion" makalesi) · (üreticinin belge sitesi, "on the web" sayfası)
1. Kredi YALNIZ **cloud session**'ları öder ("cloud session usage is paid for by the credit and doesn't count toward your plan's usage limits"). **Kapsam DIŞI:** "Projects and Routines", remote control, chat/cowork. → asistan aracındaki **"Project" (çoklu oturum koordinasyonu) özelliğini KULLANMA**; her iş için düz bir cloud session başlat. Bu masaüstü Cowork oturumu da krediden düşmez.
2. Son kullanma: 4 Kasım 2026 23:59 PT = **5 Kasım 2026 10:59 GMT+3**. kullanıcının ekranı: "Credit claimed … $250 of $250 left", GitHub "Connected".
3. Oturum başlatma: masaüstü uygulamasında oturum açarken **Local yerine Cloud** seç (ya da üreticinin web sitesi, Code sayfası, mobil Code sekmesi, terminalde `--cloud` seçeneği). Oturum bir GitHub deposunu klonlar, üreticinin yalıtılmış VM'inde çalışır, dal (branch) itebilir, PR açabilir; kullanıcının bilgisayarındaki dosyaları GÖRMEZ.
4. **Gizli depo şartı:** GitHub App yöntemiyle bağlanıldıysa oturum yalnız herkese açık depolara ve **asistanın GitHub uygulamasının KURULU olduğu gizli depolara** erişir → Tarim-dev ve CNanoKit-dev için GitHub → Settings → Applications → Installed GitHub Apps → asistan uygulaması → Configure → "Only select repositories" → bu iki depoyu seç (public CNanoKit isteğe bağlı). Alternatif: terminalde `/web-setup` (gh token).
5. Oturumlar arası hafıza YOK → süreklilik depo dosyalarıyla sağlanır: kökte **CLAUDE.md** (her oturumun otomatik okuduğu kurallar dosyası — bu transfer kütüğünün §1 kurallarının kısa hâli + "önce TRANSFER_KUTUK ve Kutuk\ en son dosyasını oku"), kökte bu transfer kütüğü, Kutuk\ klasöründe her oturum sonunda yeni kütük.
6. Ortam süresi: oturum boşta kalırsa VM geri alınır; konuşma geri gelir, yarım iş gelmez → her önemli adımdan sonra commit + push.
7. Hız sınırları hesaptaki diğer kullanımla ortak; paralel oturumlar daha çok tüketir. Kredi bitince bulut oturumları normal plan kullanımından düşer.
8. İş akışı (öğretilecek): oturum bir dalda çalışır → değişiklikleri diff ekranında incele → PR oluştur → GitHub'da "Merge" → main güncellenir.

---
## EK A — CNanoKit ile ilgili kütük turlarının TAM metni (25–50. turlar; kaynak: C:\Tarim\Kutuk\Tarim_KUTUK_04102026_1935.md)

| Tarih | Ne yapıldı | Sonuç / bekleyen |
|---|---|---|
| 01.10 (25. tur, 17:40) | Gerçek Q71 Curiosity Nano testi: JonW MWBOOT hex yazıldı + doğrulandı; FREELOADER --test/--merge OK; sürükle-bırak OK; CNanoProg 0.2 (Positron Studio F10, 2,9 sn, doğrulamalı); Türkçe Windows 'pıc' hatası düzeltildi. | Bekleyen: LED gözlemi, 2 köprü kablo ile FREELOADER COM8 testi, Proton IDE/VS Code ayar testi, JonW forum cevabı. |
| 01.10 (26. tur, 19:00) | CNanoProg 0.3: Positron Studio F10 + VS Code Program test OK (2-4 sn, doğrulamalı); kurulum betiği, seri monitör, TR kılavuz, kablo şeması, forum paketi hazır. Proton IDE Program düğmesi hiçbir programlayıcıyı başlatmıyor (kanıtlı). Silinecekler C:\_silinecek'e taşınır. Kit: yalnız bootloader. | Bekleyen: 2 köprü kablo -> FREELOADER COM8 testi; tek forum mesajı; Proton IDE eklenti yolu (opsiyonel). |
| 01.10 (27. tur, 20:45) | CNanoKit 0.4 tek klasör: C:\Tarim\CNanoKit_01102026_2005 (Proton IDE eklentisi Program+Monitor test OK, CNano Monitor TR/EN test OK, kurulum betiği -Check gerçek PC'de OK). FREELOADER 1.1 kitle bağlanamıyor (DTR kapalı), bootloader doğru (özel istemciyle kanıtlı). TR+EN kurulum kılavuzu, GitHub yayın kılavuzu (kullanıcı kendi yapacak), forum taslağı. Paylaşım zip: paylasim_01102026_1900\CNanoKit_v0.4_01102026_2030.zip | Bekleyen: kullanıcı 3 IDE'yi kapatıp CNanoProg_Setup.bat çalıştıracak (IDE'ler yeni klasöre yönlenir); temiz PC'de COM sürücü testi; GitHub yayını; forum mesajı; C:\_silinecek kontrolü. |
| 01.10 (28. tur, 22:00) | CNanoKit 0.5: monitör elle bağlanır (port/baud/veri/eşlik/dur, Metin/HEX/Metin+HEX görünüm, metin+HEX gönderme), kitte test OK. Proton eklentisi çift tıklamada bilgi mesajı; Proton IDE Program düğmesi yeniden test OK (1,7 sn). Kurulum idempotent. TR/EN kılavuz SSS + Home/temiz PC uyarısı; kablo resimleri TR/EN (docs\). Forum cevabı JonW (paylasim\Forum_Cevap_JonW_EN_TR_01102026_2200.md) + uyum raporu. Zip v0.5 (src yok). | kullanıcı: forum cevabı; JonW+Les onayı sonrası GitHub; monitörde HEX gönderme elle denenmeli. Gelecek: çok-kitli profil (şimdi değil). |
| 01.10 (29. tur, 23:35) | Komut test programı CNANO_KOMUT_56Q71.bas (okmn/HEX 53/come/stop/help) yazıldı, ilk derlemede çalıştı; Positron Studio F10 (2,1 sn), Proton IDE eklentisi (2,2 sn) ve VS Code ile aynı komut (2,3 sn) ile programlandı; seri yanıtlar betikle doğrulandı. Monitör 0.6: 4 hızlı gönder düğmesi (Shift+tık = düzenle); GUI üzerinden gönderme kitte doğrulandı (19 bayt). Kısa paylaşım metinleri (JonW cevabı, yeni konu, GitHub notu) + video senaryosu: paylasim_01102026_1900. Zip v0.6. | kullanıcı: kendi testleri + videolar; forum/GitHub yayını kendisi. |
| 02.10 (30. tur, 00:20) | Kit kablolu kalıyor (kullanıcı kuralı, hafızada). Teşhis firmware ile ölçüldü: RB5–RC7 kablosu TAKILI; RC6–RB4 kablosu ELEKTRİKSEL TEMAS YOK (iki yönde 111). HELLO ve KOMUT örnekleri RB5–RC7 kablosunu ilk gelen baytta IOC bayraklarıyla güvenle algılıyor; kablo varsa RC7 hiç sürülmüyor, LED monitörde yazı/çubuk olarak gösteriliyor. Kitte KABLOLU algılandı; okmn/53/come/stop monitörde zamanlarıyla doğrulandı. Positron Studio F10 (2,6 sn), Proton eklentisi (2,8 sn), VS Code komutu (2,6 sn). Not: önceki LED sürüm kısa süre RC7 çakışmasıyla çalıştı. Zip v0.7. | kullanıcı: RC6–RB4 kablosunu kontrol etsin (önyükleyici testi için gerekli). Exe-yalnız dağıtım kararı bekliyor. |
| 02.10 (31. tur, 01:45) | kullanıcı: kablo RC7 sökülünce KOMUT LED doğru; kablolu iken LED0 yalnız PC verisinde titreşiyor (beklenen: LED0 kablo ile CDC TX hattında). KOMUT: okmn/53/come stop gelene kadar sürekli; isteğe bağlı dış LED RD0-1k-LED-GND (kablolu da yanar). HELLO: LED ilk tuştan sonra; RD0 dış LED. Setup İngilizce dil hatası düzeltildi ($TR/$tr değişken çakışması). VS Code: Ctrl+Alt+M derle+programla, Ctrl+Alt+P yalnız programla (eklenti package.json kanıtı); setup VS Code kullanıcı görevi CNano Monitor + Ctrl+Alt+N ekliyor. Positron Studio test aracı adı CNano Test yapıldı (isim yok). Zip v0.8. | kullanıcı: RC6-RB4 kablosu; dış LED isteğe bağlı; C# sürüm alt proje sonunda. |
| 02.10 (32. tur, 02:50) | kullanıcı RD0 dış LED taktı. VS Code düğmeleri görünmüyordu: neden .bas dosyasının Positron dilinde açılmaması (eklenti menüleri resourceLangId == pos ister). Setup VS Code ayarına files.associations *.bas=pos ekliyor; Önderin PCsine uygulandı. kullanıcı: Ctrl+Alt+P ve M ikisi de derleyip programlıyor, Ctrl+Alt+N monitörü açıyor (doğrulandı). Paylaşım metinlerine sürümlü gereksinim listesi. Zip v0.9. | kullanıcı: VS Code yeniden başlat + düğmeleri kontrol; KOMUT testi; GitHub planı. |

## 33. tur — 02.10.2026 05:30 (İstanbul)
- JonW forum (konu 3427): 42 numaralı mesajda P56Q71_MWBOOT.zip gönderdi, 43 numaralı mesajda "Did they work?" diye sordu. Cevap taslağı buna göre güncellendi; "yerel kopya" cümlesi doğrulandı.
- HATA 1: CNANO_HELLO_56Q71_NOLED.bas satır 39'da "$endifm" vardı (02:00 UTC'de araya bir "m" girmiş). Derleyici hata vermedi, hex 307 bayt ve config bozuk çıktı → "Verify config 0x300003". Düzeltildi.
- HATA 2: CNANO_KOMUT_56Q71.bas Led_Out içindeki "LATD.0 = bLedOn" satırı, Positron 4.0.6.4 tarafından bank seçimi (movlb) olmadan derlendi; yazma RAM 0x543'e (sTx dizgisi) gitti, port etkilenmedi, RD0 yanmadı. Satır If/Else + sabit atama olarak değiştirildi.
- Yeni (özel, paylaşılmaz): Q71_CNano_Test\P56Q71_CNANO_RD0_02102026_0525.bas (3 sn hızlı yanıp sönme + 3 sn fade + çift flaş, RD0), TEST_B_bootloader_02102026_0525.bat, araclar\mwmerge_02102026_0525.py (FREELOADER --merge görüntüsüyle bayt bayt aynı olduğu doğrulandı).

## 34. tur — 02.10.2026 12:40 (İstanbul)
- TEST_B GEÇTİ: JonW P56Q71_MWBOOT gerçek 56Q71'de; bootloader üzerinden yükleme (sync B, 4 sayfa K, EEPROM K, X K, 0.35 s), RD0 deseni, UART1 satırları, reset zinciri. RC6→RB4 teması iyi.
- Bulgu: VS Code Ctrl+Alt+P DERLEMEZ (KOMUT.hex 00:09, .bas 02:18; NOLED.hex 05:00 eski) → iki düzeltme kite hiç gitmedi. Kullanıcıda Ctrl+Alt+M çalışmıyor. Çözüm: Ctrl+Alt+C sonra Ctrl+Alt+P. KURULUM/INSTALL belgelerindeki "P de derliyor" satırı düzeltildi.
- R komutu: eski deneme LEN=8 ile yapılmış; JonW belgesine göre LEN=0 şart → "L" doğru cevaptı. Yeni tam test: araclar\mwtest_read_02102026_1235.py + Q71_CNano_Test\TEST_R_okuma_02102026_1235.bat.
- Yeni: paylasim\Les_Bank_Hatasi_Metni_02102026_1240.md + BANK_REPRO_56Q71_02102026_1240.bas (derlenip asm eklenecek); docs\YENI_PC_KURULUM_TR / NEW_PC_SETUP_EN_02102026_1240.md; FREELOADER_Analiz_02102026_1240\ kurallar + R test raporu.

## 35. tur — 02.10.2026 13:40
- TEST_B iki kez daha GEÇTİ (0.36 / 0.37 s). TEST_R: sync, INFO, 64 KB R == beklenen == debugger, EEPROM GEÇTİ. FAIL'ler betik hatası: DEVID ofseti (27/28 olmalıydı → 0x7760 doğru), 5a tek adres "lite" Asm sürümünde reddedilmiyor (belgeyle uyumlu) → cevap verisi sonraki testleri kaydırdı. Düzeltilmiş: mwtest_read_02102026_1340.py + TEST_R_okuma_02102026_1340.bat.
- Les örneği derlendi: (A) satır içi ve (B) etiket sonrası "LATD.x = Bit" MOVLB yok; (C) sabit MOVLB 0x01 alıyor. Metin: paylasim\Les_Bank_Hatasi_Metni_02102026_1340.md.
- JonW cevabı son hâli: paylasim\JonW_Cevap_Son_02102026_1340.md (DTR-hold isteği, test özeti).
- Final test listesi: C:\Tarim\Final_Test_Listesi_02102026_1340.md

## 36. tur — 02.10.2026 14:10
- FINAL TESTLER GEÇTİ (rapor: C:\Tarim\Final_Test_Raporu_02102026_1410.md). R testi 13/14; LEN≠0 → cevap yok (01.10'daki LEN 8 denemesi de b'' idi; önceki "L döndü" ifadem yanlıştı, düzeltildi).
- FREELOADER --info COM8: "no bootloader answered in 30 s (bytes seen: none)" → DTR kanıtı.
- JonW cevabına FYI satırı eklendi; analiz belgesi sonuçlarla güncellendi.

## 37. tur — 02.10.2026 14:25
- Kalıcı kural hafızaya yazıldı: her dosya/klasör için TAM YOL yazılacak.
- CNanoKit v1.0 zip: C:\Tarim\paylasim_01102026_1900\CNanoKit_v1.0_02102026_1425.zip (18 dosya, yasak isim taraması temiz, düzeltilmiş örnekler + yeni PC listeleri).
- Forum konusu metni: C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Konusu_02102026_1425.md

## 38. tur — 02.10.2026 16:45
- Video için kimlik içermeyen paket: C:\Tarim\Video_Paketi_02102026_1640\ (göreli yollu 4 .bat, kendi CNanoKit kopyası; CNanoProg.ps1 kopyasında kullanıcı klasörü ekranda %USERPROFILE% olarak gizleniyor; R testi 5b "cevap yok / L" ikisini de kabul eder). C:\Yeni klasör için klasör izni penceresi zaman aşımına uğradı → kullanıcı kopyalayacak.
- 15:54/15:59 R testi "no sync": çipte bootloader yoktu (önceki CNanoKit programlaması silmişti) → sıra: önce TEST_B, sonra TEST_R. 16:18/16:19: 13/14 geçti (5b sessiz).

## 39. tur — 02.10.2026 17:50
- Video çalışma alanları (kullanıcı taşıdı; izin verildi): C:\Videolar_02102026_1715\ (1_ham_videolar, 2_altyazili_cikti, Altyazi_Taslaklari_02102026_1715.md) ve C:\Video_Paketi_02102026_1640\ (bat + CNanoKit kopyası). Tarim içindeki video klasörleri kaldırıldı (kullanıcı).
- Video testleri: TEST_B 0.36 s, TEST_R ALL PASS, FREELOADER zaman aşımı — ekranda kimlik yok.

## 40. tur — 02.10.2026 19:55
- 16 video İngilizce altyazılı (gömülü MP4 + SRT): C:\Videolar_02102026_1715\2_altyazili_cikti\ (JonW1-4, CNanoKit0-10). Betik: C:\Videolar_02102026_1715\_isleme_02102026_1900\altyazi_yap_02102026_1930.py. Ham klasörde 3 video iki kez vardı (aynı görüntü).
- JonW #51 (02.10 13:24): LEN her komutta veri sayısıdır (bizim çerçevemiz veri taşımadı → sessiz yeniden başlama; 8 sahte bayt + doğru CRC → L); DTR-hold seçeneği ekleyecek ve haber verecek; UART2 sürümüne bakacak; debugger notu ekleyecek.
- 2. cevap taslağı: C:\Tarim\paylasim_01102026_1900\JonW_Cevap2_02102026_1945.md

## 41. tur — 03.10.2026 18:55
- 10 CNanoKit videosu YouTube başlıklarıyla eşlendi (oEmbed ile doğrulandı); yüklenmeyenler: CNanoKit0 (kısa) ve CNanoKit3a (tekrar).
- Forum konusu yeniden yazıldı (IDE gruplu, 5 mesaj): C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Konusu_03102026_1850.md
- Paket v1.1: C:\Tarim\paylasim_01102026_1900\CNanoKit_v1.1_03102026_1845.zip (16 dosya). İki PNG çıkarıldı: içlerinde C2PA içerik kimliği (üretici kimliği) var; kimlik silinmedi, görseller pakete konmadı. Belgeler: foto forumda; DTR-hold güncellemesi eklendi. CNanoProg.ps1 ana kopyaya kullanıcı klasörü gizleme eklendi (videoda test edilen sürümle aynı).
- Eskimiş: CNanoKit_v1.1_03102026_1840.zip (kullanıcı C:\_silinecek içine taşıyabilir).

## 42. tur — 03.10.2026 19:15
- Yeni plan: önce GitHub (kullanım dosyaları), forumda GitHub bağlantısı. Kanıt: GitHub public = internetteki herkes; private = yalnız davet edilenler; "yalnız GitHub üyeleri" seçeneği yok. Useful Tools bölümüne normal üyeler de konu açıyor.
- Özel arşiv (kopya): C:\Tarim\CNanoKit_Gelistirme_OZEL_03102026_1910\ — yayın: C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\ (repo + release + rehber; tarama temiz). JonW video sırası oEmbed ile doğrulandı.
- AÇIK KARAR: release zip içindeki .ps1 (okunabilir program kaynağı) — C# exe-only yapılana kadar bekle / şimdi .ps1 ile yayınla.

## 43. tur — 03.10.2026 19:40
- GitHub hesabı: onderk (oturum yalnız bağlı depolarda çalışabiliyor; depo/organizasyon oluşturamıyor). "onderk" adı gerçek adı gösteriyor → yayın için okmn-pic / okmn-tools (ikisi de şu an boş) önerildi; "okmn" başkasına ait.
- GitHub Pages: public depoda ücretsiz (okmn-pic.github.io/CNanoKit).
- .ps1 analizi: programın tamamı .ps1 içinde → okuyan kopyalayabilir; LICENSE.txt şu an MIT (kopyalama/değiştirme serbest). C#/.NET exe de kolayca geri çözülebilir (obfuscator gerekir).
- Arşive yeniden inşa belgesi + SHA256 eklendi: C:\Tarim\CNanoKit_Gelistirme_OZEL_03102026_1910\YENIDEN_INSA_v1.1_03102026_1935.md
- AÇIK KARARLAR: yayın hesabı adı, lisans, v1.1 şimdi mi / C# 2.0 sonra mı.

## 44. tur — 03.10.2026 20:20
- Kararlar: mevcut hesap onderk (adın görünmesi kabul); lisans freeware (değiştirme/değiştirilmiş dağıtım yok); v1.1 şimdi .ps1 ile; CNanoKit 2.0 sonra (C# ya da daha zor kırılan lisanslı çözüm, karar açık).
- Yeni LICENSE.txt + başlık satırları güncellendi; paket: C:\Tarim\paylasim_01102026_1900\CNanoKit_v1.1_03102026_2000.zip (tarama temiz). GitHub Pages sayfası: ...\CNanoKit_GitHub_YAYIN_03102026_1910\repo\index.html (masaüstü+mobil görünüm kontrol edildi).
- Özel depo zip: ...\ozel_depo_icin\CNanoKit_Gelistirme_OZEL_arsiv_03102026_2010.zip (3.5 MB, 457 dosya). Adım adım rehber: ...\GITHUB_ADIM_ADIM_TR_03102026_2015.md. Forum metni: C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Konusu_03102026_2015.md

---
## 45. tur — 04.10.2026 17:45 — GitHub kontrol + forum kılavuzu
- Kontrol (dışarıdan): Pages https://onderk.github.io/CNanoKit/ 200 ÇALIŞIYOR (ilk 404 = kurulum anı). releases/latest → tag CNanoKit_1.1 OK. CNanoKit-dev dışarıdan 404 = gizli OK.
- SORUN: onderk/CNanoKit'te sadece LICENSE.txt, README.md, index.html var; docs/ ve examples/ yüklenmemiş → docs bağlantıları 404. CNanoKit-dev'e yanlış zip (public zip) yüklenmiş.
- Oturum GitHub API ile yazamıyor (depo oturuma bağlı değil, 403) → kullanıcı web'den yükleyecek.
- README.md güncellendi (videolar 2 grup: CNanoKit IDE tablosu HELLO→NOLED→KOMUT + Monitor; JonW Part 1–4). Yedek: C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\_eski_readme\README_onceki_03102026_1910.md
- Yeni: C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\GITHUB_DUZELTME_ADIM_ADIM_TR_04102026_1735.md (A docs/examples/README yükle, B özel depo düzelt, C kontrol, D öğrenme).
- Yeni: C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Kilavuzu_TR_04102026_1735.md (tek dosya; eski CNanoKit_Forum_Konusu_03102026_2015.md yerine). 14 YouTube kimliği oEmbed ile doğrulandı.
- Bekleyen: kullanıcı A+B+C → forum konusu → topic adresi README/index'e eklenecek; JonW DTR-hold; Les konusu; JonW_Cevap2.
- Hatırlatma: C:\_silinecek ve eski zip'ler kullanıcı tarafından silinecek.

---
## 46. tur — 04.10.2026 18:25 — GitHub 1. ders tamam, resimler, forum son hâl
- Kullanıcı A+B yaptı. Dış kontrol 18:07: depo/Pages/LICENSE/5 docs 200; CNanoKit-dev 404 (gizli), doğru arşiv, yanlış zip silindi. Release zip SHA256 = yerel (664c38fd…1b4f).
- İsim taraması: release zip (exe UTF-8/16 dahil) + main (14 dosya): yasak isim yok; tek istisna onderk kullanıcı adı → karar kullanıcıda (A kalsın / B Change username; GitHub belgesi: depo yönlendirilir, profil 404, eski ad serbest; Pages yönlendirmesi belgede yok).
- "Source code (zip/tar.gz)": GitHub otomatik ekliyor (About releases belgesi). Tag arşivi indirildi: sadece LICENSE, README, index.html.
- Resimler: C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\repo\images\ (Wiring_JonW_mwboot_TR_04102026_1815.png, Kit_wiring_photo_04102026_1815.png; meta veri yok). README, index.html, docs JonW notuna eklendi; yedekler _eski_readme\.
- Yeni: C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\GITHUB_DERS2_RESIM_EKLE_TR_04102026_1820.md
- Yeni (forum son hâl): C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Kilavuzu_TR_04102026_1820.md (1735 ve 03102026_2015 eskidi).
- Bekleyen: kullanıcı ders 2 yüklemesi; onderk kararı; forum; topic adresi → README/index.

---
## 47. tur — 04.10.2026 18:35 — GitHub ders 2 tamam, forum son hâl (BBCode)
- Kararlar: onderk kalır (kesin); Source code arşivleri kalır; Microchip pin çizimi kaynak satırıyla kullanılır.
- Dış kontrol 18:30: GitHub main 13 dosya = yerel repo (SHA256 aynı); Pages, 2 resim, release, zip, JonW konusu 200; CNanoKit-dev 404.
- SORUN: images\ içindeki 2 PNG'de C2PA üretici gömülü (benim yazdığım dosyalara sistem ekliyor). Silmiyorum; kullanıcı kendi orijinallerini aynı adla yeniden yükleyecek, sonra ben kontrol edeceğim. Zip/exe/metinlerde yok.
- Forum metni BBCode'a çevrildi (protoncompiler.com = SMF; Markdown çalışmaz).
- Yeni: C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Kilavuzu_TR_04102026_1835.md; eski kılavuzlar → C:\Tarim\paylasim_01102026_1900\_eski_kullanma\
- Bekleyen: resim değişimi + kontrol → forum → topic adresi README/index'e.

---
## 48. tur — 04.10.2026 18:55 — resimler temiz, forum metni okunaklı BBCode
- Kullanıcı 2 resmi kendisi yeniden yükledi: GitHub + Pages kopyalarında C2PA/üretici adı/GPS yok (yalnız SnipMetadata kırpma koordinatı).
- Forum önizlemesi bitişikti (SMF 2.1.7 + SCEditor tek satır sonlarını birleştirdi). Yeni metin: [list][li], 2 [table] (tuşlar, 3×3 video), [url=] kısa bağlantılar, başlıklar, JonW şeması [img width=360]. 4 video mesajı → tek POST 2. Etiket dengesi ve 23 bağlantı (hepsi 200) kontrol edildi.
- Yeni: C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Kilavuzu_TR_04102026_1855.md; 1835 → _eski_kullanma\.
- Bekleyen: kullanıcı önizlemesi → forum → topic adresi README/index'e.

---
## 49. tur — 04.10.2026 19:10 — forum önizlemesi onaylandı
- Önizleme iyi; düzeltmeler: başlık 72 karakter ("CNanoKit: one-key programming for PIC18F56Q71 Curiosity Nano + Positron8"), tablo hücrelerine bölünmez boşluk.
- Yayınlanacak dosya: C:\Tarim\paylasim_01102026_1900\CNanoKit_Forum_Kilavuzu_TR_04102026_1910.md (1855 → _eski_kullanma).
- Bekleyen: yayın → topic adresi README/index.

- 19:20: önizleme onaylandı (tablolar aralıklı). "Kaynak modu" adımı kaldırıldı (gerekmiyor; düğme kullanıcının ekranında yok).

---
## 50. tur — 04.10.2026 19:35 — FORUM KONUSU YAYINDA
- https://protoncompiler.com/index.php/topic,3440.0.html — Useful Tools, başlık doğru, 2 mesaj (msg 25105 + 25106), 2 tablo, 8 liste, şema resmi; 21 bağlantı 200; yasak isim yok.
- README.md + index.html: "Forum topic" bağlantısı eklendi (yerel repo). Yedek: _eski_readme\*_onceki_04102026_1815.*. Kullanıcı 3. ders yüklemesini yapacak.
