# waits until Positron Studio is closed, then renames the private test tool entry (no names in menus)
$ini = 'C:\ProgramData\Positron Studio\PositronStudio.ini'
$log = Join-Path $PSScriptRoot 'log\step50_rename.txt'
"start $(Get-Date)" | Set-Content $log
for ($i = 0; $i -lt 600; $i++) { if (-not (Get-Process PositronStudio -ErrorAction SilentlyContinue)) { break }; Start-Sleep -Milliseconds 500 }
Start-Sleep -Seconds 2
Copy-Item $ini (Join-Path $PSScriptRoot 'log\PositronStudio_ini_before_rename.txt')
$t = [IO.File]::ReadAllLines($ini)
$t = $t | ForEach-Object { $_ -replace '^CNano Run \(asistan\)=', 'CNano Test=' }
[IO.File]::WriteAllLines($ini, $t)
"done $(Get-Date)" | Add-Content $log
Select-String -Path $ini -Pattern 'CNano|asistan' | ForEach-Object { $_.Line } | Add-Content $log
