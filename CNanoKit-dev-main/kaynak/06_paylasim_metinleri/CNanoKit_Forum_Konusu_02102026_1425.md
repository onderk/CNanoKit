# CNanoKit — forumda yeni konu (02.10.2026 14:25)

**Nereye:** protoncompiler.com → uygun bölümde **New Topic**.
**Başlık ve metin:** aşağıdaki EN kısmı (TR sizin için).
**Ekler (attach):**
1. `C:\Tarim\paylasim_01102026_1900\CNanoKit_v1.0_02102026_1425.zip` (1.0 MB; içinde kurulum listeleri de var)
2. (İsteğe bağlı, metne de yapıştırılabilir) `C:\Tarim\CNanoKit_01102026_2005\docs\NEW_PC_SETUP_EN_02102026_1240.md`
Varsayım: forumun ek boyutu sınırı 1 MB'ı kaldırır; kaldırmazsa söyle, zip'i küçültürüz.


**Başlık (EN):** `PIC18F56Q71 Curiosity Nano + Positron8: one-click compile, program and serial monitor from Proton IDE, Positron Studio or VS Code (no MPLAB X)`

**EN**

**Why:** before buying PIC18F56Q71 chips I wanted to develop on Microchip's Curiosity Nano kit (EV01G21A), straight from Positron8, without MPLAB X / IPE.

**What you get (free, CNanoKit):**
- **One key** compiles and programs the kit, then verifies and resets it:
  - Positron Studio: F10.
  - Proton IDE: plugin button.
  - VS Code + Positron extension: Ctrl+Alt+M, or Ctrl+Alt+C then Ctrl+Alt+P (Ctrl+Alt+P alone does not compile).
- It uses the kit's own on-board debugger through Microchip's free *pymcuprog*. It refuses to write if the kit's PIC differs from your `Device =` line.
- **CNano Monitor** (TR/EN): talk to your program over the kit's USB COM port.
  - Text/HEX view.
  - Text/HEX send.
  - Quick-send buttons.
  - Reset button.
- **No wires** on the kit. Your program just uses UART2 (RB4 = TX, RB5 = RX).
- Three examples: "Hello", "Hello" without LED, and a command test (LED blink/PWM, data stream). Optional extra LED on RD0.

**Not included:** breakpoint debugging (use MPLAB X for that) and other kits (only the 18F56Q71 kit is tested).

**What your PC needs (tested versions):**
- Windows 10/11 64-bit (tested: Win11 Pro; Win11 Home and a PC without MPLAB X not tested yet)
- Positron8 compiler (tested 4.0.6.4) + ONE IDE: Positron Studio 2.1.0.4, Proton IDE 2.0.3.3, or VS Code + "Positron" extension by atomix (2.9.0)
- Python 3, 64-bit (tested 3.14.7) — "Add python.exe to PATH"
- Installed automatically by the setup (internet once): Microchip pymcuprog, Microchip PIC18F-Q device pack
- Kit + USB data cable (Micro-B). NOT needed: MPLAB X / IPE, wires, any bootloader.

**Download:** attached `CNanoKit_v1.0.zip`. Step-by-step setup for a new PC: `docs\NEW_PC_SETUP_EN_*.md` (Turkish: `docs\YENI_PC_KURULUM_TR_*.md`); full guide `docs\INSTALL_EN_*.md`.

@Les — the Proton IDE buttons use the documented Plugin Manager interface. If you'd rather I change anything, just tell me.

Feedback welcome. No support promised, but I'll read every post.
okmn

**TR (sizin için)**

**Neden:** PIC18F56Q71 çip almadan önce Microchip'in Curiosity Nano kitiyle (EV01G21A), doğrudan Positron8'den ve MPLAB X / IPE olmadan geliştirme yapmak istedim.

**Ne var (ücretsiz, CNanoKit):**
- **Tek tuş** kiti derler, programlar, doğrular ve resetler:
  - Positron Studio: F10.
  - Proton IDE: eklenti düğmesi.
  - VS Code + Positron eklentisi: Ctrl+Alt+M, ya da Ctrl+Alt+C sonra Ctrl+Alt+P (Ctrl+Alt+P tek başına derlemez).
- Microchip'in ücretsiz *pymcuprog* aracıyla kitin kendi üzerindeki hata ayıklayıcıyı kullanır. Kitteki PIC, `Device =` satırınızdan farklıysa yazmayı reddeder.
- **CNano Monitor** (TR/EN): kitin USB COM portu üzerinden programınızla konuşur.
  - Metin/HEX görünüm.
  - Metin/HEX gönderme.
  - Hızlı gönder düğmeleri.
  - Reset düğmesi.
- Kitte **kablo yok.** Programınız yalnız UART2'yi kullanır (RB4 = TX, RB5 = RX).
- Üç örnek: "Hello", LED'siz "Hello" ve bir komut testi (LED yakıp söndürme/PWM, veri akışı). İsteğe bağlı RD0 dış LED'i.

**Dahil olmayanlar:** breakpoint ile hata ayıklama (bunun için MPLAB X kullanın) ve başka kitler (yalnız 18F56Q71 kiti denendi).

**Bilgisayarda olması gerekenler (denenen sürümler):**
- Windows 10/11 64 bit (Win11 Pro'da denendi; Win11 Home ve MPLAB X'siz PC henüz denenmedi)
- Positron8 derleyici (4.0.6.4) + TEK bir IDE: Positron Studio 2.1.0.4, Proton IDE 2.0.3.3 ya da VS Code + atomix'in "Positron" eklentisi (2.9.0)
- Python 3, 64 bit (3.14.7) — "Add python.exe to PATH" işaretli
- Kurulumun kendisinin indirdikleri (bir kez internet): Microchip pymcuprog, Microchip PIC18F-Q cihaz paketi
- Kit + USB veri kablosu (Micro-B). GEREKMEYENLER: MPLAB X / IPE, kablo, bootloader.

**İndirme:** ekteki `CNanoKit_v1.0.zip`. Yeni PC için adım adım kurulum: `docs\YENI_PC_KURULUM_TR_*.md` (İngilizce: `docs\NEW_PC_SETUP_EN_*.md`); tam kılavuz `docs\KURULUM_TR_*.md`.

@Les — Proton IDE düğmeleri, belgelenmiş Plugin Manager arabirimini kullanıyor. Değiştirmemi istediğin bir şey olursa söylemen yeterli.

Geri bildirime açığım. Destek sözü vermiyorum, ama her mesajı okuyacağım.
okmn

---

