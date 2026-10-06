CNanoProg 0.3 - program a Microchip Curiosity Nano board straight from Positron
================================================================================
Positron Studio / VS Code (Positron extension by atomix) / command line.
No MPLAB X IDE or IPE window needed.  Free, MIT licence.  okmn, Oct 2026.

Tested on: PIC18F56Q71 Curiosity Nano (EV01G21A, nEDBG fw 1.27), Windows 11,
Positron Studio "Compile and Program" (F10) and VS Code Positron extension 2.9.0
"Program".  A full erase + write + verify of flash, config and EEPROM takes 2-4 s.
Should work with every PIC Curiosity Nano that pymcuprog supports (not tested).

WHAT IT DOES
  - finds the kit (its CURIOSITY drive) and checks the kit's PIC is the PIC your
    program was compiled for - if not, nothing is written
  - checks the hex file (record checksums, end record) before writing
  - programs with Microchip pymcuprog (erase, write, verify, reset), or, when
    pymcuprog is not installed, by drag-and-drop to the CURIOSITY drive
  - optional: a simple two-way serial terminal on the kit's virtual COM port
    (the "debug" view: print from your program, read it on the PC)
  - optional: upload through a serial bootloader (Jon Walker's FREELOADER) with
    the kit's debugger doing the reset, so no reset button or DTR wire is needed

FILES
  CNanoProg.exe        small launcher (IDEs want an .exe); starts CNanoProg.ps1
  CNanoProg.ps1        the programmer itself (Windows PowerShell 5.1, built in)
  CNanoProg_Setup.bat  one-time setup (also after a new Windows install)
  CNanoProg.c          source of the launcher (MinGW: i686-w64-mingw32-gcc -O2 -s)
  LICENSE.txt          MIT

SETUP (once)
  1. Put the folder somewhere without spaces, e.g. C:\CNanoProg
  2. Install Python from python.org (tick "Add python.exe to PATH")
  3. Close Positron Studio and VS Code, plug in the kit
  4. Double-click CNanoProg_Setup.bat (right-click > Run as administrator if it
     says it cannot write PositronStudio.ini). It installs pymcuprog, downloads
     the device pack from packs.download.microchip.com if missing, and adds the
     programmer to Positron Studio and VS Code.
  5. Check:  CNanoProg.exe -Mode info

IDE SETTINGS (the setup does this; by hand if you prefer)
  Positron Studio  Tools > Configure Programmers > green +
                   Executable: C:\CNanoProg\CNanoProg.exe
                   Parameters: $long-hex-filename$ $target-device$
                   (no quotes - the IDE adds them; quotes typed here can break
                   its settings file: "Programmers record error")
  VS Code          pos.main.programmer      C:\CNanoProg\CNanoProg.exe
                   pos.main.programmerArgs  "$hex-filename$" $target-device$ -NoPause
  Proton IDE       its Program button did not start ANY programmer on our test
                   PC (not even MicroCode Loader), so it is not supported yet.

COMMAND LINE
  CNanoProg.exe APP.hex 18F56Q71                  program (auto)
  CNanoProg.exe APP.hex 18F56Q71 -Mode dragdrop   no pymcuprog needed
  CNanoProg.exe -Mode monitor -Baud 115200 -Stamp terminal, Esc quits
  CNanoProg.exe -Mode reset | erase | info
  CNanoProg.exe -Mode read -Out BACKUP.hex
  CNanoProg.exe APP.hex 18F56Q71 -Mode freeloader serial bootloader upload

KIT FACTS (PIC18F56Q71 Curiosity Nano user guide DS50003481A)
  - virtual COM port = UART2: RB4 = PIC TX, RB5 = PIC RX. Use these pins for
    printing from your program; then no wires are needed.
  - the terminal must switch DTR on, or the kit passes no data (CNanoProg does).
  - DTR does NOT reset the PIC on this kit; CNanoProg resets it through the debugger.
  - LED0 = RC7 (active low), SW0 = RA0 (enable the weak pull-up).

DEBUGGING
  Positron produces no debug information an outside debugger can use, so there
  is no source-level stepping. CNanoProg gives the practical version: print
  values over UART2 and watch them with -Mode monitor.

No warranty. Not affiliated with Microchip.
