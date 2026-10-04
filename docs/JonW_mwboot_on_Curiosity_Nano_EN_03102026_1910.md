# JonW's mwboot bootloader on the PIC18F56Q71 Curiosity Nano – usage notes

**Get the bootloader and FREELOADER only from JonW's forum topic:** https://protoncompiler.com/index.php/topic,3427.0.html – none of his files are included here (his licence: modified versions may not be distributed).

## Status (3 Oct 2026)
- `P56Q71_MWBOOT.hex` (from JonW) works on a real PIC18F56Q71: sync, INFO, page + EEPROM write, verify, exit, re-entry after reset, and full 64 KB read-back with R.
- **FREELOADER.exe 1.1 cannot connect through this kit's USB port yet:** it releases DTR when it opens the port, and the Curiosity Nano's USB-serial passes data only while DTR is on (Microchip DS50003481A, 3.1.2.4). JonW has said he will add an option to keep DTR on.

## Wiring (USB unplugged while wiring)
mwboot uses UART1 on RC6/RC7; the kit's USB-serial is on RB4/RB5.
- Wire 1: **RC6 → RB4**
- Wire 2: **RB5 → RC7**
RC7 is also LED0. With wire 2 fitted, your application must **never drive RC7** (it would fight the kit's USB-serial line). Use another pin for an LED, e.g. RD0 → 1 kΩ → LED → GND.

## Putting the bootloader into the chip
Program `P56Q71_MWBOOT.hex` once with CNanoKit (or any programmer). Note: programming the kit the normal way (F10 / Ctrl+Alt+M / debugger) erases the whole chip, **bootloader included** – program it again to get it back.

## Uploading an application
When the FREELOADER version with the DTR option is out, follow JonW's FREELOADER help (upload, `--verify`, `--info`, `--read`). Your application must end below 0xFCF8 (the bootloader reserves the top 776 bytes).

## Videos
Upload through the bootloader [▶](https://youtu.be/DtCk0OLhyhg) · read-back with R [▶](https://youtu.be/RV5UpDS18VI) · FREELOADER 1.1 and DTR [▶](https://youtu.be/Hw0ExDGAQg8) · the test app on its own [▶](https://youtu.be/YuMxKAdu_NI)
