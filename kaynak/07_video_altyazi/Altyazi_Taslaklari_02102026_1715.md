# Video altyazı taslakları (EN) — süreler videoyu görünce ekranda olan olaya göre ayarlanacak

## Video 1 — 1_TEST_B (bootloader + upload)
1. PIC18F56Q71 Curiosity Nano + JonW's mwboot (P56Q71_MWBOOT). Two wires: RC6→RB4, RB5→RC7. Extra LED on RD0.
2. Step 1: the kit's own debugger writes ONLY the bootloader (776 bytes at the top of flash).
3. No application yet → the bootloader just waits. RD0 and LED0 stay dark.
4. Step 2: the app is uploaded THROUGH the bootloader over the kit's USB serial (115200, DTR held on).
5. Sync: PC sends "U", bootloader answers "B".
6. Each 256-byte page written and read back by the bootloader → "K" = OK. EEPROM too.
7. "X" → bootloader exits and jumps to the app. Upload time: 0.36 s.
8. The app runs: RD0 fast blink 3 s, fade 3 s, then double flash.
9. Monitor: "UART 56Q71 n" lines come from the app, started by the bootloader.

## Video 2 — 2_TEST_R (read-back proof)
1. Read test: the PC resets the PIC and catches the bootloader in its 100 ms window.
2. INFO: "MWB", features 0x23 (Read + EEPROM, lite), flash 64 KB, slot 0xFCF8, DEVID 0x7760.
3. All 64 KB read with the bootloader's R command — byte-for-byte equal to the expected image.
4. EEPROM read back: 11 22 33 "HELLO".
5. Bad frames are handled: wrong CRC → C, unknown command → ?. The next frame still works.
6. Note: R with LEN ≠ 0 gets no reply on this build (doc says L) — harmless.
7. Cross-check: same 64 KB read by the kit's debugger — identical. ALL PASS.

## Video 3 — 3_FREELOADER (the one open issue)
1. Now JonW's own uploader, FREELOADER.exe 1.1, on the same kit.
2. FREELOADER opens the port with DTR off (it only pulses DTR/RTS for a reset).
3. The Curiosity Nano's USB serial passes data ONLY while DTR is on (Microchip DS50003481A §3.1.2.4).
4. So nothing reaches the PIC: "no bootloader answered in 30 s (bytes seen: none)".
5. The bootloader is fine (videos 1–2). Only a "keep DTR on" option is missing in FREELOADER.

## Videolar 4–6 — CNanoKit (bootloader yok, kablo yok): Positron Studio / Proton IDE / VS Code
Her biri için: dosyayı aç → derle + programla (kitin kendi debugger'ı, pymcuprog) → monitör aç → komutlar (okmn, 53, come, stop) → LED'ler. Metinler videoyu görünce yazılacak.
