# FREELOADER / mwboot — kurallar, karar tablosu, R testi (02.10.2026)

**Kaynaklar (birincil):** JonW'nin forum konusu 3427 (sayfa 1–3, 49 mesaj) · JonW'nin belgeleri (FREELOADER klasöründe `Documentens HTML`): `MWBOOT_PIC.html`, `FREELOADER_C_HELP.html`, `BENCH_TESTS_SIMPLE.html`, `MWBOOT_CHANGE_DEVICE.html` · bizim kit ölçümlerimiz (log klasörü).

## 1. Sistem tek cümlede
**mwboot** çipin en üstünde duran 776 baytlık bootloader'dır; **FREELOADER** PC tarafındaki yükleyicidir. Reset → mwboot 100 ms "U" bekler → gelirse sayfa sayfa yazar; gelmezse uygulamayı başlatır.

## 2. Değişmez kurallar (JonW'nin belgelerinden)
| # | Kural | Kaynak |
|---|---|---|
| K1 | Bootloader kendini asla silmez; bootloader sayfalarına yazma/silme isteği **A** ile reddedilir. | MWBOOT_PIC "Rules" |
| K2 | 0x0000'daki GOTO bootloader'a gider; cihaz bunu her sayfa-0 yazışında **kendisi** geri koyar. | MWBOOT_PIC |
| K3 | Uygulamanın ilk 8 baytı **slot**a taşınır (56Q71: 0xFCF8). Bootloader çıkışta oraya atlar. | MWBOOT_PIC, kit ölçümü |
| K4 | Uygulama **0xFCF7'yi geçemez** (56Q71: en çok 64 760 bayt). Geçerse FREELOADER yazmadan reddeder. | FREELOADER_C_HELP, CHANGE_DEVICE |
| K5 | mwboot **config (fuse) yazmaz**; uygulama bootloader'ın fuse'larıyla çalışır. | forum #39, BENCH |
| K6 | Kablo yarıda çekilirse zarar yok: slot sayfası önce silinir, en son yazılır; boş slot = bootloader'a geri dönüş. | MWBOOT_PIC |
| K7 | Her çerçevede CRC-16/CCITT-FALSE; her yazılan sayfa geri okunur, fark varsa **F**. | MWBOOT_PIC |
| K8 | Hız sabittir (115200, bootloader derlenirken seçilir); `--baud` yalnız PC tarafını ayarlar. | FREELOADER_C_HELP |
| K9 | Debugger/IDE ile normal programlama **çipi tamamen siler** → bootloader da gider. Geri getirmek: `P56Q71_MWBOOT.hex`'i yeniden yazmak. | CNanoProg kaydı "Erasing device before writing" |
| K10 | Positron, BASIC çalışırken **BSR = 5** varsayar. | MWBOOT_PIC "Three Positron facts" |

## 3. Lisans ve iletişim kuralları (JonW)
- Değiştirilmiş sürüm dağıtılamaz; başlık korunur; Python kaynakları paketlere konmaz.
- JonW kaynak paylaşımının destek yükü getirdiğini yazdı (#37): **kaynak istemiyoruz, kısa yazıyoruz.**
- Q71 resmi listesinde yok (#39); 56Q71 dosyasını bize özel gönderdi (#42) ve **"çalıştı mı?"** diye sordu (#43). Cevap taslağı hazır.

## 4. Karar tablosu — hangi durumda ne?
| Durum | Araç | Kablo |
|---|---|---|
| Kendi programını yaz, dene, monitörle konuş | CNanoKit (F10 / Ctrl+Alt+M / Proton düğmesi) | **Gerekmez** |
| Bootloader'ı çipe koy | CNanoProg + `P56Q71_MWBOOT.hex` | Gerekmez |
| Uygulamayı bootloader üzerinden yükle | Şimdilik bizim özel betik (DTR açık). FREELOADER.exe 1.1 kitte bağlanamaz (K11). | **İkisi de şart** |
| Fabrikada tek seferde bootloader + uygulama | `FREELOADER --merge` (ya da bizim doğrulanmış birleştiricimiz) → CNanoProg | Gerekmez |
| Bootloader'ın okuduğunu doğrula (R) | `TEST_R_okuma_02102026_1235.bat` | **İkisi de şart** |

**K11 (bizim bulgumuz, belgeyle uyumlu):** FREELOADER `--dtr` yalnız ~40 ms **darbe** verir ve "port açılınca iki hattı da bırakır" (FREELOADER_C_HELP). Curiosity Nano'nun USB-seri köprüsü ise yalnız **DTR sürekli açıkken** veri geçirir (DS50003481A §3.1.2.4). Bu yüzden JonW'den istenen şey bir **"DTR'yi açık tut"** seçeneği; darbe değil.

## 5. Bizim 56Q71 sonuçları
| Test | Sonuç | Kanıt |
|---|---|---|
| Senkron U→B, INFO, sayfa + EEPROM yazma, X çıkış | **GEÇTİ** (01.10 ve 02.10) | TEST_B çıktısı: sync B, 4 sayfa K, EEPROM K, X K, 0.35 s |
| Reset → bootloader → uygulama zinciri | **GEÇTİ** | RD0 deseni ve "UART 56Q71 n" satırları reset sonrası yeniden başladı |
| RC6→RB4 teması | **İyi** | monitöre UART1 satırları geldi |
| FREELOADER.exe 1.1 ile yükleme | **Bağlanamıyor** (DTR) | 01.10 denemeleri + 02.10 `--info COM8`: "no bootloader answered in 30 s (bytes seen: none)" |
| R (okuma) | **GEÇTİ** (LEN≠0'da cevap yok — belgeden küçük fark) | log\R_test_02102026_1356.txt |

## 6. R komutu — neden olmadı, nasıl tam test edilecek
**Neden olmadı:** eski betiğim `R 0x380000` çerçevesini **LEN = 8** ile gönderdi. Belgeye göre R'de **LEN 0 olmalı**, cevap her zaman 256 bayt. Hata cihazda değil, bendeydi. (Belge LEN≠0 için **L** diyor; bu 56Q71 sürümü ise **hiç cevap vermiyor** — 01.10 ve 02.10 iki kez aynı. Zararsız: sonraki çerçeve çalışıyor.)

**SONUÇ (02.10 13:56, `log\R_test_02102026_1356.txt`): 14 maddeden 13 GEÇTİ.** 64 KB R okuma = beklenen = debugger; EEPROM doğru; tek adres, bozuk CRC, bilinmeyen komut doğru. Tek fark: LEN 1 → cevap yok (belgede L).

**Belgedeki tanım:** `R addr 00` → `K + 256 bayt + CRC(2)`; cevap CRC'si K'den başlar; flash adresi çift olmalı; EEPROM (0x38xxxx) ve config (0x30xxxx) bayt bayt okunur; "bootloader dahil her şey okunabilir".

**Test (`TEST_R_okuma_02102026_1235.bat`, ~15 sn):**
1. Monitör kapalı, iki kablo takılı, çipte TEST_B sonrası bootloader + RD0 uygulaması.
2. Betik U gönderirken debugger PIC'i resetler → **B** (senkron).
3. **I**: "MWB", özellik bit0 = R destekli, DEVID 0x7760.
4. **Tüm 64 KB flash** 256 sayfa R ile okunur → beklenen görüntüyle bayt bayt (bootloader + slot + zorlanan GOTO dahil).
5. **EEPROM** 0x380000 → `11 22 33 H E L L O`. **Config** 0x300000 bilgi olarak yazılır.
6. **Ret testleri:** tek adres → L · LEN 1 → L · bozuk CRC → C · bilinmeyen komut → ? · ardından R yine çalışmalı.
7. **X** → K → RD0 deseni başlar.
8. **Bağımsız çapraz kontrol:** debugger ile flash okunur, R ile okunanla bayt bayt karşılaştırılır.
9. Rapor: `araclar\CNano_Prog_01102026_1706\log\R_test_<tarih>.txt`, sonda **ALL PASS**.

## 7. İsteğe bağlı sonraki adım (JonW'nin kendi yöntemi)
BENCH_TESTS_SIMPLE'daki FULL / EDGE / OVER testleri 56Q71'e uyarlanabilir: FULL = 0xFCF7'ye kadar dolu, EDGE = 0xFBFF'e kadar, OVER = 0xFCF8'e 1 bayt taşan (reddedilmeli). JonW'nin `hextool.py pad/diff` araçları klasörde var. Kararı sen verirsin.
