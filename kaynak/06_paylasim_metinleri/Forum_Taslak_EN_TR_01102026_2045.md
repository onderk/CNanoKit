# Forum message draft — protoncompiler.com (one post, EN first, TR below)

Post it yourself, as **okmn**. Reply in JonW's FREELOADER thread. Before posting, put your GitHub link in the place marked `<link>`.

---

## EN

Hi Jon, hi all,

I tested **P56Q71_MWBOOT.hex** on a real **PIC18F56Q71 Curiosity Nano** (EV01G21A, nEDBG fw 1.27), Positron8 4.0.6.4, Windows 11 Pro.

**Bootloader: works.**
- I programmed the bootloader with the on-board debugger.
- Wiring: kit CDC lines to RC6/RC7 (RC6 → RB4, RB5 → RC7).
- Results:
  - Sync `U` → `B` within the 100 ms window.
  - `I` returned K and a correct INFO block: MWB 01 04 23, flash 0x10000, slot 0xFCF8, page 0x100, EEPROM 0x100 @ 0x380000, DEVID 0x7760, CRC ok.
  - 3 pages + EEPROM written, `X` → K, the app ran.
  - A read-back with the debugger was **byte-identical** to `FREELOADER --merge` output.
  - Re-entry after a debugger reset also worked.
- (Not tested: the `R` command. My frame got no reply, but my frame format may be wrong.)

**FREELOADER.exe 1.1 with this kit: does not connect.**
- The kit's USB-serial bridge (nEDBG CDC) passes data **only while DTR is asserted**. This is documented in Microchip DS50003481A §3.1.2.4.
- FREELOADER opens the port with DTR off. With no options, `--dtr`, `--rts` and `--dtr --rts`, it always waits at "Reset the board now…" and times out.
- With DTR held on, the same protocol works (see above).
- **Request:** could you add an option that keeps DTR asserted for the whole session (for example `--dtr-on`)? Then all Curiosity Nano kits can use FREELOADER through their own USB port, and the debugger can do the reset (no button needed).

**Side product: CNanoKit (free, MIT).**
- One-key **compile + program** of the Curiosity Nano from **Positron Studio (F10)**, **Proton IDE** (plugin buttons; Proton IDE's own Program button does not start external programmers on Win11 here), and **VS Code + Positron extension (Ctrl+Alt+P)**.
- A small **serial monitor** (CNano Monitor) for the kit's COM port, in TR/EN.
- No MPLAB X needed. It uses Microchip's pymcuprog, with drag-and-drop as a fallback.
- Your files are **not** included; the guide links to this thread.
- Download + guide (TR/EN): `<link>`

Thanks for FREELOADER, Jon.
okmn

---

## TR

Merhaba Jon, merhaba herkese,

**P56Q71_MWBOOT.hex** dosyasını gerçek bir **PIC18F56Q71 Curiosity Nano** üzerinde denedim (EV01G21A, nEDBG 1.27, Positron8 4.0.6.4, Windows 11 Pro).

**Önyükleyici: çalışıyor.**
- Senkron, INFO, 3 sayfa ve EEPROM yazma, çıkış ve yeniden giriş sorunsuz.
- Hata ayıklayıcıyla geri okunan içerik, `FREELOADER --merge` çıktısıyla **bayt bayt aynı**.
- (`R` komutunu doğrulayamadım.)

**FREELOADER.exe 1.1 bu kitle bağlanamıyor.**
- Kitin USB-seri köprüsü, **DTR açık olmadıkça** veri geçirmez (Microchip DS50003481A §3.1.2.4).
- FREELOADER portu DTR kapalı açıyor. DTR'yi açık tutan bir seçenek (örneğin `--dtr-on`) eklenirse sorun çözülür.

**Yan ürün: CNanoKit (ücretsiz, MIT).**
- Positron Studio (F10), Proton IDE (eklenti düğmeleri) ve VS Code (Ctrl+Alt+P) ile tek tuşla derle-programla.
- Türkçe/İngilizce seri monitör.
- MPLAB X gerekmez.
- İndirme ve kılavuz: `<link>`

okmn
