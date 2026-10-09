@echo off
rem CNanoProg one-time setup - double-click, or run with options (see CNanoProg_Setup.ps1)
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0CNanoProg_Setup.ps1" %*
echo.
pause
