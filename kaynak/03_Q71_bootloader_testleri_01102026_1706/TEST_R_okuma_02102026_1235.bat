@echo off
rem okmn private bench test - JonW mwboot R (read) command. NOT for distribution.
rem Before: TEST_B done (bootloader + RD0 app in the kit), both wires fitted, CNano Monitor CLOSED.
set T=%~dp0
python "C:\Tarim\araclar\CNano_Prog_01102026_1706\mwtest_read_02102026_1340.py" COM8 "%T%P56Q71_CNANO_RD0_02102026_0525.hex" "%T%P56Q71_MWBOOT.hex"
echo.
echo Rapor: C:\Tarim\araclar\CNano_Prog_01102026_1706\log\R_test_GGAAYYYY_SSDD.txt
pause
