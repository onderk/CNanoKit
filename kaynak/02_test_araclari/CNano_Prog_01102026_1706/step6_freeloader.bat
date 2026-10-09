@echo off
rem run AFTER the 2 jumpers are fitted: RC6 -> RB4 and RB5 -> RC7 (kit holds bootloader only)
set C=C:\Tarim\araclar\CNanoProg_01102026_1721\CNanoProg.exe
set FL=C:\FREELOADER Free PIC18 bootloader and uploader__by Jon Walker\Built in APP\FREELOADER.exe
set T=C:\Tarim\Q71_CNano_Test_01102026_1706
set L=%~dp0log\step6_freeloader.txt
echo === step6 %DATE% %TIME% > "%L%"
echo --- FREELOADER --info COM8 (blank app: bootloader waits, no reset needed) >> "%L%"
"%FL%" --info COM8 >> "%L%" 2>&1
echo exit=%ERRORLEVEL% >> "%L%"
echo --- upload UART app with verify, reset by the kit debugger >> "%L%"
"%C%" "%T%\P56Q71_CNANO_UART.hex" 18F56Q71 -Mode freeloader -Monitor 6 -NoPause >> "%L%" 2>&1
echo exit=%ERRORLEVEL% >> "%L%"
echo === end >> "%L%"
