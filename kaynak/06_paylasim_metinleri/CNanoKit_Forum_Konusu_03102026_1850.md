# CNanoKit — forumda yeni konu (son hâli: 03.10.2026 18:50)

## Senin için (TR)
- **Nereye:** protoncompiler.com → uygun bölüm → **New Topic**. Başlığı ve **1. MESAJ** metnini kopyala.
- **Ek (attach):** `C:\Tarim\paylasim_01102026_1900\CNanoKit_v1.1_03102026_1845.zip` (126 KB, 16 dosya; isim taraması temiz).
- **Sonra 3 cevap mesajı** (2., 3., 4. MESAJ): Positron Studio, Proton IDE, VS Code videoları — her videonun altında açıklaması. 5. MESAJ: CNano Monitor videosu.
- Açıklamalar YouTube'dakilerle aynı. Yalnız **VS Code HELLO** videosunun YouTube açıklamasını buradaki ile değiştir (o video programlamayı da gösteriyor).
- İstersen YouTube başlıklarındaki "CNanoKit 2/3/5…" numaralarını kaldırabilirsin; 1 ve 4 numaralı videolar yüklenmediği için sıra atlıyor.

---

## TITLE
PIC18F56Q71 Curiosity Nano + Positron8: one-key compile, program and serial monitor from Positron Studio, Proton IDE or VS Code (no MPLAB X)

## 1. MESAJ (first post)

**Why:** before buying PIC18F56Q71 chips I wanted to develop on Microchip's Curiosity Nano kit (EV01G21A), straight from Positron8, without MPLAB X / IPE.

**What you get (free, CNanoKit):**
- **One key** compiles and programs the kit, then verifies and resets it:
  - Positron Studio: **F10**
  - Proton IDE: **Program (CNanoProg)** button
  - VS Code + Positron extension: **Ctrl+Alt+M** (or Ctrl+Alt+C, then Ctrl+Alt+P – Ctrl+Alt+P alone does not compile)
- It uses the kit's own on-board debugger through Microchip's free *pymcuprog*, and refuses to write if the kit's PIC differs from your `Device =` line.
- **CNano Monitor** (EN/TR): talk to your program over the kit's USB COM port – Text/HEX view, Text/HEX send, four quick buttons, Reset PIC button, log file.
- **No wires** on the kit: your program just uses UART2 (RB4 = TX, RB5 = RX), which the kit already connects to its USB port.
- Three examples: **HELLO** (text + LED), **HELLO_NOLED** (text only), **KOMUT** (the PIC obeys commands from the PC: LED ticks, PWM fade, data stream). Optional extra LED: RD0 → 1 kΩ → LED → GND.

**Not included:** breakpoint debugging (use MPLAB X for that); other kits (only the 18F56Q71 kit is tested).

**What your PC needs (tested versions):**
- Windows 10/11 64-bit (tested on Win11 Pro)
- Positron8 (tested 4.0.6.4) + ONE IDE: Positron Studio 2.1.0.4, Proton IDE 2.0.3.3, or VS Code 1.140 + "Positron" extension by atomix 2.9.0
- Python 3 64-bit (tested 3.14.7) – tick "Add python.exe to PATH"
- Installed once by the setup (internet needed): Microchip pymcuprog, Microchip PIC18F-Q device pack
- The kit + a USB **data** cable (Micro-B). NOT needed: MPLAB X / IPE, a programmer, wires, a bootloader.

**Download:** attached `CNanoKit_v1.1.zip`. Unzip to `C:\CNanoKit`, run `CNanoProg_Setup.bat`. New PC, step by step: `docs\NEW_PC_SETUP_EN_*.md`; full guide: `docs\INSTALL_EN_*.md` (Turkish versions included).

**Videos (English captions)** – posted below, grouped by IDE:
- Positron Studio: HELLO · HELLO_NOLED · KOMUT
- Proton IDE: HELLO · HELLO_NOLED · KOMUT
- VS Code: HELLO · HELLO_NOLED · KOMUT
- CNano Monitor tour

**Related:** JonW's free mwboot bootloader also runs on this kit (two wires; separate from CNanoKit) – 4 test videos:
https://youtu.be/DtCk0OLhyhg · https://youtu.be/RV5UpDS18VI · https://youtu.be/Hw0ExDGAQg8 · https://youtu.be/YuMxKAdu_NI
Details: https://protoncompiler.com/index.php/topic,3427.0.html

@Les — the Proton IDE buttons use the documented Plugin Manager interface; nothing inside Proton IDE is changed. If you'd rather I change anything, just tell me.

Feedback welcome. No support promised, but I'll read every post.
okmn

---

## 2. MESAJ — Positron Studio

**Positron Studio – HELLO: compile, program and monitor with one key (F10)**
https://youtu.be/5oV3hNFtrQQ
F10 (Compile and Program): Positron8 turns the .bas into a .hex, then CNanoProg writes it through the kit's own debugger – erase, write, verify, about 2 s. Tools → CNano Monitor → Connect: "Hello/Merhaba n" every 500 ms over UART2. The green LED on RD0 blinks; typed text is echoed back; SW0 prints "SW0".

**Positron Studio – HELLO_NOLED (text only, safe with any wiring)**
https://youtu.be/Fr_1ISsT9pI
The same program with all LED code removed – use it when you don't want any LED pin touched. F10, then Tools → CNano Monitor: only text lines, no LED activity. That is correct.

**Positron Studio – KOMUT: control the PIC from the PC**
https://youtu.be/_-PZj2wlwPs
KOMUT listens for commands from CNano Monitor: **okmn** → LED ticks ×4 + pause, repeating · **HEX 53** → soft PWM fade with a bar graph · **come** → "DATA n SW0=x" every 250 ms · **stop** → stops. Each command runs until stop or the next command; "help" lists them. The monitor also shows a "virtual LED" line.

## 3. MESAJ — Proton IDE

**Proton IDE – HELLO: Program and Monitor buttons**
https://youtu.be/HoQPmnRP7GU
"Program (CNanoProg)" compiles if needed, then programs and verifies the kit. "Monitor (CNanoMonitor)" opens the serial monitor → Connect. "Hello/Merhaba n" lines every 500 ms; the green RD0 LED blinks, and the kit's own LED0 joins in after the first key (no wire on RC7).

**Proton IDE – HELLO_NOLED**
https://youtu.be/7u8eBAA3DyQ
Program → Monitor → Connect: text lines every 500 ms, no LED activity (as expected). At the end SW0 is pressed and "SW0" appears.

**Proton IDE – KOMUT**
https://youtu.be/cnKvcF5cFHo
Program → Monitor → command list. okmn (LED ticks), HEX 53 (PWM fade + bar), come (DATA lines), stop. "Reset PIC" in the monitor restarts the program and shows the list again.

## 4. MESAJ — VS Code (Positron extension by atomix)

**VS Code – HELLO: compile, program and monitor**
https://youtu.be/9kIeRDDFuoc
Ctrl+Alt+M (or the "Compile and Program" button in the editor title bar) – the Output panel shows Positron8 compiling and CNanoProg writing and verifying the kit. Then **Ctrl+Alt+N** opens CNano Monitor (the setup adds it as a VS Code task) → Connect: "Hello/Merhaba n" every 500 ms, typed text is echoed, SW0 prints "SW0". If Ctrl+Alt+M does nothing on your keyboard: Ctrl+Alt+C, then Ctrl+Alt+P.

**VS Code – HELLO_NOLED**
https://youtu.be/gBkqgx5eyXM
Compile and program, Ctrl+Alt+N for the monitor: only text lines, no LED activity – exactly what this example is for.

**VS Code – KOMUT**
https://youtu.be/dkm4jyVHdmw
Compile and program, Ctrl+Alt+N, then okmn, HEX 53, come, stop. Tip: the quick buttons in CNano Monitor send them with one click.

## 5. MESAJ — CNano Monitor

**CNano Monitor tour: Text/HEX view, quick buttons, Reset**
https://youtu.be/-UH7H_6zfKo
Views: Text, HEX, or both; time stamps; log file. Send text (your choice of line end) or raw HEX bytes like `55 AA 0D 0A`. Four quick buttons – Shift+click to change what a button sends. "Reset PIC" restarts your program through the kit's debugger. English/Turkish. It connects only when you click Connect and keeps DTR on – the Curiosity Nano needs DTR on to pass any data.
