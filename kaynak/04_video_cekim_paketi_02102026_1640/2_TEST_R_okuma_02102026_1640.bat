@echo off
rem Run AFTER 1_TEST_B (bootloader + app in the chip). Both wires fitted. CNano Monitor CLOSED.
cd /d "%~dp0"
python "%~dp0mwtest_read_02102026_1640.py" COM8 "%~dp0P56Q71_CNANO_RD0_02102026_0525.hex" "%~dp0P56Q71_MWBOOT.hex"
echo.
echo Report: %~dp0log\
pause
