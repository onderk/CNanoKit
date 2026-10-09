# protoncompiler.com — reply in JonW's FREELOADER thread (draft)

You post this yourself, as **okmn**. Post only the **EN** part on the forum; the TR part is for you, so you know exactly what you are saying.

Before posting, check two things:

- Do not attach anything: no zip, no source code, no hex file.
- There is no link in this message. The download link is added only after Jon and Les have replied.

---

## EN (to post)

Hi Jon,

Thank you for the Q71 bootloader and for your time. Here is what I did and what I found, as clearly as I can.

**Setup**
- Board: PIC18F56Q71 Curiosity Nano (EV01G21A), on-board nEDBG debugger, firmware 1.27.
- Software: Positron8 4.0.6.4 on Windows 11 Pro.
- Your files: `P56Q71_MWBOOT.hex`, used unmodified. For the application test I made a local copy of your test program, changed only for the kit's LED pin (RC7), with your header kept. That copy stays on my PC and will not be shared.
- Wiring: your bootloader uses UART1 on RC6/RC7, and the kit's USB-serial bridge sits on RB4/RB5. So I fitted two jumper wires: RC6 → RB4 and RB5 → RC7.

**1. Bootloader on the real chip: works**
- I wrote `P56Q71_MWBOOT.hex` with the kit's own debugger, then read it back. The read-back matched the file.
- `FREELOADER --merge` and `--test` ran fine offline.
- Over the serial line:
  - Sync `U` → `B` came inside the 100 ms window.
  - `I` returned `K` and the info block: MWB 01 04 23, flash 0x10000, slot 0xFCF8, page 0x100, EEPROM 0x100 @ 0x380000, DEVID 0x7760, CRC OK.
  - I wrote 3 pages + EEPROM, then `X` → `K`, and the application started.
  - The flash read back with the debugger was byte-identical to your `--merge` output.
  - Re-entry after a reset also worked.

**2. FREELOADER.exe 1.1 cannot talk through this kit's USB port**
- The Curiosity Nano's USB-serial bridge only passes data while the PC holds **DTR asserted**. Microchip documents this in the kit user guide DS50003481A, §3.1.2.4.
- FREELOADER.exe opens the port with DTR off. I tried it with no options, `--dtr`, `--rts` and `--dtr --rts`. Each time it waited at "Reset the board now…" and timed out.
- To make sure the problem was only DTR, I wrote a small private test script from the protocol description in your source comments, with DTR held on. With it, the steps in point 1 worked. That script is only for my own test: I will not share or publish it, and it is not part of anything I make.

**What I could not verify**
- The `R` (read) command: my frame got no reply, and my frame format may simply be wrong.
- Uploading with FREELOADER.exe itself, because of the DTR point above.

**Two small requests, only if you find them useful**
1. An option that keeps DTR asserted for the whole session, for boards like the Curiosity Nano. With it, all nEDBG kits could use FREELOADER through their own USB port, and the kit's debugger could do the reset, so no reset button is needed.
2. If you ever have time: a Curiosity Nano variant of the bootloader on UART2 RB4/RB5 (the kit's own USB-serial pins). It would need no wires at all.

**About respecting your work**
- I have not re-packaged or shared any of your files or source; the only change (the local LED-pin copy above) never leaves my PC.
- I also made a small free helper for myself: one-key programming and a serial monitor for this kit from Positron Studio, Proton IDE and VS Code, using Microchip's pymcuprog. It contains nothing of FREELOADER.
- If I ever share it, it will only point people to this thread for FREELOADER, under your licence. I will not share it before you (and Les, for the Proton IDE plugin part) have had a chance to say whether you are OK with that.

Thanks again for FREELOADER and for your patience.

okmn

---

## TR (sizin için çeviri — foruma koymayın)

Merhaba Jon,

Q71 önyükleyicisi ve ayırdığın zaman için teşekkürler. Ne yaptığımı ve ne bulduğumu olabildiğince açık yazıyorum.

**Düzenek**
- Kart: PIC18F56Q71 Curiosity Nano (EV01G21A), üstündeki nEDBG hata ayıklayıcı, yazılım 1.27.
- Yazılım: Windows 11 Pro üzerinde Positron8 4.0.6.4.
- Senin dosyaların: `P56Q71_MWBOOT.hex`, değiştirilmeden kullanıldı. Uygulama testi için test programının yerel bir kopyasını yaptım; yalnız kitin LED pinine (RC7) göre değiştirdim ve başlığını korudum. O kopya benim PC'mde kalıyor, paylaşılmayacak.
- Kablolama: önyükleyicin UART1'i RC6/RC7'de kullanıyor, kitin USB-seri köprüsü ise RB4/RB5'te. Bu yüzden iki köprü kablo taktım: RC6 → RB4 ve RB5 → RC7.

**1. Önyükleyici gerçek çipte çalışıyor**
- `P56Q71_MWBOOT.hex` dosyasını kitin kendi hata ayıklayıcısıyla yazdım ve geri okudum; geri okunan içerik dosyayla aynıydı.
- `FREELOADER --merge` ve `--test` çevrimdışı sorunsuz çalıştı.
- Seri hat üzerinden:
  - Senkron `U` → `B` 100 ms penceresi içinde geldi.
  - `I` komutu `K` ve bilgi bloğunu döndürdü: MWB 01 04 23, flash 0x10000, slot 0xFCF8, sayfa 0x100, EEPROM 0x100 @ 0x380000, DEVID 0x7760, CRC doğru.
  - 3 sayfa + EEPROM yazdım, ardından `X` → `K` geldi ve uygulama başladı.
  - Hata ayıklayıcıyla geri okunan flash, `--merge` çıktınla bayt bayt aynıydı.
  - Reset sonrası yeniden giriş de çalıştı.

**2. FREELOADER.exe 1.1 bu kitin USB portu üzerinden konuşamıyor**
- Curiosity Nano'nun USB-seri köprüsü, PC **DTR'yi açık** tutmadıkça veri geçirmiyor. Microchip bunu kit kılavuzu DS50003481A §3.1.2.4'te belgeliyor.
- FREELOADER.exe portu DTR kapalı açıyor. Seçeneksiz, `--dtr`, `--rts` ve `--dtr --rts` ile denedim. Her seferinde "Reset the board now…" satırında bekleyip zaman aşımına düştü.
- Sorunun yalnız DTR olduğundan emin olmak için, kaynak kodundaki yorumlarda anlatılan protokolden DTR'yi açık tutan küçük, özel bir test betiği yazdım. Onunla 1. maddedeki adımlar çalıştı. Bu betik yalnız benim testim içindir: paylaşmayacağım, yayınlamayacağım ve yaptığım hiçbir şeyin parçası değil.

**Doğrulayamadıklarım**
- `R` (okuma) komutu: gönderdiğim çerçeveye yanıt gelmedi; çerçeve biçimim yanlış olabilir.
- FREELOADER.exe'nin kendisiyle yükleme, yukarıdaki DTR durumu yüzünden.

**İki küçük rica (yalnız işine yararsa)**
1. Curiosity Nano gibi kartlar için oturum boyunca DTR'yi açık tutan bir seçenek. Böylece tüm nEDBG kitleri FREELOADER'ı kendi USB portlarından kullanabilir ve reseti kitin hata ayıklayıcısı atabilir; reset düğmesine gerek kalmaz.
2. Vaktin olursa: önyükleyicinin kitin kendi USB-seri pinlerini (UART2, RB4/RB5) kullanan bir Curiosity Nano sürümü. Hiç kablo gerektirmez.

**Emeğine saygı**
- Senin hiçbir dosyanı ya da kaynağını yeniden paketlemedim, paylaşmadım; tek değişiklik (yukarıdaki yerel LED-pin kopyası) PC'mden çıkmıyor.
- Kendim için küçük, ücretsiz bir yardımcı da yaptım: Microchip'in pymcuprog aracıyla, bu kit için Positron Studio, Proton IDE ve VS Code'dan tek tuşla programlama ve bir seri monitör. İçinde FREELOADER'dan hiçbir şey yok.
- Bir gün paylaşırsam, FREELOADER için insanları yalnız bu konuya, senin lisansınla yönlendireceğim. Sen (ve Proton IDE eklentisi kısmı için Les) uygun olup olmadığını söyleme fırsatı bulmadan paylaşmayacağım.

FREELOADER ve sabrın için tekrar teşekkürler.

okmn
