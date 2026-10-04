# CNanoKit – PIC18F56Q71 Curiosity Nano + Positron8

Compile, program and talk to Microchip's **PIC18F56Q71 Curiosity Nano (EV01G21A)** with one key from **Positron Studio**, **Proton IDE** or **VS Code** – no MPLAB X, no programmer, no wires, no bootloader. CNanoKit uses the kit's own on-board debugger through Microchip's free *pymcuprog*.

**Web page:** https://onderk.github.io/CNanoKit/ · **Download:** [latest release](https://github.com/onderk/CNanoKit/releases/latest) → `CNanoKit_v1.1_*.zip`.

## What you get
- **One key** compiles, programs, verifies and resets the kit: Positron Studio **F10** · Proton IDE **Program (CNanoProg)** button · VS Code **Ctrl+Alt+M** (or Ctrl+Alt+C, then Ctrl+Alt+P).
- It refuses to write if the kit's PIC differs from your `Device =` line.
- **CNano Monitor** (EN/TR): Text/HEX view and send, quick buttons, Reset PIC, log file.
- Your program uses **UART2 (RB4 = TX, RB5 = RX)** – already wired inside the kit to its USB port.
- Three examples in `examples/`: HELLO, HELLO_NOLED, KOMUT.

## What your PC needs (tested)
Windows 10/11 64-bit · Positron8 4.0.6.4 · one IDE: Positron Studio 2.1.0.4 / Proton IDE 2.0.3.3 / VS Code 1.140 + "Positron" extension by atomix 2.9.0 · Python 3.14.7 64-bit ("Add python.exe to PATH") · internet once for the setup (installs Microchip pymcuprog and the PIC18F-Q device pack).

## Quick start
1. Download the release zip → right-click → Properties → **Unblock** → unzip to `C:\CNanoKit`.
2. Close your IDEs, run `CNanoProg_Setup.bat`.
3. Plug in the kit (USB **data** cable), open `examples\CNANO_HELLO_56Q71.bas`, compile + program, open the monitor.
Step by step: [docs/NEW_PC_SETUP_EN_02102026_1240.md](docs/NEW_PC_SETUP_EN_02102026_1240.md) · full guide: [docs/INSTALL_EN_01102026_2030.md](docs/INSTALL_EN_01102026_2030.md)

## Videos (English captions)
| | HELLO | HELLO_NOLED | KOMUT |
|---|---|---|---|
| Positron Studio | [▶](https://youtu.be/5oV3hNFtrQQ) | [▶](https://youtu.be/Fr_1ISsT9pI) | [▶](https://youtu.be/_-PZj2wlwPs) |
| Proton IDE | [▶](https://youtu.be/HoQPmnRP7GU) | [▶](https://youtu.be/7u8eBAA3DyQ) | [▶](https://youtu.be/cnKvcF5cFHo) |
| VS Code | [▶](https://youtu.be/9kIeRDDFuoc) | [▶](https://youtu.be/gBkqgx5eyXM) | [▶](https://youtu.be/dkm4jyVHdmw) |

CNano Monitor tour: [▶](https://youtu.be/-UH7H_6zfKo)

## JonW's mwboot bootloader on this kit
JonW's free FREELOADER/mwboot bootloader also runs on this kit (two wires, separate from CNanoKit). Notes: [docs/JonW_mwboot_on_Curiosity_Nano_EN_03102026_1910.md](docs/JonW_mwboot_on_Curiosity_Nano_EN_03102026_1910.md)

## Not included
Breakpoint debugging (use MPLAB X for that). Other kits are not tested.

## Türkçe
Türkçe kılavuzlar: [docs/YENI_PC_KURULUM_TR_02102026_1240.md](docs/YENI_PC_KURULUM_TR_02102026_1240.md) · [docs/KURULUM_TR_01102026_2030.md](docs/KURULUM_TR_01102026_2030.md)

---
Freeware: free to use, do not modify or redistribute modified versions (see LICENSE.txt). No warranty. Positron8, Positron Studio and Proton IDE are products of their authors; CNanoKit only adds settings and uses Proton IDE's documented Plugin Manager files. Feedback: protoncompiler.com forum (user okmn).
