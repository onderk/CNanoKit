# YouTube — playlist "JonW Bootloader PIC18F56Q71 CNano (EV01G21A)"

## Playlist description
JonW's free mwboot bootloader (FREELOADER project, protoncompiler.com forum) tested on a real PIC18F56Q71 Curiosity Nano (EV01G21A). Four short videos: upload through the bootloader, read-back proof, the one open issue (DTR), and the test app on its own. English captions.
Forum topic: https://protoncompiler.com/index.php/topic,3427.0.html

---

## 1) Title
JonW mwboot on PIC18F56Q71 Curiosity Nano – Part 1: Upload an App Through the Bootloader

### Description
A bootloader is a tiny program that lives at the top of the chip's memory. Its job: receive a new program over a serial cable and write it into the chip, so you don't need a programmer every time.

What you see:
1. The kit's own debugger writes ONLY JonW's bootloader (776 bytes). No app yet, so the bootloader just waits – the green LED stays off.
2. Our test app is sent THROUGH the bootloader over the kit's USB-serial port (115200 baud).
3. The PC says "U", the bootloader answers "B" (we are connected). Each 256-byte page is written and checked – "K" means OK. EEPROM too. Then "X": the bootloader jumps to the app.
4. The whole upload takes 0.36 s. The app starts: green LED blinks fast, fades, then double-flashes.

Setup: PIC18F56Q71 Curiosity Nano (EV01G21A), two wires (RC6→RB4, RB5→RC7) because mwboot uses UART1 and the kit's USB-serial is on UART2 pins, extra LED on RD0, Positron8.
Bootloader: JonW (protoncompiler.com, FREELOADER topic) – used unmodified.

---

## 2) Title
JonW mwboot on PIC18F56Q71 Curiosity Nano – Part 2: Reading the Whole Chip Back (R Command)

### Description
Writing is only half the story – can we trust what was written? This video reads the chip back through the bootloader and compares every byte.

What you see:
1. The PC resets the PIC and catches the bootloader in its 100 ms "listening window".
2. INFO: the bootloader introduces itself – "MWB", features 0x23 (read + EEPROM), 64 KB flash, device ID 0x7760 (PIC18F56Q71).
3. All 64 KB are read with the R command (about 6 s) and match the expected image byte for byte. EEPROM reads back 11 22 33 "HELLO".
4. We also send wrong frames on purpose (bad checksum, unknown command): the bootloader rejects them politely and keeps working.
5. Finally the same 64 KB are read a second way, by the kit's debugger – identical. Result: ALL PASS.

Why it matters: two independent read-backs agree, so the bootloader writes exactly what it is given.

---

## 3) Title
JonW mwboot on PIC18F56Q71 Curiosity Nano – Part 3: Why FREELOADER 1.1 Can't Connect Yet (DTR)

### Description
FREELOADER.exe is JonW's PC program for talking to his bootloader. Here we run it on the same kit – and it times out. The bootloader is not the problem (see Parts 1 and 2). The reason is one signal line: DTR.

Simple version:
- The Curiosity Nano's USB-serial only passes data while the PC keeps DTR switched ON (Microchip kit guide DS50003481A, 3.1.2.4).
- FREELOADER 1.1 switches DTR OFF when it opens the port (it only "pulses" DTR to reset other boards).
- So nothing reaches the PIC and nothing comes back: "no bootloader answered in 30 s (bytes seen: none)".

Good news: JonW has said he will add an option to keep DTR on for the whole session. When it is out, this test will be repeated.

---

## 4) Title
JonW mwboot on PIC18F56Q71 Curiosity Nano – Part 4: The Test App on Its Own (No Bootloader)

### Description
This is the small test app used in Parts 1 and 2 – JonW's Q43 BLINK example, adapted to the 56Q71 kit (local test copy, his licence header kept, not distributed).

What you see:
1. The app is compiled with Positron8 in Proton IDE and written straight into the chip by the kit's own debugger – no bootloader this time.
2. It sends "UART 56Q71 n" about once a second on UART1 (pin RC6), which reaches the PC through the RC6→RB4 wire. CNano Monitor shows the lines.
3. The green LED on RD0: fast blink, fade, then double flash.
4. Pin RC7 is never driven by the program: with the RB5→RC7 wire fitted it belongs to the kit's USB-serial line, so driving it could fight the debugger.

Same app, same wires – only the way it gets into the chip is different (debugger here, bootloader in Part 1).
