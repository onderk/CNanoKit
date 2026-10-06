@echo off
rem FREELOADER.exe 1.1 on the Curiosity Nano: DTR is released -> no data -> timeout. CNano Monitor CLOSED.
cd /d "%~dp0"
"C:\FREELOADER Free PIC18 bootloader and uploader__by Jon Walker\Built in APP\FREELOADER.exe" --info COM8
echo.
pause
