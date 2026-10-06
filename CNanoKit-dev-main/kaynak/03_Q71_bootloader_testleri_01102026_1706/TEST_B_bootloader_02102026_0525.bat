@echo off
rem okmn private bench test - JonW mwboot on PIC18F56Q71 Curiosity Nano. NOT for distribution.
rem Needs: both wires fitted (RC6->RB4, RB5->RC7), RD0 LED, CNano Monitor CLOSED (COM8 free).
setlocal
set T=%~dp0
set APP=%T%P56Q71_CNANO_RD0_02102026_0525.hex
set BOOT=%T%P56Q71_MWBOOT.hex
set PROG=C:\Tarim\CNanoKit_01102026_2005\CNanoProg.exe
set UPL=C:\Tarim\araclar\CNano_Prog_01102026_1706\mwtest_upload.py
set PORT=COM8
if not exist "%APP%" (
  echo HATA: %APP% yok. Once P56Q71_CNANO_RD0_02102026_0525.bas dosyasini DERLE ^(VS Code: Ctrl+Alt+C^).
  pause & exit /b 1
)
echo.
echo ===== ADIM 1: kite YALNIZ JonW bootloader yaziliyor =====
"%PROG%" "%BOOT%" 18F56Q71 -NoPause
if errorlevel 1 ( echo HATA: bootloader yazilamadi & pause & exit /b 1 )
echo.
echo BEKLENEN: RD0 SONUK, LED0 SONUK (uygulama yok, bootloader bekliyor).
pause
echo.
echo ===== ADIM 2: RD0 test uygulamasi BOOTLOADER UZERINDEN yukleniyor (%PORT%, DTR acik) =====
python "%UPL%" %PORT% "%APP%"
if errorlevel 1 ( echo HATA: bootloader ile yukleme basarisiz - kablolari kontrol et & pause & exit /b 1 )
echo.
echo BEKLENEN: RD0 3 sn hizli yanip soner, 3 sn yavas yanar-soner, sonra surekli cift flas.
echo Simdi CNano Monitor'u ac, Baglan: "UART 56Q71 n" satirlari gelmeli.
pause
