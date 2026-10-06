# YouTube — CNanoKit videoları (herkes için) — 02.10.2026 20:30

Önerilen oynatma listesi adı: **CNanoKit – PIC18F56Q71 Curiosity Nano + Positron8 (no MPLAB X)**
Önerilen sıra: 1 → 12 (aşağıdaki gibi). Her başlığın altındaki açıklama hem YouTube'a hem forumda videonun altına aynen konur.
Dosyalar: C:\Videolar_02102026_1715\2_altyazili_cikti\

## Playlist description
CNanoKit is a free helper for Positron8 users: compile, program and talk to Microchip's PIC18F56Q71 Curiosity Nano (EV01G21A) with one key from Positron Studio, Proton IDE or VS Code – no MPLAB X, no wires, no bootloader. It uses the kit's own on-board debugger. Short videos with English captions.

---

## 1) CNanoKit0_open_in_Positron_Studio_EN_02102026_1930.mp4
**Title:** CNanoKit 1 – PIC18F56Q71 Curiosity Nano + Positron8: Opening the Examples
**Description:**
CNanoKit comes with three small example programs for the PIC18F56Q71 Curiosity Nano:
- HELLO – prints a message every half second and blinks an LED,
- HELLO_NOLED – the same without any LED code,
- KOMUT – obeys commands you type on the PC.
Here we simply open one in Positron Studio (right-click the .bas file → Open with). The next videos compile it, program the kit and watch it run.

---

## 2) CNanoKit1_HELLO_Positron_Studio_EN_02102026_1930.mp4
**Title:** CNanoKit 2 – HELLO in Positron Studio: Compile, Program and Monitor with One Key (F10)
**Description:**
Your first program on the kit, the easy way.
1. Press F10 (Compile and Program). Positron8 turns the .bas file into a .hex file.
2. CNanoProg sends the .hex to the kit through the kit's own debugger (Microchip's free pymcuprog): erase, write, verify – about 2 seconds. It first checks that the chip on the kit matches your "Device =" line.
3. Tools → CNano Monitor → Connect. The PIC says "Hello/Merhaba n" every 500 ms over UART2 (pins RB4/RB5), which is wired inside the kit to its USB port – so no extra wires.
4. The green LED on RD0 blinks. Type something: the PIC sends it back. Press the kit's SW0 button: "SW0" appears.
Needed: Positron8, Python 3, CNanoKit (free). Not needed: MPLAB X, a programmer, wires.

---

## 3) CNanoKit2_HELLO_Proton_IDE_EN_02102026_1930.mp4
**Title:** CNanoKit 3 – HELLO in Proton IDE: Program and Monitor Buttons
**Description:**
The same HELLO program, this time from Proton IDE.
1. Toolbar button "Program (CNanoProg)": compiles if needed, then programs and verifies the kit.
2. Toolbar button "Monitor (CNanoMonitor)": opens the serial monitor. Click Connect.
3. "Hello/Merhaba n" lines arrive every 500 ms. The green LED on RD0 blinks; after the first key you type, the kit's own yellow LED0 joins in.
The buttons are added by the CNanoKit setup through Proton IDE's normal Plugin Manager files – nothing inside Proton IDE is changed.

---

## 4) CNanoKit3a_HELLO_VS_Code_program_EN_02102026_1930.mp4
**Title:** CNanoKit 4 – HELLO in VS Code: Compile and Program (Positron extension)
**Description:**
VS Code with the free "Positron" extension by atomix.
- Ctrl+Alt+M = compile and program (or the button in the editor's title bar).
- If Ctrl+Alt+M does nothing on your keyboard: Ctrl+Alt+C (compile), then Ctrl+Alt+P (program). Note: Ctrl+Alt+P alone does NOT compile – it writes the last .hex.
The Output panel shows Positron8 compiling and CNanoProg programming and verifying the kit. Then the green LED on RD0 starts blinking: HELLO is running.

---

## 5) CNanoKit3b_HELLO_VS_Code_monitor_EN_02102026_1930.mp4
**Title:** CNanoKit 5 – HELLO in VS Code: Open the Monitor with Ctrl+Alt+N
**Description:**
After programming, press Ctrl+Alt+N: CNano Monitor opens (the setup adds it as a VS Code task). Click Connect.
- "Hello/Merhaba n" arrives every 500 ms.
- Type text: the PIC echoes it back.
- Press SW0 on the kit: "SW0" appears.
- The green LED on RD0 keeps blinking.

---

## 6) CNanoKit4_NOLED_Positron_Studio_EN_02102026_1930.mp4
**Title:** CNanoKit 6 – HELLO_NOLED in Positron Studio (text only, safe with any wiring)
**Description:**
HELLO_NOLED is HELLO with all LED code removed. Use it when you don't want the program to touch any LED pin – for example when other wires are fitted to the kit.
F10 compiles and programs; Tools → CNano Monitor shows the "Hello/Merhaba n" lines. No LED lights up – that is correct.

---

## 7) CNanoKit5_NOLED_Proton_IDE_EN_02102026_1930.mp4
**Title:** CNanoKit 7 – HELLO_NOLED in Proton IDE
**Description:**
"Program (CNanoProg)" → programmed and verified. "Monitor (CNanoMonitor)" → Connect.
Text lines every 500 ms, no LED activity (as expected). At the end SW0 is pressed and "SW0" appears in the monitor.

---

## 8) CNanoKit6_NOLED_VS_Code_EN_02102026_1930.mp4
**Title:** CNanoKit 8 – HELLO_NOLED in VS Code
**Description:**
Compile and program from VS Code (Ctrl+Alt+M, or Ctrl+Alt+C then Ctrl+Alt+P), then Ctrl+Alt+N for the monitor.
Only text lines, no LED activity – exactly what this example is for.

---

## 9) CNanoKit7_KOMUT_Positron_Studio_EN_02102026_1930.mp4
**Title:** CNanoKit 9 – KOMUT in Positron Studio: Control the PIC from the PC
**Description:**
KOMUT ("command" in Turkish) listens for words you send from CNano Monitor:
- okmn → the LED ticks 4 times, pauses, and repeats,
- HEX 53 (one byte, 0x53) → the LED fades up and down (software PWM); the monitor draws a bar,
- come → the PIC sends "DATA n SW0=x" every 250 ms,
- stop → everything stops.
Each command keeps running until "stop" or the next command. "help" lists them. The monitor also shows a "virtual LED" line, so you can follow the LED even without looking at the board.

---

## 10) CNanoKit8_KOMUT_Proton_IDE_EN_02102026_1930.mp4
**Title:** CNanoKit 10 – KOMUT in Proton IDE
**Description:**
The same command test from Proton IDE: Program button → Monitor button → Connect → command list.
okmn (LED ticks), HEX 53 (PWM fade + bar), come (DATA lines), stop. "Reset PIC" in the monitor restarts the program and shows the list again.

---

## 11) CNanoKit9_KOMUT_VS_Code_EN_02102026_1930.mp4
**Title:** CNanoKit 11 – KOMUT in VS Code
**Description:**
Compile and program in VS Code, Ctrl+Alt+N for the monitor, then the four commands: okmn, HEX 53, come, stop.
Tip: the quick buttons in CNano Monitor (okmn, HEX:53, come, stop) send them with one click.

---

## 12) CNanoKit10_CNano_Monitor_EN_02102026_1930.mp4
**Title:** CNanoKit 12 – CNano Monitor: Text/HEX View, Quick Buttons, Reset
**Description:**
A quick tour of CNano Monitor, the small serial terminal in CNanoKit:
- View: Text, HEX, or Text+HEX side by side; time stamps; a log file.
- Send: text (with your choice of line end) or raw HEX bytes like 55 AA 0D 0A.
- Four quick buttons – Shift+click to change what a button sends.
- "Reset PIC" restarts your program through the kit's debugger.
- Turkish / English.
It connects only when you click Connect, and keeps DTR on – the Curiosity Nano needs DTR on to pass any data.
