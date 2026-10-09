@echo off
set L=C:\Tarim\araclar\CNano_Prog_01102026_1706\log\probe.txt
echo === probe %DATE% %TIME% > "%L%"
echo --- args: %* >> "%L%"
echo --- python >> "%L%"
where python py pymcuprog >> "%L%" 2>&1
python --version >> "%L%" 2>&1
python -m pip show pymcuprog >> "%L%" 2>&1
echo --- mplab >> "%L%"
dir /b "C:\Program Files\Microchip\MPLABX" >> "%L%" 2>&1
dir /b "C:\Program Files\Microchip\MPLABX\v6.35\mplab_platform\mplab_ipe" >> "%L%" 2>&1
dir /b "C:\Program Files\Microchip\MPLABX\v6.35\mplab_platform\bin\mdb*" >> "%L%" 2>&1
echo --- packs >> "%L%"
dir /b "%USERPROFILE%\.mchp_packs\Microchip" >> "%L%" 2>&1
dir /b "%USERPROFILE%\.mchp_packs\Microchip\PIC18F-Q_DFP" >> "%L%" 2>&1
dir /b "C:\Program Files\Microchip\MPLABX\v6.35\packs\Microchip\PIC18F-Q_DFP" >> "%L%" 2>&1
echo --- volumes >> "%L%"
powershell -NoProfile -Command "Get-Volume | Format-Table DriveLetter,FileSystemLabel,Size -Auto | Out-String -Width 200" >> "%L%" 2>&1
echo --- com >> "%L%"
powershell -NoProfile -Command "Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -match '\(COM\d+\)' } | Select-Object Name,DeviceID | Format-List | Out-String -Width 300" >> "%L%" 2>&1
echo --- usb mchp >> "%L%"
powershell -NoProfile -Command "Get-CimInstance Win32_PnPEntity | Where-Object { $_.DeviceID -match 'VID_03EB|VID_04D8' } | Select-Object Name,DeviceID,Status | Format-List | Out-String -Width 300" >> "%L%" 2>&1
echo === end >> "%L%"
