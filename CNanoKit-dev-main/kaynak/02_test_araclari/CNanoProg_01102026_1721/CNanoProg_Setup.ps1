<#
  CNanoProg_Setup 0.3 - one-time setup (and re-setup after a new Windows install).
  MIT licence.  No warranty.  01 Oct 2026.

  What it does (each step tells you what it found and what it changed):
    1. Python           - present?  (if not: -InstallPython uses winget, or install it yourself)
    2. pymcuprog        - present?  if not: pip install pymcuprog
    3. Device pack      - the Microchip DFP scripts pymcuprog needs for your PIC; if missing it is
                          downloaded from packs.download.microchip.com into %USERPROFILE%\.mchp_packs
    4. Proton IDE       - adds "Curiosity Nano (CNanoProg)" to its programmer list (registry, HKCU)
    5. Positron Studio  - adds the programmer + a "CNano Monitor" tool (PositronStudio.ini)
    6. VS Code Positron - sets pos.main.programmer / pos.main.programmerArgs (user settings.json,
                          a dated backup copy is made first)
  The IDEs must be CLOSED while this runs (they rewrite their settings when they exit).

  Usage:  CNanoProg_Setup.bat                       (all steps, PIC18F56Q71)
          CNanoProg_Setup.bat -Device pic18f56q71 -Steps python,pymcuprog,pack
          CNanoProg_Setup.bat -Check                (only report, change nothing)
#>
[CmdletBinding()]
param(
    [string]   $Device = 'pic18f56q71',
    [string[]] $Steps = @('python', 'pymcuprog', 'pack', 'protonide', 'positronstudio', 'vscode'),
    [string]   $PackName = '',
    [switch]   $InstallPython,
    [switch]   $Check
)
$ErrorActionPreference = 'Stop'
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Exe = Join-Path $Here 'CNanoProg.exe'
$Name = 'Curiosity Nano (CNanoProg)'
$IdeParams = '$long-hex-filename$ $target-device$'      # no quotes on purpose (see CNanoProg.c)
$Stamp = Get-Date -Format 'ddMMyyyy_HHmm'
$LogDir = Join-Path $Here 'log'
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }
$LogFile = Join-Path $LogDir ('Setup_' + $Stamp + '.log')
$Device = $Device.ToLowerInvariant(); if ($Device -notmatch '^pic') { $Device = 'pic' + $Device }
$script:problems = 0
$Steps = @($Steps | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim().ToLowerInvariant() } | Where-Object { $_ -ne '' })   # -File passes 'a,b' as one string

function Say([string] $m, [string] $c = 'Gray') { Write-Host $m -ForegroundColor $c; Add-Content $LogFile $m }
function Ok([string] $m)   { Say ('  OK    ' + $m) 'Green' }
function Info([string] $m) { Say ('  ..    ' + $m) 'Gray' }
function Warn([string] $m) { Say ('  !!    ' + $m) 'Yellow'; $script:problems++ }
function Did([string] $m)  { Say ('  DONE  ' + $m) 'Cyan' }
function Want([string] $s) { return ($Steps -contains $s) }
function Running([string] $proc) { return [bool](Get-Process -Name $proc -ErrorAction SilentlyContinue) }

Say ('CNanoProg setup  ' + (Get-Date) + '  device=' + $Device + '  folder=' + $Here) 'Cyan'
Say ('steps: ' + ($Steps -join ', ')) 'DarkGray'
if ($Check) { Say '(check only - nothing will be changed)' 'Yellow' }
if (-not (Test-Path $Exe)) { Warn ('CNanoProg.exe not found next to this script: ' + $Exe) }
if ($Here -match ' ') { Info 'this folder has a space in its path - it works, but a path without spaces (e.g. C:\CNanoProg) is safest for old IDEs' }

# ------------------------------------------------------------------ 1 python
$py = $null
if (Want 'python') {
    Say '1) Python' 'White'
    $py = Get-Command python -ErrorAction SilentlyContinue
    if ($py -and $py.Source -match 'WindowsApps') { $py = $null }      # the Store stub, not a real Python
    if ($py) { Ok ((& python --version 2>&1) + '  ' + $py.Source) }
    elseif ($InstallPython -and -not $Check) {
        Info 'installing Python 3.13 with winget ...'
        & winget install -e --id Python.Python.3.13 --scope user --accept-package-agreements --accept-source-agreements
        Warn 'Python installed - CLOSE this window and run the setup again (PATH is only refreshed in a new window)'
        exit 1
    } else { Warn 'Python not found. Install it (python.org, tick "Add python.exe to PATH") or run: CNanoProg_Setup.bat -InstallPython' }
}

# ------------------------------------------------------------------ 2 pymcuprog
if (Want 'pymcuprog') {
    Say '2) pymcuprog' 'White'
    $pm = Get-Command pymcuprog -ErrorAction SilentlyContinue
    if ($pm) {
        $v = (& python -m pip show pymcuprog 2>$null | Select-String '^Version:').ToString()
        Ok ($v + '  ' + $pm.Source)
    } elseif (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Warn 'needs Python first (step 1)'
    } elseif ($Check) { Warn 'pymcuprog not installed' }
    else {
        Info 'pip install pymcuprog ...'
        & python -m pip install --upgrade pymcuprog 2>&1 | ForEach-Object { Add-Content $LogFile $_ }
        if (Get-Command pymcuprog -ErrorAction SilentlyContinue) { Did 'pymcuprog installed' }
        else { Warn 'pymcuprog installed but not on PATH yet - open a new window and run the setup again' }
    }
}

# ------------------------------------------------------------------ 3 pack
function Guess-Pack([string] $d) {
    if ($PackName -ne '') { return $PackName }
    if ($d -match '^pic18f\d+q\d+') { return 'PIC18F-Q_DFP' }
    if ($d -match '^pic18f\d+k\d+') { return 'PIC18F-K_DFP' }
    if ($d -match '^pic16f1\d{4}') { return 'PIC16F1xxxx_DFP' }
    if ($d -match '^pic16f1\d{3}') { return 'PIC12-16F1xxx_DFP' }
    return ''
}
if (Want 'pack') {
    Say ('3) device pack for ' + $Device) 'White'
    $root = Join-Path $env:USERPROFILE '.mchp_packs\Microchip'
    $hits = @(Get-ChildItem -Path $root -Directory -Recurse -Depth 3 -Filter $Device -ErrorAction SilentlyContinue | Where-Object { $_.Parent.Name -eq 'scripts' })
    if ($hits.Count -gt 0) { Ok ($hits[-1].FullName) }
    else {
        $pn = Guess-Pack $Device
        if ($pn -eq '') { Warn ('do not know which pack holds ' + $Device + ' - give -PackName (e.g. PIC18F-Q_DFP)') }
        elseif ($Check) { Warn ($pn + ' not installed') }
        else {
            $base = 'https://packs.download.microchip.com/'
            Info ('reading the latest ' + $pn + ' version from ' + $base)
            $pdsc = (New-Object Net.WebClient).DownloadString($base + 'Microchip.' + $pn + '.pdsc')
            if ($pdsc -notmatch '<release version="([0-9.]+)"') { Warn 'could not read the pack version'; }
            else {
                $ver = $Matches[1]
                $zip = Join-Path $env:TEMP ('Microchip.' + $pn + '.' + $ver + '.zip')
                Info ('downloading Microchip.' + $pn + '.' + $ver + '.atpack (about 40 MB) ...')
                (New-Object Net.WebClient).DownloadFile($base + 'Microchip.' + $pn + '.' + $ver + '.atpack', $zip)
                $dest = Join-Path $root ($pn + '\' + $ver)
                Expand-Archive -Path $zip -DestinationPath $dest -Force
                Remove-Item $zip -ErrorAction SilentlyContinue        # our own temp download only
                if (Test-Path (Join-Path $dest ('scripts\' + $Device))) { Did ('pack ' + $pn + ' ' + $ver + ' -> ' + $dest) }
                else { Warn ($Device + ' is not in ' + $pn + ' ' + $ver + ' - give the right -PackName') }
            }
        }
    }
}

# ------------------------------------------------------------------ 4 Proton IDE (registry)
if (Want 'protonide') {
    Say '4) Proton IDE' 'White'
    $k = 'HKCU:\Software\MecaniqueUK\ProtonIDE\AvailableProgrammer'
    if (-not (Test-Path 'HKCU:\Software\MecaniqueUK\ProtonIDE')) { Info 'Proton IDE has never been started on this PC - skipped' }
    elseif (Running 'ProtonIDE') { Warn 'Proton IDE is running - close it and run the setup again' }
    else {
        if (-not (Test-Path $k)) { if (-not $Check) { New-Item -Path $k -Force | Out-Null; Set-ItemProperty $k Count 0 -Type DWord } }
        $count = 0; try { $count = [int](Get-ItemProperty $k).Count } catch { }
        $slot = -1
        for ($i = 0; $i -lt $count; $i++) {
            $p = Get-ItemProperty (Join-Path $k $i) -ErrorAction SilentlyContinue
            if ($p -and $p.DisplayName -eq $Name) { $slot = $i }
        }
        if ($Check) { if ($slot -ge 0) { Ok 'programmer entry present' } else { Warn 'programmer entry missing' } }
        else {
            if ($slot -lt 0) { $slot = $count; Set-ItemProperty $k Count ($count + 1) -Type DWord }
            $e = Join-Path $k $slot
            if (-not (Test-Path $e)) { New-Item -Path $e | Out-Null }
            Set-ItemProperty $e DisplayName $Name
            Set-ItemProperty $e Filename 'CNanoProg.exe'
            Set-ItemProperty $e Path $Here
            Set-ItemProperty $e Params $IdeParams
            Set-ItemProperty $e Hook ''
            $cp = 'HKCU:\Software\MecaniqueUK\ProtonIDE\CurrentProgrammer'
            if (-not (Test-Path $cp)) { New-Item -Path $cp | Out-Null }
            Set-ItemProperty $cp DisplayName $Name
            Did ('programmer entry ' + $slot + ' set and selected')
        }
    }
}

# ------------------------------------------------------------------ 5 Positron Studio (ini)
if (Want 'positronstudio') {
    Say '5) Positron Studio' 'White'
    $ini = 'C:\ProgramData\Positron Studio\PositronStudio.ini'
    if (-not (Test-Path $ini)) { Info 'PositronStudio.ini not found (Positron Studio never started?) - skipped' }
    elseif (Running 'PositronStudio') { Warn 'Positron Studio is running - close it and run the setup again' }
    else {
        $lines = [Collections.Generic.List[string]](Get-Content $ini)
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
        $mon  = $Exe + ',-Mode monitor -Stamp,1,12364328,0'
        $hasProg = ($lines | Where-Object { $_ -eq ($Name + '=' + $prog) }).Count -gt 0
        if ($Check) { if ($hasProg) { Ok 'programmer entry present' } else { Warn 'programmer entry missing or different' } }
        else {
            Copy-Item $ini (Join-Path $LogDir ('PositronStudio_ini_backup_' + $Stamp + '.ini'))
            # entries made by hand earlier with quotes in the parameters break the ini ("Programmers record error")
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i].StartsWith('None=') -and $lines[$i] -match ',True$') { $lines[$i] = 'None=,,False' }
            }
            Set-IniLine 'Programmers' $Name $prog
            Set-IniLine 'Tools' 'CNano Monitor' $mon
            try { [IO.File]::WriteAllLines($ini, $lines) ; Did 'programmer + "CNano Monitor" tool written (backup in log\)' }
            catch { Warn ('cannot write ' + $ini + ' - run this setup "as administrator" once: ' + $_.Exception.Message) }
        }
    }
}

# ------------------------------------------------------------------ 6 VS Code (settings.json)
if (Want 'vscode') {
    Say '6) VS Code Positron extension' 'White'
    $sj = Join-Path $env:APPDATA 'Code\User\settings.json'
    $ext = @(Get-ChildItem (Join-Path $env:USERPROFILE '.vscode\extensions') -Directory -Filter 'atomix.positron-*' -ErrorAction SilentlyContinue)
    if ($ext.Count -eq 0) { Info 'Positron extension (atomix.positron) not installed - skipped' }
    elseif (Running 'Code') { Warn 'VS Code is running - close it and run the setup again' }
    else {
        Info ('extension: ' + $ext[-1].Name)
        $txt = '{}'
        if (Test-Path $sj) { $txt = [IO.File]::ReadAllText($sj) }
        # VS Code runs the programmer through cmd.exe with the output in its Output panel (no console),
        # so the hex name may be quoted and -NoPause is needed (nobody can press Enter there)
        $want = @{ 'pos.main.programmer' = $Exe; 'pos.main.programmerArgs' = '"$hex-filename$" $target-device$ -NoPause' }
        $have = $true
        foreach ($key in $want.Keys) {
            $jv = ($want[$key] | ConvertTo-Json)
            if ($txt -notmatch ('"' + [regex]::Escape($key) + '"\s*:\s*' + [regex]::Escape($jv))) { $have = $false }
        }
        if ($Check) { if ($have) { Ok 'settings present' } else { Warn 'settings missing or different' } }
        elseif ($have) { Ok 'settings already set' }
        else {
            if (Test-Path $sj) { Copy-Item $sj (Join-Path $LogDir ('vscode_settings_backup_' + $Stamp + '.json')) }
            foreach ($key in $want.Keys) {
                $jv = ($want[$key] | ConvertTo-Json)
                $rx = '("' + [regex]::Escape($key) + '"\s*:\s*)"(?:[^"\\]|\\.)*"'
                if ($txt -match $rx) { $txt = [regex]::Replace($txt, $rx, { param($m) $m.Groups[1].Value + $jv }) }
                else {
                    $p = $txt.LastIndexOf('}')
                    $before = $txt.Substring(0, $p).TrimEnd()
                    $sep = ','; if ($before.EndsWith('{') -or $before.EndsWith(',')) { $sep = '' }
                    $txt = $before + $sep + "`r`n    """ + $key + '": ' + $jv + "`r`n" + $txt.Substring($p)
                }
            }
            New-Item -ItemType Directory -Force -Path (Split-Path $sj) | Out-Null
            [IO.File]::WriteAllText($sj, $txt, (New-Object Text.UTF8Encoding $false))
            Did 'pos.main.programmer and pos.main.programmerArgs set (backup in log\)'
        }
    }
}

Say ''
if ($script:problems -eq 0) { Say 'ALL OK' 'Green' } else { Say ($script:problems.ToString() + ' item(s) need attention - see the !! lines above') 'Yellow' }
Say ('log: ' + $LogFile) 'DarkGray'
