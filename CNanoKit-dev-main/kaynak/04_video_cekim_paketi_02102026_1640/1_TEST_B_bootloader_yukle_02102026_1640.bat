@echo off
setlocal
cd /d "%~dp0"
set PROG=%~dp0CNanoKit_02102026_1640\CNanoProg.exe
set PORT=COM8
echo.
echo ===== STEP 1: write ONLY JonW's bootloader (P56Q71_MWBOOT.hex) =====
"%PROG%" "%~dp0P56Q71_MWBOOT.hex" 18F56Q71 -NoPause
if errorlevel 1 ( echo ERROR: bootloader not written & pause & exit /b 1 )
echo.
echo EXPECTED: RD0 off, LED0 off (no app, the bootloader waits).
pause
echo.
echo ===== STEP 2: upload the RD0 test app THROUGH the bootloader (%PORT%, DTR on) =====
python "%~dp0mwtest_upload_02102026_1640.py" %PORT% "%~dp0P56Q71_CNANO_RD0_02102026_0525.hex"
if errorlevel 1 ( echo ERROR: upload through the bootloader failed - check both wires & pause & exit /b 1 )
echo.
echo EXPECTED: RD0 3 s fast blink, 3 s fade, then double flash forever.
echo Now open CNano Monitor, Connect: "UART 56Q71 n" lines.
pause
