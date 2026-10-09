# Builds English SRT files and burns them into the raw videos (okmn video set).
import os, subprocess, sys
ROOT = os.path.expanduser('~/mnt/Videolar_02102026_1715')
SRC = os.path.join(ROOT, '1_ham_videolar')
OUT = os.path.join(ROOT, '2_altyazili_cikti')
TAG = '02102026_1930'
I = 'CNanoKit: PIC18F56Q71 Curiosity Nano + Positron8 - compile, program and monitor from {ide}.\nNo MPLAB X, no bootloader, no wires needed.'
V = [
 ('1_TEST_B_bootloader_yukle_02102026_1640.bat.mp4', 'JonW1_mwboot_upload', [
  (0, 2.5, "JonW's mwboot bootloader on a PIC18F56Q71 Curiosity Nano.\nTwo wires: RC6->RB4, RB5->RC7. Extra green LED on RD0."),
  (2.5, 6, "Step 1: the kit's own debugger writes ONLY the bootloader\n(P56Q71_MWBOOT.hex, 776 bytes at the top of flash)."),
  (6, 9, "No application yet -> the bootloader just waits.\nThe green LED stays off."),
  (9, 12, "Step 2: the test app is uploaded THROUGH the bootloader,\nover the kit's USB-serial (115200 baud, DTR held on)."),
  (12, 15, "Sync U->B, every 256-byte page written + verified (K),\nEEPROM too, exit X->K. Whole upload: 0.36 s."),
  (15, 20, "The bootloader starts the app:\ngreen LED fast blink, fade, then double flash."),
  (20, 22.1, "Bootloader -> application works on real Q71 silicon.")]),
 ('2_TEST_R_okuma_02102026_1640.bat.mp4', 'JonW2_mwboot_read_back', [
  (0, 2, "Read-back test of JonW's bootloader (R command)."),
  (2, 5, "The PC resets the PIC via the kit's debugger and catches\nthe bootloader in its 100 ms window: U -> B."),
  (5, 8, "INFO: \"MWB\", features 0x23 (read + EEPROM, lite),\n64 KB flash, slot 0xFCF8, DEVID 0x7760."),
  (8, 14, "All 64 KB read with R (about 6 s): byte-for-byte equal\nto the expected image. EEPROM: 11 22 33 \"HELLO\"."),
  (14, 17, "Bad frames handled: wrong CRC -> C, unknown command -> ?\nThe next frame always works."),
  (17, 20, "X -> the app restarts (green LED).\nSame 64 KB read by the kit's debugger: identical."),
  (20, 24.6, "RESULT: ALL PASS.")]),
 ('3_FREELOADER_kanit_02102026_1640.bat.mp4', 'JonW3_FREELOADER_DTR', [
  (0, 3, "Now JonW's own uploader, FREELOADER.exe 1.1, on the same kit\n(bootloader + app already inside)."),
  (3, 12, "FREELOADER --info COM8  ->  \"Reset the board now ...\""),
  (12, 25, "FREELOADER releases DTR when it opens the port\n(it only pulses DTR/RTS to reset a board)."),
  (25, 38, "The Curiosity Nano's USB-serial passes data ONLY while DTR is on\n(Microchip DS50003481A, 3.1.2.4)."),
  (38, 48, "So nothing reaches the PIC, and nothing comes back ..."),
  (48, 56, "\"no bootloader answered in 30 s (bytes seen: none)\""),
  (56, 60.7, "The bootloader itself is fine (videos 1-2).\nJonW will add an option to hold DTR on. Thanks, Jon!")]),
 ('P56Q71_CNANO_RD0_02102026_0525.bas.mp4', 'JonW4_test_app_without_bootloader', [
  (0, 6, "The test app used in videos 1-2: JonW's Q43 BLINK,\nadapted to the 56Q71 kit (local copy, his header kept)."),
  (6, 12, "Here it is built in Proton IDE (Positron8) and written\nstraight by the kit's debugger - no bootloader."),
  (12, 24, "It uses UART1 on RC6/RC7 like mwboot, so its text reaches\nthe PC through the RC6->RB4 wire."),
  (24, 40, "CNano Monitor: \"UART 56Q71 n\" about every second.\nGreen LED on RD0: fast blink, fade, double flash."),
  (40, 60, "RC7 is never driven: with the RB5->RC7 wire fitted\nit belongs to the kit's USB-serial line."),
  (60, 81.1, "Same app, same wires - only the way it gets into the chip differs\n(debugger here, bootloader in video 1).")]),
 ('CNANO_HELLO_56Q71.bas_positron_studio.mp4', 'CNanoKit0_open_in_Positron_Studio', [
  (0, 6.5, "CNanoKit examples: HELLO, HELLO_NOLED, KOMUT."),
  (6.5, 12.9, "Open the example in Positron Studio\n(right-click -> Open with).")]),
 ('CNANO_HELLO_56Q71.bas_positron_studio_ide.mp4', 'CNanoKit1_HELLO_Positron_Studio', [
  (0, 6, I.format(ide='Positron Studio')),
  (6, 12, "Compile -> Compile and Program (F10).\nPositron8 compiles CNANO_HELLO_56Q71.bas."),
  (12, 22, "Programmer \"Curiosity Nano (CNanoProg)\": the kit's own debugger\n(Microchip pymcuprog) - erase, write, verify."),
  (22, 30, "Programmed and verified in about 2 s. The PIC runs."),
  (30, 38, "Tools -> CNano Monitor -> Connect\n(the kit's USB COM port, DTR on)."),
  (38, 52, "HELLO sends \"Hello/Merhaba n\" every 500 ms over UART2 (RB4/RB5)\n- the kit's own USB-serial, no wires."),
  (52, 74.6, "Green LED on RD0 blinks. Type anything - the PIC echoes it.\nPress SW0 -> \"SW0\".")]),
 ('CNANO_HELLO_56Q71.bas_proton_ide.mp4', 'CNanoKit2_HELLO_Proton_IDE', [
  (0, 4, I.format(ide='Proton IDE')),
  (4, 8, "Toolbar button \"Program (CNanoProg)\":\ncompiles if needed, then programs the kit."),
  (8, 14, "CNanoProg: kit found, device checked against \"Device =\",\nerase + write + verify through the kit's debugger."),
  (14, 20, "Button \"Monitor (CNanoMonitor)\" opens the serial monitor."),
  (20, 33, "Connect: \"Hello/Merhaba n\" every 500 ms."),
  (33, 66.5, "Green LED on RD0 blinks. LED0 joins in after the first key\nwhen no FREELOADER wire is on RC7.")]),
 ('CNANO_HELLO_56Q71.bas_vscode_ide...mp4', 'CNanoKit3a_HELLO_VS_Code_program', [
  (0, 6, I.format(ide='VS Code')),
  (6, 14, "Positron extension (atomix): \"Compile and Program\" (Ctrl+Alt+M),\nor Ctrl+Alt+C then Ctrl+Alt+P."),
  (14, 28, "Output panel: Positron8 compiles,\nCNanoProg programs and verifies the kit."),
  (28, 44, "The PIC runs HELLO: the green RD0 LED blinks every 500 ms."),
  (44, 51.9, "Next: Ctrl+Alt+N opens CNano Monitor.")]),
 ('CNANO_HELLO_56Q71.bas_vscode_ide.mp4', 'CNanoKit3b_HELLO_VS_Code_monitor', [
  (0, 6, I.format(ide='VS Code')),
  (6, 12, "\"Compile and Program\" (Ctrl+Alt+M) from the editor title bar."),
  (12, 24, "Output: compile OK -> CNanoProg writes and verifies the kit (about 2 s)."),
  (24, 33, "Ctrl+Alt+N opens CNano Monitor (a VS Code task)."),
  (33, 50, "Connect: \"Hello/Merhaba n\" every 500 ms; the green LED blinks."),
  (50, 67.3, "Press SW0 on the kit -> \"SW0\". Typed text is echoed back.")]),
 ('CNANO_HELLO_56Q71_NOLED.bas_positron_studio_ide...mp4', 'CNanoKit4_NOLED_Positron_Studio', [
  (0, 6, "HELLO_NOLED: the same program without any LED code\n- safe with any wiring. Positron Studio."),
  (6, 20, "Compile and Program (F10): compile success, then CNanoProg."),
  (20, 28, "Programmed and verified."),
  (28, 36, "Tools -> CNano Monitor."),
  (36, 63, "Text only: \"Hello/Merhaba n\" lines. No LED is touched.")]),
 ('CNANO_HELLO_56Q71_NOLED.bas_proton_ide.mp4', 'CNanoKit5_NOLED_Proton_IDE', [
  (0, 5, "HELLO_NOLED in Proton IDE (no LED code)."),
  (5, 12, "\"Program (CNanoProg)\": erase, write, verify."),
  (12, 17, "\"Monitor (CNanoMonitor)\" -> Connect."),
  (17, 47, "\"Hello/Merhaba n\" lines every 500 ms. No LED activity - as expected."),
  (47, 58.5, "Pressing SW0 on the kit -> \"SW0\" in the monitor.")]),
 ('CNANO_HELLO_56Q71_NOLED.bas_vscode_ide.mp4', 'CNanoKit6_NOLED_VS_Code', [
  (0, 6, "HELLO_NOLED in VS Code (no LED code)."),
  (6, 24, "Compile + program: Positron8, then CNanoProg through the kit's debugger."),
  (24, 33, "Ctrl+Alt+N -> CNano Monitor -> Connect."),
  (33, 60, "\"Hello/Merhaba n\" lines, no LED activity - as expected.")]),
 ('CNANO_KOMUT_56Q71.bas_positron_studio_ide.mp4', 'CNanoKit7_KOMUT_Positron_Studio', [
  (0, 6, "KOMUT: the PIC obeys commands sent from CNano Monitor.\nPositron Studio."),
  (6, 18, "Compile and Program (F10)."),
  (18, 30, "CNanoProg: erase, write, verify through the kit's debugger."),
  (30, 40, "Monitor -> Connect: the PIC prints its command list, then waits."),
  (40, 60, "okmn -> LED ticks x4 + pause, repeating.\nThe monitor shows \"LED (#) ON / ( ) off\" lines."),
  (60, 80, "HEX 53 -> soft PWM fade on the LED,\nwith a bar graph in the monitor."),
  (80, 100, "come -> \"DATA n SW0=x\" every 250 ms."),
  (100, 122.3, "stop -> stops. Every command runs until stop or the next command.")]),
 ('CNANO_KOMUT_56Q71.bas_proton_ide.mp4', 'CNanoKit8_KOMUT_Proton_IDE', [
  (0, 4, "KOMUT in Proton IDE: commands from the monitor."),
  (4, 12, "\"Program (CNanoProg)\" -> programmed and verified."),
  (12, 18, "\"Monitor (CNanoMonitor)\" -> Connect -> command list."),
  (18, 30, "okmn -> LED ticks, \"LED (#) ON\" lines."),
  (30, 42, "HEX 53 -> PWM fade, bar graph."),
  (42, 56, "come -> DATA lines every 250 ms."),
  (56, 73.9, "stop -> waits. Reset PIC -> the list again.")]),
 ('CNANO_KOMUT_56Q71.bas_vscode_ide..mp4', 'CNanoKit9_KOMUT_VS_Code', [
  (0, 6, "KOMUT in VS Code: commands from the monitor."),
  (6, 22, "Compile and Program: Positron8 + CNanoProg (output panel)."),
  (22, 36, "Ctrl+Alt+N -> CNano Monitor -> Connect -> command list."),
  (36, 55, "okmn -> LED ticks x4 + pause, repeating."),
  (55, 70, "HEX 53 -> PWM fade, bar graph."),
  (70, 85, "come -> \"DATA n SW0=x\" every 250 ms."),
  (85, 103, "stop -> waits. Reset PIC -> the command list again.")]),
 ('cnano_monitor.mp4', 'CNanoKit10_CNano_Monitor', [
  (0, 6, "CNano Monitor: Text / HEX / Text+HEX views, time stamps, log file."),
  (6, 12, "Quick buttons okmn, HEX:53, come, stop (Shift+click to edit).\nSend text or HEX bytes."),
  (12, 18.7, "Reset PIC button (through the kit's debugger). TR / EN.")]),
]
def ts(t):
    ms = int(round(t * 1000)); h, ms = divmod(ms, 3600000); m, ms = divmod(ms, 60000); s, ms = divmod(ms, 1000)
    return '%02d:%02d:%02d,%03d' % (h, m, s, ms)
only = sys.argv[1:]
for src, name, caps in V:
    if only and name not in only: continue
    srt = os.path.join(OUT, '%s_EN_%s.srt' % (name, TAG))
    with open(srt, 'w', encoding='utf-8', newline='\r\n') as f:
        for i, (a, b, t) in enumerate(caps, 1):
            f.write('%d\n%s --> %s\n%s\n\n' % (i, ts(a), ts(b - 0.05), t))
    mp4 = os.path.join(OUT, '%s_EN_%s.mp4' % (name, TAG))
    pass
    esc = srt.replace('\\', '/').replace(':', '\\:').replace("'", "\\'")
    vf = "subtitles='%s':force_style='FontName=Lato,FontSize=13,PrimaryColour=&H00FFFFFF,BackColour=&H99000000,BorderStyle=3,Outline=1,Shadow=0,MarginV=12,Alignment=2'" % esc
    r = subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', os.path.join(SRC, src), '-vf', vf,
                        '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '21', '-c:a', 'copy', '-movflags', '+faststart', mp4])
    print(name, 'OK' if r.returncode == 0 else 'FAIL %d' % r.returncode, flush=True)
