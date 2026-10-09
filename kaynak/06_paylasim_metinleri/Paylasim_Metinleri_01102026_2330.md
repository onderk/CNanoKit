# Paylaşım metinleri — kısa (01.10.2026)

Foruma ve GitHub'a **yalnız İngilizce (EN)** kısımları koyun. Türkçe (TR) kısımlar sizin içindir.

---

## 1) JonW'ye cevap (FREELOADER konusunda)

**EN**

Hi Jon,

You asked if it worked: yes, on the real chip. I tested your Q71 bootloader on a PIC18F56Q71 **Curiosity Nano** (Positron8 4.0.6.4, Win11). Your bootloader uses UART1 on RC6/RC7 and the kit's USB-serial is on RB4/RB5, so I fitted two jumpers: RC6→RB4 and RB5→RC7.

**Works on the real chip:** sync (U→B), info (I→K, DEVID 0x7760, CRC OK), page + EEPROM write, verify, exit (X→K, app starts), and re-entry after reset. A debugger read-back matched your `--merge` output byte for byte.

**One problem:** the Curiosity Nano's USB-serial only passes data while **DTR is on** (Microchip DS50003481A §3.1.2.4). FREELOADER.exe 1.1 opens the port with DTR off, so it waits at "Reset the board now…" and times out. I tried no options, `--dtr`, `--rts`, and `--dtr --rts`. To confirm it was only DTR, I used a small private test script, which I will not share.

**Not verified:** the `R` command; my frame may be wrong.

**Only if you find it useful:**
1. An option to keep DTR on would make every Curiosity Nano work through its own USB port, with the kit doing the reset.
2. A Curiosity Nano build on UART2 (RB4/RB5) would need no wires.
3. A note for users: after the bootloader is in, programming the kit the normal way (debugger/IDE) erases the bootloader too.

**Your licence:**
- I used `P56Q71_MWBOOT.hex` unmodified.
- I made one local copy of your Q43 BLINK test program, adapted to the 56Q71 kit (device, LED pin, a UART line), with your header kept. It stays on my PC.
- Nothing of yours is re-packaged or shared anywhere.

Thanks for FREELOADER!
okmn

**TR (sizin için)**

Merhaba Jon,

Çalıştı mı diye sormuştun: evet, gerçek çipte çalışıyor. Q71 önyükleyicini bir PIC18F56Q71 **Curiosity Nano** üzerinde denedim (Positron8 4.0.6.4, Win11). Önyükleyicin UART1'i RC6/RC7'de kullanıyor, kitin USB-serisi ise RB4/RB5'te; bu yüzden iki kablo taktım: RC6→RB4 ve RB5→RC7.

**Gerçek çipte çalışanlar:** senkron (U→B), bilgi (I→K, DEVID 0x7760, CRC doğru), sayfa ve EEPROM yazma, doğrulama, çıkış (X→K, uygulama başlıyor) ve reset sonrası yeniden giriş. Hata ayıklayıcıyla geri okunan içerik, senin `--merge` çıktınla bayt bayt aynı.

**Tek sorun:** Curiosity Nano'nun USB-serisi yalnız **DTR açıkken** veri geçiriyor (Microchip DS50003481A §3.1.2.4). FREELOADER.exe 1.1 portu DTR kapalı açıyor; bu yüzden "Reset the board now…" satırında bekleyip zaman aşımına düşüyor. Seçeneksiz, `--dtr`, `--rts` ve `--dtr --rts` ile denedim. Sorunun yalnız DTR olduğunu doğrulamak için küçük, özel bir test betiği kullandım; onu paylaşmayacağım.

**Doğrulanmadı:** `R` komutu; çerçevem yanlış olabilir.

**Yalnız işine yararsa:**
1. DTR'yi açık tutan bir seçenek, tüm Curiosity Nano kitlerini kendi USB portlarıyla çalıştırır; reseti de kit atar.
2. UART2 (RB4/RB5) kullanan bir Curiosity Nano sürümü kablo gerektirmez.
3. Kullanıcılar için bir not: önyükleyici yüklendikten sonra kiti normal yoldan (hata ayıklayıcı/IDE) programlamak önyükleyiciyi de siler.

**Lisansın:**
- `P56Q71_MWBOOT.hex` dosyasını değiştirmeden kullandım.
- Q43 BLINK test programının tek bir yerel kopyasını yaptım; 56Q71 kitine uyarladım (cihaz, LED pini, bir UART satırı), başlığın korundu. O kopya PC'mde kalıyor.
- Senin hiçbir şeyin hiçbir yerde yeniden paketlenmedi ya da paylaşılmadı.

FREELOADER için teşekkürler!
okmn

---

## 2) Yeni konu (forum)

**Başlık (EN):** `PIC18F56Q71 Curiosity Nano + Positron8: one-click compile, program and serial monitor from Proton IDE, Positron Studio or VS Code (no MPLAB X)`

**EN**

**Why:** before buying PIC18F56Q71 chips I wanted to develop on Microchip's Curiosity Nano kit (EV01G21A), straight from Positron8, without MPLAB X / IPE.

**What you get (free, CNanoKit):**
- **One key** compiles and programs the kit, then verifies and resets it:
  - Positron Studio: F10.
  - Proton IDE: plugin button.
  - VS Code + Positron extension: Ctrl+Alt+M (or the editor title buttons).
- It uses the kit's own on-board debugger through Microchip's free *pymcuprog*. It refuses to write if the kit's PIC differs from your `Device =` line.
- **CNano Monitor** (TR/EN): talk to your program over the kit's USB COM port.
  - Text/HEX view.
  - Text/HEX send.
  - Quick-send buttons.
  - Reset button.
- **No wires** on the kit. Your program just uses UART2 (RB4 = TX, RB5 = RX).
- Two examples: "Hello" and a command test (LED blink/PWM, data stream).

**Not included:** breakpoint debugging (use MPLAB X for that) and other kits (only the 18F56Q71 kit is tested).

**What your PC needs (tested versions):**
- Windows 10/11 64-bit (tested: Win11 Pro; Win11 Home and a PC without MPLAB X not tested yet)
- Positron8 compiler (tested 4.0.6.4) + ONE IDE: Positron Studio 2.1.0.4, Proton IDE 2.0.3.3, or VS Code + "Positron" extension by atomix (2.9.0)
- Python 3, 64-bit (tested 3.14.7) — "Add python.exe to PATH"
- Installed automatically by the setup (internet once): Microchip pymcuprog, Microchip PIC18F-Q device pack
- Kit + USB data cable (Micro-B). NOT needed: MPLAB X / IPE, wires, any bootloader.

**Download:** `<GitHub Release link>` — unzip to `C:\CNanoKit`, run `CNanoProg_Setup.bat`, then follow the TR/EN guide in `docs\`.

@Les — the Proton IDE buttons use the documented Plugin Manager interface. If you'd rather I change anything, just tell me.

Feedback welcome. No support promised, but I'll read every post.
okmn

**TR (sizin için)**

**Neden:** PIC18F56Q71 çip almadan önce Microchip'in Curiosity Nano kitiyle (EV01G21A), doğrudan Positron8'den ve MPLAB X / IPE olmadan geliştirme yapmak istedim.

**Ne var (ücretsiz, CNanoKit):**
- **Tek tuş** kiti derler, programlar, doğrular ve resetler:
  - Positron Studio: F10.
  - Proton IDE: eklenti düğmesi.
  - VS Code + Positron eklentisi: Ctrl+Alt+M (ya da editör başlığındaki düğmeler).
- Microchip'in ücretsiz *pymcuprog* aracıyla kitin kendi üzerindeki hata ayıklayıcıyı kullanır. Kitteki PIC, `Device =` satırınızdan farklıysa yazmayı reddeder.
- **CNano Monitor** (TR/EN): kitin USB COM portu üzerinden programınızla konuşur.
  - Metin/HEX görünüm.
  - Metin/HEX gönderme.
  - Hızlı gönder düğmeleri.
  - Reset düğmesi.
- Kitte **kablo yok.** Programınız yalnız UART2'yi kullanır (RB4 = TX, RB5 = RX).
- İki örnek: "Hello" ve bir komut testi (LED yakıp söndürme/PWM, veri akışı).

**Dahil olmayanlar:** breakpoint ile hata ayıklama (bunun için MPLAB X kullanın) ve başka kitler (yalnız 18F56Q71 kiti denendi).

**Bilgisayarda olması gerekenler (denenen sürümler):**
- Windows 10/11 64 bit (Win11 Pro'da denendi; Win11 Home ve MPLAB X'siz PC henüz denenmedi)
- Positron8 derleyici (4.0.6.4) + TEK bir IDE: Positron Studio 2.1.0.4, Proton IDE 2.0.3.3 ya da VS Code + atomix'in "Positron" eklentisi (2.9.0)
- Python 3, 64 bit (3.14.7) — "Add python.exe to PATH" işaretli
- Kurulumun kendisinin indirdikleri (bir kez internet): Microchip pymcuprog, Microchip PIC18F-Q cihaz paketi
- Kit + USB veri kablosu (Micro-B). GEREKMEYENLER: MPLAB X / IPE, kablo, bootloader.

**İndirme:** `<GitHub Release bağlantısı>` — `C:\CNanoKit` klasörüne açın, `CNanoProg_Setup.bat` dosyasını çalıştırın, sonra `docs\` içindeki TR/EN kılavuzu izleyin.

@Les — Proton IDE düğmeleri, belgelenmiş Plugin Manager arabirimini kullanıyor. Değiştirmemi istediğin bir şey olursa söylemen yeterli.

Geri bildirime açığım. Destek sözü vermiyorum, ama her mesajı okuyacağım.
okmn

---

## 3) GitHub

**Ne yayınlanır:** yalnız **Release** sekmesine bir zip (`CNanoKit_v0.6_….zip`) ve kısa bir README. `src\` klasörü yok; JonW'ye ait hiçbir dosya yok.

**Release notu (EN):**

```
CNanoKit 0.6 — PIC18F56Q71 Curiosity Nano + Positron8
One key compile + program + verify from Proton IDE, Positron Studio or VS Code.
CNano Monitor: text/HEX view and send, quick buttons. No MPLAB X, no wires.
Setup: unzip to C:\CNanoKit, run CNanoProg_Setup.bat, read docs\INSTALL_EN_*.md
Tested: Win11 Pro, Positron8 4.0.6.4, Python 3.14, pymcuprog 3.19.
Free to use, no warranty.
```
