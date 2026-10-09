<#
  CNanoProg 0.3  -  program a Microchip Curiosity Nano kit from Positron (Proton IDE,
  Positron Studio, VS Code Positron extension) or any IDE that can call an external
  programmer with a hex file name and a device name.

  MIT licence (see LICENSE.txt).  No warranty.  01 Oct 2026.

  Modes
    auto        pymcuprog (erase + write + verify + reset) if found, else drag-and-drop
    pymcuprog   nEDBG through Microchip pymcuprog (needs Python + pymcuprog + the DFP pack)
    dragdrop    copy the hex to the kit's CURIOSITY drive (no extra software at all)
    freeloader  upload through the mwboot bootloader with Jon Walker's FREELOADER.exe,
                the kit's debugger does the reset (no button, no DTR wire)
    reset       reset the target (runs the application)
    erase       chip erase (pymcuprog)
    read        read the whole chip into a hex file (pymcuprog)
    info        show kit, debugger, pack and tool information
    monitor     two-way terminal on the kit's virtual COM port (the simple "debug" view):
                prints what the target sends, sends what you type (Enter = CR LF),
                Esc quits.  -Monitor N = stop after N seconds (0 = until Esc).
                -Stamp = time stamp on every received line.  Saved in log\monitor_*.txt

  Examples
    CNanoProg.exe "C:\work\BLINK.hex" 18F56Q71
    CNanoProg.exe "C:\work\BLINK.bas" 18F56Q71 -Mode dragdrop
    CNanoProg.exe "C:\work\APP.hex"   18F56Q71 -Mode freeloader -Monitor 10
    CNanoProg.exe -Mode info
    CNanoProg.exe -Mode monitor -Baud 115200 -Stamp
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)] [string] $Hex = '',
    [Parameter(Position = 1)] [string] $Device = '',
    [ValidateSet('auto', 'pymcuprog', 'dragdrop', 'freeloader', 'reset', 'erase', 'read', 'info', 'monitor')]
    [string] $Mode = 'auto',
    [string] $Serial = '',
    [string] $Port = '',
    [int]    $Baud = 115200,
    [int]    $Monitor = 0,
    [string] $Out = '',
    [string] $Freeloader = '',
    [string] $FreeloaderArgs = '--verify',
    [string] $Pack = '',
    [switch] $NoVerify,
    [switch] $NoReset,
    [switch] $NoPause,
    [switch] $Stamp
)

$ErrorActionPreference = 'Stop'
$Version = '0.3'
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogDir = Join-Path $Here 'log'
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }
$LogFile = Join-Path $LogDir ('CNanoProg_' + (Get-Date -Format 'ddMMyyyy') + '.log')

function Log([string] $msg, [string] $color = 'Gray') {
    Write-Host $msg -ForegroundColor $color
    Add-Content -Path $LogFile -Value ((Get-Date -Format 'HH:mm:ss') + '  ' + $msg)
}
function Fail([string] $msg) {
    Log ('ERROR: ' + $msg) 'Red'
    if (-not $NoPause) { Write-Host ''; Read-Host 'Press Enter to close' | Out-Null }
    exit 1
}
function Done([string] $msg) {
    Log $msg 'Green'
    if (-not $NoPause) { Start-Sleep -Seconds 3 }
    exit 0
}

# ---------------------------------------------------------------- device name
function Normalize-Device([string] $d) {
    $d = $d.Trim().Trim('"').ToLowerInvariant()
    if ($d -eq '') { return '' }
    if ($d -notmatch '^pic') { $d = 'pic' + $d }
    return $d
}

# ---------------------------------------------------------------- hex file
function Resolve-Hex([string] $h) {
    $h = $h.Trim().Trim('"')
    if ($h -eq '') { return '' }
    $ext = [IO.Path]::GetExtension($h).ToLowerInvariant()
    if ($ext -ne '.hex') {
        $src = $h
        $h = [IO.Path]::ChangeExtension($h, '.hex')
        if ((Test-Path $src) -and (Test-Path $h)) {
            if ((Get-Item $h).LastWriteTime -lt (Get-Item $src).LastWriteTime) {
                Log ('WARNING: ' + [IO.Path]::GetFileName($h) + ' is older than the source - compile first?') 'Yellow'
            }
        }
    }
    if (-not (Test-Path $h)) { Fail ('hex file not found: ' + $h) }
    return (Resolve-Path $h).Path
}

function Test-HexFile([string] $h) {
    # every record: starts with ':', checksum ok, ends with an EOF record
    $n = 0; $eof = $false
    foreach ($line in [IO.File]::ReadAllLines($h)) {
        $l = $line.Trim()
        if ($l -eq '') { continue }
        if ($l[0] -ne ':') { return 'line ' + ($n + 1) + ' does not start with ":"' }
        $sum = 0
        for ($i = 1; $i -lt $l.Length; $i += 2) { $sum += [Convert]::ToInt32($l.Substring($i, 2), 16) }
        if (($sum -band 0xFF) -ne 0) { return 'checksum error on line ' + ($n + 1) }
        if ($l.Substring(7, 2) -eq '01') { $eof = $true }
        $n++
    }
    if (-not $eof) { return 'no end-of-file record' }
    return ''
}

# ---------------------------------------------------------------- kit discovery
function Get-Kits {
    $kits = @()
    foreach ($d in (Get-CimInstance Win32_LogicalDisk | Where-Object { $_.VolumeName -eq 'CURIOSITY' })) {
        $root = $d.DeviceID + '\'
        $info = Join-Path $root 'KIT-INFO.TXT'
        $k = [ordered]@{ Drive = $root; Name = ''; Serial = ''; Device = ''; Firmware = '' }
        if (Test-Path $info) {
            foreach ($line in (Get-Content $info)) {
                if ($line -match '^\s*Kit name:\s*(.+?)\s*$') { $k.Name = $Matches[1] }
                if ($line -match '^\s*Kit USB serial number:\s*(\S+)') { $k.Serial = $Matches[1] }
                if ($line -match '^\s*Device:\s*(\S+)') { $k.Device = $Matches[1].ToLowerInvariant() }
                if ($line -match '^\s*Debugger firmware:\s*(\S+)') { $k.Firmware = $Matches[1] }
            }
        }
        $kits += New-Object PSObject -Property $k
    }
    return , $kits
}

function Select-Kit([string] $dev) {
    $kits = Get-Kits
    if ($kits.Count -eq 0) { Fail 'no Curiosity Nano found (no drive called CURIOSITY). Is the kit plugged in?' }
    if ($Serial -ne '') {
        $kits = @($kits | Where-Object { $_.Serial -eq $Serial })
        if ($kits.Count -eq 0) { Fail ('no kit with serial ' + $Serial) }
    }
    if ($dev -ne '') {
        $match = @($kits | Where-Object { $_.Device -eq $dev })
        if ($match.Count -eq 0) {
            $found = ($kits | ForEach-Object { $_.Device + ' (' + $_.Serial + ')' }) -join ', '
            Fail ('the program is for ' + $dev + ' but the kit holds: ' + $found + '. Nothing was written.')
        }
        $kits = $match
    }
    if ($kits.Count -gt 1) { Fail ('more than one kit fits - give -Serial (' + (($kits | ForEach-Object { $_.Serial }) -join ', ') + ')') }
    return $kits[0]
}

# ---------------------------------------------------------------- pymcuprog + pack
function Find-Pymcuprog {
    $c = Get-Command pymcuprog -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
    return ''
}

function Find-PackScripts([string] $dev) {
    if ($Pack -ne '') {
        if (Test-Path $Pack) { return $Pack.TrimEnd('\', '/') }
        Fail ('pack path not found: ' + $Pack)
    }
    # cache: log\pack_<device>.txt holds the last path found (a full search takes ~5 s)
    $cache = Join-Path $LogDir ('pack_' + $dev + '.txt')
    if (Test-Path $cache) {
        $c = (Get-Content $cache -TotalCount 1).Trim()
        if ($c -ne '' -and (Test-Path (Join-Path $c ($dev + 'pds.py')))) { return $c }
    }
    $found = Search-PackScripts $dev
    if ($found -ne '') { Set-Content -Path $cache -Value $found }
    return $found
}

function Search-PackScripts([string] $dev) {
    $roots = @(Join-Path $env:USERPROFILE '.mchp_packs')
    foreach ($m in (Get-ChildItem 'C:\Program Files\Microchip\MPLABX' -Directory -ErrorAction SilentlyContinue)) {
        $roots += Join-Path $m.FullName 'packs'
    }
    $best = $null; $bestVer = [version]'0.0'
    foreach ($r in $roots) {
        if (-not (Test-Path $r)) { continue }
        foreach ($s in (Get-ChildItem -Path $r -Directory -Recurse -Depth 4 -Filter $dev -ErrorAction SilentlyContinue)) {
            if ($s.Parent.Name -ne 'scripts') { continue }
            $verText = $s.Parent.Parent.Name
            $v = $null
            if ([version]::TryParse($verText, [ref] $v) -and $v -gt $bestVer) { $bestVer = $v; $best = $s.FullName }
        }
    }
    if ($best) { return $best }
    return ''
}

function Run-Pymcuprog([string[]] $a) {
    Log ('> pymcuprog ' + ($a -join ' ')) 'DarkGray'
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'      # pymcuprog writes progress to stderr
    & $script:Pym @a 2>&1 | ForEach-Object { Log ('  ' + ($_ | Out-String).TrimEnd()) }
    $rc = $LASTEXITCODE
    $ErrorActionPreference = $old
    return $rc
}

function Pym-Base([object] $kit, [string] $dev, [string] $packDir) {
    return @('-t', 'nedbg', '-s', $kit.Serial, '-d', $dev, '-p', $packDir)
}

# ---------------------------------------------------------------- COM port
function Find-KitPort {
    if ($Port -ne '') { return $Port.ToUpperInvariant() }
    $ports = @(Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -match '^Curiosity Virtual COM Port \((COM\d+)\)' })
    if ($ports.Count -eq 0) { Fail 'no "Curiosity Virtual COM Port" found' }
    if ($ports.Count -gt 1) { Fail 'more than one Curiosity COM port - give -Port COMx' }
    [void]($ports[0].Name -match '\((COM\d+)\)')
    return $Matches[1]
}

function Run-Monitor([string] $com, [int] $seconds) {
    $mlog = Join-Path $LogDir ('monitor_' + (Get-Date -Format 'ddMMyyyy_HHmm') + '.txt')
    $how = 'until Esc'
    if ($seconds -gt 0) { $how = 'for ' + $seconds + ' s (Esc stops earlier)' }
    Log ('monitor ' + $com + ' ' + $Baud + ' 8N1, DTR on, ' + $how + ' - type to send, Enter = CR LF') 'Cyan'
    Log ('saving to ' + $mlog) 'DarkGray'
    $sp = New-Object System.IO.Ports.SerialPort $com, $Baud, 'None', 8, 'One'
    $sp.DtrEnable = $true          # the nEDBG CDC bridge only passes data while DTR is set
    $sp.RtsEnable = $false
    $sp.ReadTimeout = 50
    $sp.Encoding = [Text.Encoding]::GetEncoding(28591)    # bytes 1:1 (Latin-1)
    try { $sp.Open() } catch { Fail ('cannot open ' + $com + ': ' + $_.Exception.Message + ' (another program using it?)') }
    $end = (Get-Date).AddSeconds($seconds)
    $lineStart = $true
    $interactive = $true
    try { [void][Console]::KeyAvailable } catch { $interactive = $false }
    try {
        while ($true) {
            if ($seconds -gt 0 -and (Get-Date) -ge $end) { break }
            $s = $sp.ReadExisting()
            if ($s.Length -gt 0) {
                $outText = ''
                foreach ($ch in $s.ToCharArray()) {
                    if ($lineStart -and $Stamp -and $ch -ne "`n") { $outText += '[' + (Get-Date -Format 'HH:mm:ss.fff') + '] ' }
                    $lineStart = ($ch -eq "`n")
                    $outText += $ch
                }
                Write-Host -NoNewline $outText
                Add-Content -Path $mlog -Value $outText -NoNewline
            }
            if ($interactive) {
                while ([Console]::KeyAvailable) {
                    $k = [Console]::ReadKey($true)
                    if ($k.Key -eq 'Escape') { throw 'ESC' }
                    if ($k.Key -eq 'Enter') { $sp.Write("`r`n"); Write-Host ''; continue }
                    if ($k.KeyChar -ne [char]0) { $sp.Write([string]$k.KeyChar); Write-Host -NoNewline $k.KeyChar -ForegroundColor Yellow }
                }
            }
            Start-Sleep -Milliseconds 20
        }
    } catch {
        if ("$_" -ne 'ESC') { Log ('monitor stopped: ' + $_) 'Yellow' }
    } finally { $sp.Close() }
    Write-Host ''
    Log 'monitor closed' 'DarkGray'
}

function Reset-ByDrive([object] $kit) {
    # Curiosity Nano command file (kit user guide 3.1.3.2): content CMD:RESET, any name
    $f = Join-Path $kit.Drive 'reset.txt'
    [IO.File]::WriteAllText($f, 'CMD:RESET')
}

# ================================================================ main
$Device = Normalize-Device $Device
Log ('CNanoProg ' + $Version + '  mode=' + $Mode + '  device=' + $Device + '  hex=' + $Hex) 'Cyan'
$script:Pym = Find-Pymcuprog

switch ($Mode) {

    'info' {
        $kits = Get-Kits
        if ($kits.Count -eq 0) { Log 'no CURIOSITY drive found' 'Yellow' }
        foreach ($k in $kits) { Log ('kit ' + $k.Drive + '  ' + $k.Name + '  device=' + $k.Device + '  serial=' + $k.Serial + '  debugger fw=' + $k.Firmware) }
        foreach ($p in (Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -match 'Curiosity Virtual COM Port' })) { Log ('port ' + $p.Name) }
        if ($script:Pym) { Log ('pymcuprog: ' + $script:Pym) } else { Log 'pymcuprog: not found (drag-and-drop still works)' 'Yellow' }
        foreach ($k in $kits) {
            if ($k.Device -eq '') { continue }
            $pk = Find-PackScripts $k.Device
            if ($pk) { Log ('pack: ' + $pk) } else { Log ('pack for ' + $k.Device + ': not found') 'Yellow' }
            if ($script:Pym -and $pk) { [void](Run-Pymcuprog ((@('ping') + (Pym-Base $k $k.Device $pk)))) }
        }
        Done 'info done'
    }

    'monitor' {
        $com = Find-KitPort
        Run-Monitor $com $Monitor
        Done 'monitor done'
    }
}

$kit = Select-Kit $Device
if ($Device -eq '') { $Device = $kit.Device }
Log ('kit: ' + $kit.Name + '  ' + $kit.Drive + '  serial ' + $kit.Serial + '  device ' + $kit.Device) 'Cyan'

$packDir = ''
if ($script:Pym) { $packDir = Find-PackScripts $Device }
$canPym = ($script:Pym -ne '') -and ($packDir -ne '')
if ($canPym) { Log ('pack: ' + $packDir) 'DarkGray' }

if ($Mode -eq 'auto') {
    if ($canPym) { $Mode = 'pymcuprog' } else { $Mode = 'dragdrop'; Log 'pymcuprog or pack not found - using drag-and-drop' 'Yellow' }
}

switch ($Mode) {

    'reset' {
        if ($canPym) { $rc = Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir))) }
        else { Reset-ByDrive $kit; $rc = 0 }
        if ($rc -ne 0) { Fail 'reset failed' }
        Done 'target reset - application running'
    }

    'erase' {
        if (-not $canPym) { Fail 'erase needs pymcuprog and the device pack' }
        if ((Run-Pymcuprog ((@('erase') + (Pym-Base $kit $Device $packDir)))) -ne 0) { Fail 'erase failed' }
        Done 'chip erased'
    }

    'read' {
        if (-not $canPym) { Fail 'read needs pymcuprog and the device pack' }
        if ($Out -eq '') { $Out = Join-Path $LogDir ($Device + '_READ_' + (Get-Date -Format 'ddMMyyyy_HHmm') + '.hex') }
        if ((Run-Pymcuprog ((@('read') + (Pym-Base $kit $Device $packDir) + @('-f', $Out)))) -ne 0) { Fail 'read failed' }
        Done ('chip read into ' + $Out)
    }
}

# ---- the modes below all need a hex file
$Hex = Resolve-Hex $Hex
if ($Hex -eq '') { Fail 'no hex file given' }
$bad = Test-HexFile $Hex
if ($bad -ne '') { Fail ('hex file is damaged: ' + $bad) }
Log ('hex: ' + $Hex + '  (' + (Get-Item $Hex).Length + ' bytes, ' + (Get-Item $Hex).LastWriteTime + ')') 'DarkGray'

switch ($Mode) {

    'pymcuprog' {
        if (-not $canPym) { Fail 'pymcuprog or the device pack not found' }
        $a = @('write') + (Pym-Base $kit $Device $packDir) + @('-f', $Hex, '--erase')
        if (-not $NoVerify) { $a += '--verify' }
        $t0 = Get-Date
        if ((Run-Pymcuprog $a) -ne 0) { Fail 'programming failed' }
        if ((Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir)))) -ne 0) { Fail 'reset after programming failed' }
        $dt = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
        if ($Monitor -gt 0) { Run-Monitor (Find-KitPort) $Monitor }
        Done ('programmed and verified in ' + $dt + ' s - application running')
    }

    'dragdrop' {
        $t0 = Get-Date
        Copy-Item -Path $Hex -Destination $kit.Drive -Force
        Log ('copied to ' + $kit.Drive + ' - the kit programs the part (PS LED: slow blink = ok, fast = fail)')
        Start-Sleep -Seconds 4
        if ($canPym -and -not $NoVerify) {
            if ((Run-Pymcuprog ((@('verify') + (Pym-Base $kit $Device $packDir) + @('-f', $Hex)))) -ne 0) { Fail 'verify after drag-and-drop failed' }
            [void](Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir))))
            $dt = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
            if ($Monitor -gt 0) { Run-Monitor (Find-KitPort) $Monitor }
            Done ('drag-and-drop programmed and verified in ' + $dt + ' s')
        }
        if ($Monitor -gt 0) { Run-Monitor (Find-KitPort) $Monitor }
        Done 'drag-and-drop done (not verified: STATUS.TXT is cached by Windows; watch the PS LED)'
    }

    'freeloader' {
        if ($Freeloader -eq '') {
            foreach ($c in @((Join-Path $Here 'FREELOADER.exe'),
                             'C:\FREELOADER Free PIC18 bootloader and uploader__by Jon Walker\Built in APP\FREELOADER.exe')) {
                if (Test-Path $c) { $Freeloader = $c; break }
            }
            if ($Freeloader -eq '') { $g = Get-Command FREELOADER.exe -ErrorAction SilentlyContinue; if ($g) { $Freeloader = $g.Source } }
        }
        if (($Freeloader -eq '') -or -not (Test-Path $Freeloader)) { Fail 'FREELOADER.exe not found - give -Freeloader <path>' }
        $com = Find-KitPort
        $fa = '"' + $Hex + '" ' + $com
        if ($FreeloaderArgs -ne '') { $fa += ' ' + $FreeloaderArgs }
        Log ('> FREELOADER ' + $fa) 'DarkGray'
        # FREELOADER's output goes to a file we watch: reset the target ONLY when it asks
        # ("Reset the board now"), never while a blank part is already being written.
        $fo = Join-Path $LogDir 'freeloader_out.txt'
        $fe = Join-Path $LogDir 'freeloader_err.txt'
        $p = Start-Process -FilePath $Freeloader -ArgumentList $fa -NoNewWindow -PassThru `
                           -RedirectStandardOutput $fo -RedirectStandardError $fe
        $shown = 0; $resetDone = $false; $t0 = Get-Date
        while (-not $p.HasExited) {
            Start-Sleep -Milliseconds 100
            $txt = ''
            try { $txt = [IO.File]::ReadAllText($fo) } catch { }
            if ($txt.Length -gt $shown) { Write-Host -NoNewline $txt.Substring($shown); $shown = $txt.Length }
            $ask = ($txt -match 'Reset the board now')
            # output may be buffered: with nothing printed after 2.5 s, assume it is waiting
            $quiet = ($txt.Length -eq 0) -and (((Get-Date) - $t0).TotalSeconds -gt 2.5)
            if ((-not $resetDone) -and (-not $NoReset) -and ($ask -or $quiet)) {
                if ($canPym) { [void](Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir)))) }
                else { Reset-ByDrive $kit }
                Log 'target reset by the kit debugger' 'DarkGray'
                $resetDone = $true
            }
            if (((Get-Date) - $t0).TotalSeconds -gt 120) { $p.Kill(); Fail 'FREELOADER did not finish in 2 minutes' }
        }
        $p.WaitForExit()
        $txt = [IO.File]::ReadAllText($fo) + [IO.File]::ReadAllText($fe)
        if ($txt.Length -gt $shown) { Write-Host $txt.Substring($shown) }
        Add-Content -Path $LogFile -Value $txt
        if ($p.ExitCode -ne 0) { Fail ('FREELOADER exit code ' + $p.ExitCode) }
        if ($Monitor -gt 0) { Run-Monitor $com $Monitor }
        Done 'uploaded through the bootloader'
    }
}
