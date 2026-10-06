@echo off
powershell -NoProfile -Command "$t=Get-Content $env:APPDATA\Code\User\settings.json; $t[315..($t.Count-1)]" > "%~dp0log\step53_tail.txt" 2>&1
