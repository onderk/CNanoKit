$ErrorActionPreference='SilentlyContinue'
"=== Windows"; (Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber,OSArchitecture | Format-List | Out-String).Trim()
"=== PowerShell"; $PSVersionTable.PSVersion.ToString()
"=== Positron / Proton files"
foreach($f in 'C:\Program Files (x86)\ProtonIDE\PDS\Pos8.exe','C:\Program Files (x86)\ProtonIDE\PDS\Pos16.exe','C:\Program Files (x86)\ProtonIDE\PDS\Loader.exe','C:\Program Files (x86)\ProtonIDE\ProtonIDE.exe','C:\Program Files\Positron Studio\PositronStudio.exe'){ $i=(Get-Item $f).VersionInfo; '{0}  file={1}  product={2}  {3}' -f $f,$i.FileVersion,$i.ProductVersion,$i.ProductName }
"=== Uninstall entries"
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -match 'Positron|Proton|MPLAB|Python|Visual Studio Code|Microchip' } | Sort-Object DisplayName | ForEach-Object { '{0} | {1} | {2}' -f $_.DisplayName,$_.DisplayVersion,$_.Publisher }
"=== VS Code"; & "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" --version 2>$null | Select-Object -First 1
"=== Python"; & python --version; & python -m pip show pymcuprog pyedbglib pyserial 2>$null | Select-String '^(Name|Version):'
"=== Kit USB devices and drivers"
Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match 'VID_03EB&PID_2175' } | ForEach-Object {
  $p = Get-PnpDeviceProperty -InstanceId $_.InstanceId -KeyName DEVPKEY_Device_DriverProvider,DEVPKEY_Device_DriverInfPath,DEVPKEY_Device_DriverVersion,DEVPKEY_Device_Service,DEVPKEY_Device_DriverDate
  '{0} | {1} | provider={2} | inf={3} | ver={4} | service={5}' -f $_.FriendlyName,$_.Class,($p|?{$_.KeyName -eq 'DEVPKEY_Device_DriverProvider'}).Data,($p|?{$_.KeyName -eq 'DEVPKEY_Device_DriverInfPath'}).Data,($p|?{$_.KeyName -eq 'DEVPKEY_Device_DriverVersion'}).Data,($p|?{$_.KeyName -eq 'DEVPKEY_Device_Service'}).Data
}
"=== Microchip/Atmel driver packages in the driver store"
pnputil /enum-drivers | Select-String -Context 0,6 'Microchip|Atmel' | Out-String
