<#
  CNanoKit Setup 0.5 - one-time setup (and again after a new Windows install)
  CNanoKit Kurulum 0.5 - tek seferlik kurulum (Windows yeniden kurulunca da)
  MIT licence.  No warranty.  okmn, 2026.

  Steps / Adımlar (each one reports what it found and what it changed):
    python          Python present? (-InstallPython installs it with winget)
    pymcuprog       Microchip pymcuprog (pip install pymcuprog)
    pack            Microchip device pack for the PIC (downloaded if missing)
    protonide       Proton IDE plugin buttons: "Program (CNanoProg)" + "Monitor (CNanoMonitor)"
    positronstudio  Positron Studio programmer + "CNano Monitor" tool
    vscode          VS Code Positron extension: pos.main.programmer / programmerArgs
    shortcuts       Desktop + Start menu shortcuts: CNano Monitor, CNano Kurulum/Setup
  Close the IDEs first (they rewrite their settings when they close).

  Usage: CNanoProg_Setup.bat                   all steps
         CNanoProg_Setup.bat -Check            report only, change nothing
         CNanoProg_Setup.bat -Lang en          English messages
         CNanoProg_Setup.bat -Steps pack,vscode
#>
[CmdletBinding()]
param(
    [string]   $Device = 'pic18f56q71',
    [string[]] $Steps = @('python', 'pymcuprog', 'pack', 'protonide', 'positronstudio', 'vscode', 'shortcuts'),
    [string]   $PackName = '',
    [ValidateSet('auto', 'tr', 'en')] [string] $Lang = 'auto',
    [switch]   $InstallPython,
    [switch]   $Check
)
$ErrorActionPreference = 'Continue'   # PS 5.1: 'Stop' turns pip/python stderr lines into fatal errors
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Exe = Join-Path $Here 'CNanoProg.exe'
$Mon = Join-Path $Here 'CNanoMonitor.exe'
$Plug = Join-Path $Here 'CNanoProtonPlugin.exe'
$Name = 'Curiosity Nano (CNanoProg)'
$IdeParams = '$long-hex-filename$ $target-device$'      # no quotes: quotes break PositronStudio.ini
$Stamp = Get-Date -Format 'ddMMyyyy_HHmm'
$LogDir = Join-Path $Here 'log'
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }
$LogFile = Join-Path $LogDir ('Setup_' + $Stamp + '.log')
$Device = $Device.ToLowerInvariant(); if ($Device -notmatch '^pic') { $Device = 'pic' + $Device }
$Steps = @($Steps | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim().ToLowerInvariant() } | Where-Object { $_ -ne '' })
$script:problems = 0

# ---- language (also stored in settings.ini for CNanoProg and CNano Monitor)
$Ini = Join-Path $Here 'settings.ini'
if ($Lang -eq 'auto' -and (Test-Path $Ini)) { foreach ($l in Get-Content $Ini) { if ($l -match '^\s*Lang\s*=\s*(tr|en)\s*$') { $Lang = $Matches[1] } } }
if ($Lang -eq 'auto') { if ((Get-Culture).TwoLetterISOLanguageName -eq 'tr') { $Lang = 'tr' } else { $Lang = 'en' } }
$script:LangIsTr = ($Lang -eq 'tr')
function M([string] $enText, [string] $trText) { if ($script:LangIsTr) { return $trText } else { return $enText } }
if (-not $Check) {
    $lines = @(); if (Test-Path $Ini) { $lines = @(Get-Content $Ini | Where-Object { $_ -notmatch '^\s*Lang\s*=' }) }
    Set-Content -Path $Ini -Value (@('Lang=' + $Lang) + $lines)
}

function Say([string] $m, [string] $c = 'Gray') { Write-Host $m -ForegroundColor $c; Add-Content $LogFile $m -Encoding UTF8 }
function Ok([string] $m)   { Say ('  OK     ' + $m) 'Green' }
function Info([string] $m) { Say ('  ..     ' + $m) 'Gray' }
function Warn([string] $m) { Say ('  !!     ' + $m) 'Yellow'; $script:problems++ }
function Did([string] $m)  { Say ((M '  DONE   ' '  YAPILDI ') + $m) 'Cyan' }
function Want([string] $s) { return ($Steps -contains $s) }
function Running([string] $proc) { return [bool](Get-Process -Name $proc -ErrorAction SilentlyContinue) }

Say ('CNanoKit ' + (M 'setup' 'kurulum') + '  ' + (Get-Date) + '  device=' + $Device + '  ' + (M 'folder=' 'klasor=') + $Here) 'Cyan'
Say ((M 'steps: ' 'adimlar: ') + ($Steps -join ', ')) 'DarkGray'
if ($Check) { Say (M '(check only - nothing will be changed)' '(yalniz kontrol - hicbir sey degistirilmeyecek)') 'Yellow' }
foreach ($f in $Exe, $Mon, $Plug) { if (-not (Test-Path $f)) { Warn ((M 'missing file: ' 'eksik dosya: ') + $f) } }
if ($Here -match ' ') { Info (M 'this folder path has a space; it works, but C:\CNanoKit is safest' 'bu klasor yolunda bosluk var; calisir ama en guvenlisi C:\CNanoKit') }

# ------------------------------------------------------------------ 1 python
if (Want 'python') {
    Say (M '1) Python' '1) Python') 'White'
    $py = Get-Command python -ErrorAction SilentlyContinue
    if ($py -and $py.Source -match 'WindowsApps') { $py = $null }      # the Microsoft Store stub, not a real Python
    if ($py) { Ok ((& python --version 2>&1) + '  ' + $py.Source) }
    elseif ($InstallPython -and -not $Check) {
        Info (M 'installing Python 3.13 with winget ...' 'Python 3.13 winget ile kuruluyor ...')
        & winget install -e --id Python.Python.3.13 --scope user --accept-package-agreements --accept-source-agreements
        Warn (M 'Python installed - CLOSE this window and run the setup again' 'Python kuruldu - bu pencereyi KAPATIN ve kurulumu yeniden calistirin')
        exit 1
    } else { Warn (M 'Python not found. Install it from python.org (tick "Add python.exe to PATH") or run: CNanoProg_Setup.bat -InstallPython' 'Python bulunamadi. python.org''dan kurun ("Add python.exe to PATH" isaretli) veya: CNanoProg_Setup.bat -InstallPython') }
}

# ------------------------------------------------------------------ 2 pymcuprog
if (Want 'pymcuprog') {
    Say '2) pymcuprog' 'White'
    $pm = Get-Command pymcuprog -ErrorAction SilentlyContinue
    if ($pm) { Ok (((& python -m pip show pymcuprog 2>$null | Select-String '^Version:') -replace 'Version:\s*', 'v') + '  ' + $pm.Source) }
    elseif (-not (Get-Command python -ErrorAction SilentlyContinue)) { Warn (M 'needs Python first (step 1)' 'once Python gerekli (adim 1)') }
    elseif ($Check) { Warn (M 'pymcuprog not installed' 'pymcuprog kurulu degil') }
    else {
        Info 'python -m pip install --upgrade pymcuprog ...'
        & python -m pip install --upgrade pymcuprog 2>&1 | ForEach-Object { Add-Content $LogFile $_ }
        if (Get-Command pymcuprog -ErrorAction SilentlyContinue) { Did (M 'pymcuprog installed' 'pymcuprog kuruldu') }
        else { Warn (M 'pymcuprog installed but not on PATH yet - open a new window and run the setup again' 'pymcuprog kuruldu ama PATH''te degil - yeni pencerede kurulumu yeniden calistirin') }
    }
}

# ------------------------------------------------------------------ 3 device pack
function Guess-Pack([string] $d) {
    if ($PackName -ne '') { return $PackName }
    if ($d -match '^pic18f\d+q\d+') { return 'PIC18F-Q_DFP' }
    if ($d -match '^pic18f\d+k\d+') { return 'PIC18F-K_DFP' }
    if ($d -match '^pic16f1\d{4}') { return 'PIC16F1xxxx_DFP' }
    if ($d -match '^pic16f1\d{3}') { return 'PIC12-16F1xxx_DFP' }
    return ''
}
if (Want 'pack') {
    Say ((M '3) device pack for ' '3) cihaz paketi: ') + $Device) 'White'
    $root = Join-Path $env:USERPROFILE '.mchp_packs\Microchip'
    $hits = @(Get-ChildItem -Path $root -Directory -Recurse -Depth 3 -Filter $Device -ErrorAction SilentlyContinue | Where-Object { $_.Parent.Name -eq 'scripts' })
    if ($hits.Count -gt 0) { Ok ($hits[-1].FullName) }
    else {
        $pn = Guess-Pack $Device
        if ($pn -eq '') { Warn ((M 'unknown pack for ' 'paket bilinmiyor: ') + $Device + ' (-PackName)') }
        elseif ($Check) { Warn ($pn + (M ' not installed' ' kurulu degil')) }
        else {
          try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $base = 'https://packs.download.microchip.com/'
            Info ((M 'reading the latest ' 'en son surum okunuyor: ') + $pn)
            $pdsc = (New-Object Net.WebClient).DownloadString($base + 'Microchip.' + $pn + '.pdsc')
            if ($pdsc -notmatch '<release version="([0-9.]+)"') { Warn (M 'could not read the pack version' 'paket surumu okunamadi') }
            else {
                $ver = $Matches[1]
                $zip = Join-Path $env:TEMP ('Microchip.' + $pn + '.' + $ver + '.zip')
                Info ((M 'downloading ' 'indiriliyor ') + 'Microchip.' + $pn + '.' + $ver + '.atpack (~40 MB) ...')
                (New-Object Net.WebClient).DownloadFile($base + 'Microchip.' + $pn + '.' + $ver + '.atpack', $zip)
                $dest = Join-Path $root ($pn + '\' + $ver)
                Expand-Archive -Path $zip -DestinationPath $dest -Force -ErrorAction Stop
                Remove-Item $zip -ErrorAction SilentlyContinue        # our own temporary download
                if (Test-Path (Join-Path $dest ('scripts\' + $Device))) { Did ($pn + ' ' + $ver + ' -> ' + $dest) }
                else { Warn ($Device + (M ' is not in this pack - give -PackName' ' bu pakette yok - -PackName verin')) }
            }
          } catch { Warn ((M 'pack download failed (internet?): ' 'paket indirilemedi (internet?): ') + $_.Exception.Message) }
        }
    }
}

# ------------------------------------------------------------------ 4 Proton IDE plugin (.mcp)
# .mcp layout (made with the Proton IDE Plugin Editor and read back, 01 Oct 2026):
#   06 08 "MCPLUGIN" 02 02 | str name | 5 x bool | str group | 2 x bool | 02 instance | 02 enabled
#   | str shortcut | str link | str params | bool programmer-link, bool auto-exec, bool menu, bool speed-button
#   str = 06 <len> <ansi bytes>, bool = 08 false / 09 true
function New-Mcp([string] $name, [string] $group, [string] $link, [string] $params, [bool] $progLink) {
    $enc = [Text.Encoding]::GetEncoding(1252)
    $b = New-Object Collections.Generic.List[byte]
    function S([string] $s) { $x = $enc.GetBytes($s); if ($x.Length -gt 255) { throw 'path too long' }; $b.Add(6); $b.Add([byte]$x.Length); $b.AddRange($x) }
    function B([bool] $v) { if ($v) { $b.Add(9) } else { $b.Add(8) } }
    S 'MCPLUGIN'; $b.Add(2); $b.Add(2)
    S $name; 1..5 | ForEach-Object { B $false }
    S $group; B $false; B $false
    $b.Add(2); $b.Add(0); $b.Add(2); $b.Add(0)
    S ''; S $link; S $params
    B $progLink; B $false; B $true; B $true
    return , $b.ToArray()
}
if (Want 'protonide') {
    Say '4) Proton IDE' 'White'
    $plugRoot = $null
    try { $plugRoot = (Get-ItemProperty 'HKCU:\Software\MecaniqueUK\ProtonIDE\Install' -ErrorAction Stop).PluginMCP } catch { }
    if (-not $plugRoot) { $plugRoot = Join-Path $env:APPDATA 'PDS\Plugin' }
    if (-not (Test-Path 'C:\Program Files (x86)\ProtonIDE\ProtonIDE.exe') -and -not (Test-Path 'HKCU:\Software\MecaniqueUK\ProtonIDE')) { Info (M 'Proton IDE not installed - skipped' 'Proton IDE kurulu degil - atlandi') }
    else {
        $dir = Join-Path $plugRoot 'CNano'
        $p1 = Join-Path $dir 'CNano_Program.mcp'; $p2 = Join-Path $dir 'CNano_Monitor.mcp'
        if ($Check) { if ((Test-Path $p1) -and (Test-Path $p2)) { Ok ((M 'plugin buttons present: ' 'eklenti dugmeleri var: ') + $dir) } else { Warn (M 'plugin buttons missing' 'eklenti dugmeleri yok') } }
        else {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            $m1 = New-Mcp 'Program (CNanoProg)' 'Curiosity Nano' $Plug 'program' $true
            $m2 = New-Mcp 'Monitor (CNanoMonitor)' 'Curiosity Nano' $Plug 'monitor' $false
            $same = (Test-Path $p1) -and (Test-Path $p2) -and ([Convert]::ToBase64String([IO.File]::ReadAllBytes($p1)) -eq [Convert]::ToBase64String($m1)) -and ([Convert]::ToBase64String([IO.File]::ReadAllBytes($p2)) -eq [Convert]::ToBase64String($m2))
            if ($same) { Ok ((M 'plugin buttons already set: ' 'eklenti dugmeleri zaten ayarli: ') + $dir) }
            else {
                [IO.File]::WriteAllBytes($p1, $m1); [IO.File]::WriteAllBytes($p2, $m2)
                Did ((M 'plugin buttons written to ' 'eklenti dugmeleri yazildi: ') + $dir)
                Info (M 'restart Proton IDE to see the buttons' 'dugmeleri gormek icin Proton IDE''yi yeniden baslatin')
            }
            Info (M 'Proton IDE: toolbar buttons "Program (CNanoProg)" and "Monitor (CNanoMonitor)"; Proton IDE''s own Program button is not used' 'Proton IDE: arac cubugunda "Program (CNanoProg)" ve "Monitor (CNanoMonitor)" dugmeleri; Proton IDE''nin kendi Program dugmesi kullanilmaz')
        }
    }
}

# ------------------------------------------------------------------ 5 Positron Studio (ini)
if (Want 'positronstudio') {
    Say '5) Positron Studio' 'White'
    $psIni = 'C:\ProgramData\Positron Studio\PositronStudio.ini'
    if (-not (Test-Path $psIni)) { Info (M 'PositronStudio.ini not found (start Positron Studio once first) - skipped' 'PositronStudio.ini yok (Positron Studio''yu once bir kez acip kapatin) - atlandi') }
    else {
        $lines = [Collections.Generic.List[string]](Get-Content $psIni)
        function Set-IniLine([string] $section, [string] $key, [string] $value) {
            $s = $lines.IndexOf('[' + $section + ']')
            if ($s -lt 0) { $lines.Add(''); $lines.Add('[' + $section + ']'); $s = $lines.Count - 1 }
            $i = $s + 1
            while ($i -lt $lines.Count -and -not $lines[$i].StartsWith('[')) {
                if ($lines[$i].StartsWith($key + '=')) { $lines[$i] = $key + '=' + $value; return }
                $i++
            }
            $j = $i; while ($j -gt $s + 1 -and $lines[$j - 1].Trim() -eq '') { $j-- }
            $lines.Insert($j, $key + '=' + $value)
        }
        $prog = $Exe + ',' + $IdeParams + ',True'
        $tool = $Mon + ',,1,12364328,0'
        $hasProg = @($lines | Where-Object { $_ -eq ($Name + '=' + $prog) }).Count -gt 0
        $hasTool = @($lines | Where-Object { $_ -eq ('CNano Monitor=' + $tool) }).Count -gt 0
        if ($hasProg -and $hasTool) { Ok (M 'programmer + "CNano Monitor" tool already set' 'programci + "CNano Monitor" araci zaten ayarli') }
        elseif ($Check) { Warn (M 'programmer entry missing or different' 'programci kaydi yok veya farkli') }
        elseif (Running 'PositronStudio') { Warn (M 'Positron Studio is running - close it and run the setup again' 'Positron Studio acik - kapatin ve kurulumu yeniden calistirin') }
        else {
            Copy-Item $psIni (Join-Path $LogDir ('PositronStudio_ini_backup_' + $Stamp + '.ini'))
            for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -eq 'None=,,True') { $lines[$i] = 'None=,,False' } }
            Set-IniLine 'Programmers' $Name $prog
            Set-IniLine 'Tools' 'CNano Monitor' $tool
            $s = $lines.IndexOf('[Programmers]'); $idx = -1; $n = 0
            for ($i = $s + 1; $i -lt $lines.Count -and -not $lines[$i].StartsWith('['); $i++) {
                if ($lines[$i] -match '^[^;=][^=]*=') { if ($lines[$i].StartsWith($Name + '=')) { $idx = $n }; $n++ }
            }
            if ($idx -ge 0) { Set-IniLine 'Options' 'DefaultProgrammer' ([string]$idx) }
            try { [IO.File]::WriteAllLines($psIni, $lines); Did (M 'programmer + "CNano Monitor" tool written (backup in log\)' 'programci + "CNano Monitor" araci yazildi (yedek log\ klasorunde)') }
            catch { Warn ((M 'cannot write PositronStudio.ini - run the setup once "as administrator": ' 'PositronStudio.ini yazilamadi - kurulumu bir kez "Yonetici olarak" calistirin: ') + $_.Exception.Message) }
        }
    }
}

# ------------------------------------------------------------------ 6 VS Code (settings.json)
if (Want 'vscode') {
    Say (M '6) VS Code Positron extension' '6) VS Code Positron eklentisi') 'White'
    $sj = Join-Path $env:APPDATA 'Code\User\settings.json'
    $ext = @(Get-ChildItem (Join-Path $env:USERPROFILE '.vscode\extensions') -Directory -Filter 'atomix.positron-*' -ErrorAction SilentlyContinue)
    if ($ext.Count -eq 0) { Info (M 'Positron extension (atomix.positron) not installed - skipped' 'Positron eklentisi (atomix.positron) kurulu degil - atlandi') }
    else {
        Info ((M 'extension: ' 'eklenti: ') + $ext[-1].Name)
        $txt = '{}'; if (Test-Path $sj) { $txt = [IO.File]::ReadAllText($sj) }
        # VS Code runs the programmer through cmd.exe, output in its Output panel (no console): -NoPause
        $want = [ordered]@{ 'pos.main.programmer' = $Exe; 'pos.main.programmerArgs' = '"$hex-filename$" $target-device$ -NoPause' }
        $have = $true
        foreach ($key in $want.Keys) { $jv = ($want[$key] | ConvertTo-Json); if ($txt -notmatch ('"' + [regex]::Escape($key) + '"\s*:\s*' + [regex]::Escape($jv))) { $have = $false } }
        # .bas files must open in the "pos" (Positron) language, otherwise VS Code hides the extension's
        # Compile / Compile and Program / Program title buttons (package.json: when "resourceLangId == pos")
        $assocOk = ($txt -match '"\*\.bas"\s*:\s*"pos"')
        if (-not $assocOk) { $have = $false }
        if ($have) { Ok (M 'settings already set (.bas = Positron)' 'ayarlar zaten yapilmis (.bas = Positron)') }
        elseif ($Check) { Warn (M 'settings missing or different' 'ayarlar yok veya farkli') }
        else {
            if (-not $assocOk) {
                if ($txt -match '"\*\.bas"\s*:\s*"[^"]*"') { $txt = [regex]::Replace($txt, '"\*\.bas"\s*:\s*"[^"]*"', '"*.bas": "pos"') }
                elseif ($txt -match '"files\.associations"\s*:\s*\{') {
                    $txt = [regex]::Replace($txt, '("files\.associations"\s*:\s*\{)(\s*\})?', { param($m) if ($m.Groups[2].Success) { $m.Groups[1].Value + ' "*.bas": "pos" }' } else { $m.Groups[1].Value + ' "*.bas": "pos",' } }, 1)
                } else {
                    $p0 = $txt.LastIndexOf('}'); $b0 = $txt.Substring(0, $p0).TrimEnd()
                    $s0 = ','; if ($b0.EndsWith('{') -or $b0.EndsWith(',')) { $s0 = '' }
                    $txt = $b0 + $s0 + "`r`n    `"files.associations`": { `"*.bas`": `"pos`" }`r`n" + $txt.Substring($p0)
                }
            }
            if (Test-Path $sj) { Copy-Item $sj (Join-Path $LogDir ('vscode_settings_backup_' + $Stamp + '.json')) }
            foreach ($key in $want.Keys) {
                $jv = ($want[$key] | ConvertTo-Json)
                $rx = '("' + [regex]::Escape($key) + '"\s*:\s*)"(?:[^"\\]|\\.)*"'
                if ($txt -match $rx) { $txt = [regex]::Replace($txt, $rx, { param($m) $m.Groups[1].Value + $jv }) }
                else {
                    $p = $txt.LastIndexOf('}'); $before = $txt.Substring(0, $p).TrimEnd()
                    $sep = ','; if ($before.EndsWith('{') -or $before.EndsWith(',')) { $sep = '' }
                    $txt = $before + $sep + "`r`n    """ + $key + '": ' + $jv + "`r`n" + $txt.Substring($p)
                }
            }
            New-Item -ItemType Directory -Force -Path (Split-Path $sj) | Out-Null
            [IO.File]::WriteAllText($sj, $txt, (New-Object Text.UTF8Encoding $false))
            Did (M 'pos.main.programmer / programmerArgs + .bas = Positron set (backup in log\)' 'pos.main.programmer / programmerArgs + .bas = Positron ayarlandi (yedek log\ klasorunde)')
        }
        # CNano Monitor inside VS Code: a user task "CNano Monitor" (Terminal > Run Task) + key Ctrl+Alt+N
        $ud = Split-Path $sj
        $tj = Join-Path $ud 'tasks.json'; $kj = Join-Path $ud 'keybindings.json'
        $monJson = ($Mon | ConvertTo-Json)
        $task = '{ "label": "CNano Monitor", "type": "process", "command": ' + $monJson + ', "presentation": { "reveal": "never", "panel": "dedicated" }, "problemMatcher": [] }'
        $key = '{ "key": "ctrl+alt+n", "command": "workbench.action.tasks.runTask", "args": "CNano Monitor" }'
        $tt = ''; if (Test-Path $tj) { $tt = [IO.File]::ReadAllText($tj) }
        $kk = ''; if (Test-Path $kj) { $kk = [IO.File]::ReadAllText($kj) }
        $okT = ($tt -match [regex]::Escape($monJson)); $okK = ($kk -match '"CNano Monitor"')
        if ($okT -and $okK) { Ok (M 'CNano Monitor task + Ctrl+Alt+N already set' 'CNano Monitor gorevi + Ctrl+Alt+N zaten ayarli') }
        elseif ($Check) { Warn (M 'CNano Monitor task / Ctrl+Alt+N missing' 'CNano Monitor gorevi / Ctrl+Alt+N yok') }
        else {
            if (-not $okT) {
                if ($tt -ne '') { Copy-Item $tj (Join-Path $LogDir ('vscode_tasks_backup_' + $Stamp + '.json')) }
                if ($tt -match '"label"\s*:\s*"CNano Monitor"') { $tt = [regex]::Replace($tt, '("label"\s*:\s*"CNano Monitor"\s*,\s*"type"\s*:\s*"process"\s*,\s*"command"\s*:\s*)"(?:[^"\\]|\\.)*"', { param($m) $m.Groups[1].Value + $monJson }) }
                elseif ($tt -match '"tasks"\s*:\s*\[') { $tt = [regex]::Replace($tt, '("tasks"\s*:\s*\[)', { param($m) $m.Groups[1].Value + "`r`n    " + $task + ',' }, 1) }
                else { $tt = "{`r`n  `"version`": `"2.0.0`",`r`n  `"tasks`": [`r`n    " + $task + "`r`n  ]`r`n}`r`n" }
                [IO.File]::WriteAllText($tj, $tt, (New-Object Text.UTF8Encoding $false))
            }
            if (-not $okK) {
                if ($kk -ne '') { Copy-Item $kj (Join-Path $LogDir ('vscode_keybindings_backup_' + $Stamp + '.json')) }
                if ($kk -match '\[') { $i = $kk.IndexOf('['); $rest = $kk.Substring($i + 1).Trim(); $sep = ','; if ($rest.StartsWith(']')) { $sep = '' }; $kk = $kk.Substring(0, $i + 1) + "`r`n    " + $key + $sep + $kk.Substring($i + 1) }
                else { $kk = "[`r`n    " + $key + "`r`n]`r`n" }
                [IO.File]::WriteAllText($kj, $kk, (New-Object Text.UTF8Encoding $false))
            }
            Did (M 'VS Code: task "CNano Monitor" + key Ctrl+Alt+N (backup in log\)' 'VS Code: "CNano Monitor" gorevi + Ctrl+Alt+N tusu (yedek log\ klasorunde)')
        }
    }
}

# ------------------------------------------------------------------ 7 shortcuts
if (Want 'shortcuts') {
    Say (M '7) shortcuts' '7) kisayollar') 'White'
    $sh = New-Object -ComObject WScript.Shell
    $targets = @(
        @{ n = (M 'CNano Monitor' 'CNano Monitor'); t = $Mon; a = '' },
        @{ n = (M 'CNano Setup' 'CNano Kurulum'); t = (Join-Path $Here 'CNanoProg_Setup.bat'); a = '' }
    )
    $places = @([Environment]::GetFolderPath('Desktop'), (Join-Path ([Environment]::GetFolderPath('Programs')) 'CNanoKit'))
    foreach ($pl in $places) {
        foreach ($x in $targets) {
            $lnk = Join-Path $pl ($x.n + '.lnk')
            if ($Check) { if (Test-Path $lnk) { Ok $lnk } else { Info ((M 'no shortcut: ' 'kisayol yok: ') + $lnk) }; continue }
            New-Item -ItemType Directory -Force -Path $pl | Out-Null
            $s = $sh.CreateShortcut($lnk); $s.TargetPath = $x.t; $s.Arguments = $x.a; $s.WorkingDirectory = $Here; $s.Save()
        }
    }
    if (-not $Check) { Did (M 'Desktop + Start menu (CNanoKit) shortcuts' 'Masaustu + Baslat menusu (CNanoKit) kisayollari') }
}

Say ''
if ($script:problems -eq 0) { Say (M 'ALL OK' 'HEPSI TAMAM') 'Green' } else { Say ($script:problems.ToString() + (M ' item(s) need attention - see the !! lines' ' madde ilgi bekliyor - !! satirlarina bakin')) 'Yellow' }
Say ((M 'log: ' 'kayit: ') + $LogFile) 'DarkGray'
