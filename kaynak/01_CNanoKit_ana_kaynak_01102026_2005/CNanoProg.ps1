<#
  CNanoProg 0.4 - program a Microchip PIC18F56Q71 Curiosity Nano kit from Positron
  (Positron Studio, VS Code Positron extension, Proton IDE plugin) or the command line.
  CNanoProg 0.4 - Microchip PIC18F56Q71 Curiosity Nano kitini Positron'dan programlar.

  Freeware licence (LICENSE.txt).  No warranty.  okmn, 2026.

  Modes / Kipler
    auto        pymcuprog (erase + write + verify + reset) if found, else drag-and-drop
    pymcuprog   through Microchip pymcuprog (Python + pymcuprog + device pack)
    dragdrop    copy the hex to the kit's CURIOSITY drive (nothing else needed)
    reset       reset the target (the program starts)
    erase       chip erase (pymcuprog)
    read        read the whole chip into a hex file (pymcuprog)
    info        kit, debugger, port, pack and tool information
    monitor     two-way serial terminal in this window (Esc quits)
    freeloader  upload through Jon Walker's mwboot bootloader with FREELOADER.exe
                (needs a FREELOADER that keeps DTR on - see README)

  Language / Dil:  -Lang tr | en | auto (default: Windows language, or settings.ini)

  Examples / Ornekler
    CNanoProg.exe "C:\work\BLINK.hex" 18F56Q71
    CNanoProg.exe "C:\work\BLINK.hex" 18F56Q71 -Mode dragdrop
    CNanoProg.exe -Mode monitor -Baud 115200 -Stamp
    CNanoProg.exe -Mode info -Lang en
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)] [string] $Hex = '',
    [Parameter(Position = 1)] [string] $Device = '',
    [ValidateSet('auto', 'pymcuprog', 'dragdrop', 'freeloader', 'reset', 'erase', 'read', 'info', 'monitor')]
    [string] $Mode = 'auto',
    [ValidateSet('auto', 'tr', 'en')] [string] $Lang = 'auto',
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
$Version = '0.5'
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogDir = Join-Path $Here 'log'
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }
$LogFile = Join-Path $LogDir ('CNanoProg_' + (Get-Date -Format 'ddMMyyyy') + '.log')

# ---------------------------------------------------------------- language
if ($Lang -eq 'auto') {
    $ini = Join-Path $Here 'settings.ini'
    if (Test-Path $ini) { foreach ($l in Get-Content $ini) { if ($l -match '^\s*Lang\s*=\s*(tr|en)\s*$') { $Lang = $Matches[1] } } }
}
if ($Lang -eq 'auto') { if ((Get-Culture).TwoLetterISOLanguageName -eq 'tr') { $Lang = 'tr' } else { $Lang = 'en' } }
$script:LangIsTr = ($Lang -eq 'tr')
function M([string] $enText, [string] $trText) { if ($script:LangIsTr) { return $trText } else { return $enText } }

function Log([string] $msg, [string] $color = 'Gray') {
    if ($env:USERPROFILE) { $msg = $msg.Replace($env:USERPROFILE, '%USERPROFILE%') }   # never show the user name on screen / in logs
    Write-Host $msg -ForegroundColor $color
    Add-Content -Path $LogFile -Value ((Get-Date -Format 'HH:mm:ss') + '  ' + $msg) -Encoding UTF8
}
function Fail([string] $msg) {
    Log ((M 'ERROR: ' 'HATA: ') + $msg) 'Red'
    if (-not $NoPause) { Write-Host ''; Read-Host (M 'Press Enter to close' 'Kapatmak icin Enter') | Out-Null }
    exit 1
}
function Done([string] $msg) {
    Log $msg 'Green'
    if (-not $NoPause) { Start-Sleep -Seconds 3 }
    exit 0
}

# ---------------------------------------------------------------- device name
function Normalize-Device([string] $d) {
    $d = $d.Trim().Trim('"').ToLowerInvariant()           # Invariant: Turkish "I" -> "i", never "ı"
    if ($d -eq '') { return '' }
    if ($d -notmatch '^pic') { $d = 'pic' + $d }
    return $d
}

# ---------------------------------------------------------------- hex file
function Resolve-Hex([string] $h) {
    $h = $h.Trim().Trim('"')
    if ($h -eq '') { return '' }
    $ext = [IO.Path]::GetExtension($h).ToLowerInvariant()
    if ($ext -ne '.hex') { $h = [IO.Path]::ChangeExtension($h, '.hex') }
    if (-not (Test-Path $h)) { Fail ((M 'hex file not found: ' 'hex dosyasi bulunamadi: ') + $h) }
    $bas = [IO.Path]::ChangeExtension($h, '.bas')
    if ((Test-Path $bas) -and ((Get-Item $h).LastWriteTime -lt (Get-Item $bas).LastWriteTime)) {
        Log (M ('WARNING: ' + [IO.Path]::GetFileName($h) + ' is older than the .bas - compile first?') ('UYARI: ' + [IO.Path]::GetFileName($h) + ' .bas dosyasindan eski - once derlediniz mi?')) 'Yellow'
    }
    return (Resolve-Path $h).Path
}

function Test-HexFile([string] $h) {
    $n = 0; $eof = $false
    foreach ($line in [IO.File]::ReadAllLines($h)) {
        $l = $line.Trim()
        if ($l -eq '') { continue }
        if ($l[0] -ne ':') { return (M 'line ' 'satir ') + ($n + 1) + (M ' does not start with ":"' ' ":" ile baslamiyor') }
        $sum = 0
        for ($i = 1; $i -lt $l.Length; $i += 2) { $sum += [Convert]::ToInt32($l.Substring($i, 2), 16) }
        if (($sum -band 0xFF) -ne 0) { return (M 'checksum error on line ' 'saglama hatasi, satir ') + ($n + 1) }
        if ($l.Substring(7, 2) -eq '01') { $eof = $true }
        $n++
    }
    if (-not $eof) { return (M 'no end-of-file record' 'dosya sonu kaydi yok') }
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
    if ($kits.Count -eq 0) { Fail (M 'no Curiosity Nano found (no drive called CURIOSITY). Is the kit plugged in?' 'Curiosity Nano bulunamadi (CURIOSITY adli surucu yok). Kit USB ile takili mi?') }
    if ($Serial -ne '') {
        $kits = @($kits | Where-Object { $_.Serial -eq $Serial })
        if ($kits.Count -eq 0) { Fail ((M 'no kit with serial ' 'bu seri numarali kit yok: ') + $Serial) }
    }
    if ($dev -ne '') {
        $match = @($kits | Where-Object { $_.Device -eq $dev })
        if ($match.Count -eq 0) {
            $found = ($kits | ForEach-Object { $_.Device + ' (' + $_.Serial + ')' }) -join ', '
            Fail (M ('the program is for ' + $dev + ' but the kit holds: ' + $found + '. Nothing was written.') ('program ' + $dev + ' icin, ama kitteki islemci: ' + $found + '. Hicbir sey yazilmadi.'))
        }
        $kits = $match
    }
    if ($kits.Count -gt 1) { Fail ((M 'more than one kit fits - give -Serial ' 'birden fazla kit uyuyor - -Serial verin ') + '(' + (($kits | ForEach-Object { $_.Serial }) -join ', ') + ')') }
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
        Fail ((M 'pack path not found: ' 'paket yolu bulunamadi: ') + $Pack)
    }
    $cache = Join-Path $LogDir ('pack_' + $dev + '.txt')            # a full search takes ~5 s
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
            $v = $null
            if ([version]::TryParse($s.Parent.Parent.Name, [ref] $v) -and $v -gt $bestVer) { $bestVer = $v; $best = $s.FullName }
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

# ---------------------------------------------------------------- COM port + monitor
function Find-KitPort {
    if ($Port -ne '') { return $Port.ToUpperInvariant() }
    # Microchip driver name, or the Windows built-in CDC driver name (no MPLAB installed)
    $ports = @(Get-CimInstance Win32_PnPEntity | Where-Object {
        ($_.Name -match '\((COM\d+)\)') -and (($_.Name -match 'Curiosity') -or ($_.PNPDeviceID -match 'VID_03EB&PID_2175')) })
    if ($ports.Count -eq 0) { Fail (M 'no Curiosity Nano COM port found' 'Curiosity Nano COM portu bulunamadi') }
    if ($ports.Count -gt 1) { Fail (M 'more than one Curiosity COM port - give -Port COMx' 'birden fazla Curiosity COM portu - -Port COMx verin') }
    return [regex]::Match($ports[0].Name, '\((COM\d+)\)').Groups[1].Value
}

function Run-Monitor([string] $com, [int] $seconds) {
    $mlog = Join-Path $LogDir ('monitor_' + (Get-Date -Format 'ddMMyyyy_HHmm') + '.txt')
    $how = M 'until Esc' 'Esc tusuna kadar'
    if ($seconds -gt 0) { $how = M ('for ' + $seconds + ' s (Esc stops earlier)') ($seconds.ToString() + ' sn (Esc ile erken biter)') }
    Log ((M 'monitor ' 'monitor ') + $com + ' ' + $Baud + ' 8N1, DTR on, ' + $how + (M ' - type to send, Enter = CR LF' ' - yazdiginiz gider, Enter = CR LF')) 'Cyan'
    Log ((M 'saving to ' 'kayit: ') + $mlog) 'DarkGray'
    $sp = New-Object System.IO.Ports.SerialPort $com, $Baud, 'None', 8, 'One'
    $sp.DtrEnable = $true          # the kit's USB-serial bridge passes data only while DTR is on
    $sp.RtsEnable = $false
    $sp.ReadTimeout = 50
    $sp.Encoding = [Text.Encoding]::GetEncoding(28591)
    try { $sp.Open() } catch { Fail ((M 'cannot open ' 'acilamadi: ') + $com + ': ' + $_.Exception.Message + (M ' (another program using it?)' ' (baska bir program mi kullaniyor?)')) }
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
        if ("$_" -ne 'ESC') { Log ((M 'monitor stopped: ' 'monitor durdu: ') + $_) 'Yellow' }
    } finally { $sp.Close() }
    Write-Host ''
    Log (M 'monitor closed' 'monitor kapandi') 'DarkGray'
}

function Reset-ByDrive([object] $kit) {
    # kit user guide DS50003481A 3.1.3.2: a text file with CMD:RESET on the CURIOSITY drive
    [IO.File]::WriteAllText((Join-Path $kit.Drive 'reset.txt'), 'CMD:RESET')
}

# ================================================================ main
$Device = Normalize-Device $Device
if ($Mode -eq 'auto' -and $Hex -eq '') {
    # started with no hex file (e.g. double-clicked): say how it is used, then show the kit information
    Log (M 'CNanoProg is normally started by your IDE (Positron Studio F10, Proton IDE plugin button, VS Code Ctrl+Alt+P).' 'CNanoProg normalde IDE tarafindan calistirilir (Positron Studio F10, Proton IDE eklenti dugmesi, VS Code Ctrl+Alt+P).') 'Yellow'
    Log (M 'Command line: CNanoProg.exe "C:\work\BLINK.hex" 18F56Q71   (more: docs\INSTALL_EN_*.md, section 5.4)' 'Komut satiri: CNanoProg.exe "C:\is\BLINK.hex" 18F56Q71   (fazlasi: docs\KURULUM_TR_*.md, bolum 5.4)') 'Yellow'
    Log (M 'No hex file given - showing the kit information instead:' 'Hex dosyasi verilmedi - onun yerine kit bilgisi gosteriliyor:') 'Yellow'
    $Mode = 'info'
}
Log ('CNanoProg ' + $Version + '  mode=' + $Mode + '  device=' + $Device + '  hex=' + $Hex + '  lang=' + $Lang) 'Cyan'
$script:Pym = Find-Pymcuprog

switch ($Mode) {
    'info' {
        $kits = Get-Kits
        if ($kits.Count -eq 0) { Log (M 'no CURIOSITY drive found' 'CURIOSITY surucusu bulunamadi') 'Yellow' }
        foreach ($k in $kits) { Log ('kit ' + $k.Drive + '  ' + $k.Name + '  device=' + $k.Device + '  serial=' + $k.Serial + '  debugger fw=' + $k.Firmware) }
        foreach ($p in (Get-CimInstance Win32_PnPEntity | Where-Object { $_.PNPDeviceID -match 'VID_03EB&PID_2175' -and $_.Name -match 'COM\d' })) { Log ('port ' + $p.Name) }
        if ($script:Pym) { Log ('pymcuprog: ' + $script:Pym) } else { Log (M 'pymcuprog: not found (drag-and-drop still works)' 'pymcuprog: bulunamadi (surukle-birak yine calisir)') 'Yellow' }
        foreach ($k in $kits) {
            if ($k.Device -eq '') { continue }
            $pk = Find-PackScripts $k.Device
            if ($pk) { Log ((M 'pack: ' 'paket: ') + $pk) } else { Log ((M 'pack not found for ' 'paket bulunamadi: ') + $k.Device) 'Yellow' }
            if ($script:Pym -and $pk) { [void](Run-Pymcuprog ((@('ping') + (Pym-Base $k $k.Device $pk)))) }
        }
        Done (M 'info done' 'bilgi tamam')
    }
    'monitor' {
        Run-Monitor (Find-KitPort) $Monitor
        Done (M 'monitor done' 'monitor bitti')
    }
}

$kit = Select-Kit $Device
if ($Device -eq '') { $Device = $kit.Device }
Log ('kit: ' + $kit.Name + '  ' + $kit.Drive + '  serial ' + $kit.Serial + '  device ' + $kit.Device) 'Cyan'

$packDir = ''
if ($script:Pym) { $packDir = Find-PackScripts $Device }
$canPym = ($script:Pym -ne '') -and ($packDir -ne '')
if ($canPym) { Log ((M 'pack: ' 'paket: ') + $packDir) 'DarkGray' }

if ($Mode -eq 'auto') {
    if ($canPym) { $Mode = 'pymcuprog' } else { $Mode = 'dragdrop'; Log (M 'pymcuprog or pack not found - using drag-and-drop' 'pymcuprog veya paket yok - surukle-birak kullaniliyor') 'Yellow' }
}

switch ($Mode) {
    'reset' {
        if ($canPym) { $rc = Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir))) } else { Reset-ByDrive $kit; $rc = 0 }
        if ($rc -ne 0) { Fail (M 'reset failed' 'reset basarisiz') }
        Done (M 'target reset - program running' 'islemci resetlendi - program calisiyor')
    }
    'erase' {
        if (-not $canPym) { Fail (M 'erase needs pymcuprog and the device pack' 'silme icin pymcuprog ve paket gerekli') }
        if ((Run-Pymcuprog ((@('erase') + (Pym-Base $kit $Device $packDir)))) -ne 0) { Fail (M 'erase failed' 'silme basarisiz') }
        Done (M 'chip erased' 'islemci silindi')
    }
    'read' {
        if (-not $canPym) { Fail (M 'read needs pymcuprog and the device pack' 'okuma icin pymcuprog ve paket gerekli') }
        if ($Out -eq '') { $Out = Join-Path $LogDir ($Device + '_READ_' + (Get-Date -Format 'ddMMyyyy_HHmm') + '.hex') }
        if ((Run-Pymcuprog ((@('read') + (Pym-Base $kit $Device $packDir) + @('-f', $Out)))) -ne 0) { Fail (M 'read failed' 'okuma basarisiz') }
        Done ((M 'chip read into ' 'islemci okundu: ') + $Out)
    }
}

# ---- the modes below need a hex file
$Hex = Resolve-Hex $Hex
if ($Hex -eq '') { Fail (M 'no hex file given' 'hex dosyasi verilmedi') }
$bad = Test-HexFile $Hex
if ($bad -ne '') { Fail ((M 'hex file is damaged: ' 'hex dosyasi bozuk: ') + $bad) }
Log ('hex: ' + $Hex + '  (' + (Get-Item $Hex).Length + ' bytes, ' + (Get-Item $Hex).LastWriteTime + ')') 'DarkGray'

switch ($Mode) {
    'pymcuprog' {
        if (-not $canPym) { Fail (M 'pymcuprog or the device pack not found' 'pymcuprog veya paket bulunamadi') }
        $a = @('write') + (Pym-Base $kit $Device $packDir) + @('-f', $Hex, '--erase')
        if (-not $NoVerify) { $a += '--verify' }
        $t0 = Get-Date
        if ((Run-Pymcuprog $a) -ne 0) { Fail (M 'programming failed' 'programlama basarisiz') }
        if ((Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir)))) -ne 0) { Fail (M 'reset after programming failed' 'programlamadan sonra reset basarisiz') }
        $dt = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
        if ($Monitor -gt 0) { Run-Monitor (Find-KitPort) $Monitor }
        Done (M ('programmed and verified in ' + $dt + ' s - program running') ('programlandi ve dogrulandi, ' + $dt + ' sn - program calisiyor'))
    }
    'dragdrop' {
        $t0 = Get-Date
        Copy-Item -Path $Hex -Destination $kit.Drive -Force
        Log (M ('copied to ' + $kit.Drive + ' - the kit programs the PIC (PS LED: slow blink = ok, fast = fail)') ($kit.Drive + ' surucusune kopyalandi - kit PIC''i programliyor (PS LED: yavas = tamam, hizli = hata)'))
        Start-Sleep -Seconds 4
        if ($canPym -and -not $NoVerify) {
            if ((Run-Pymcuprog ((@('verify') + (Pym-Base $kit $Device $packDir) + @('-f', $Hex)))) -ne 0) { Fail (M 'verify after drag-and-drop failed' 'surukle-birak sonrasi dogrulama basarisiz') }
            [void](Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir))))
            $dt = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
            if ($Monitor -gt 0) { Run-Monitor (Find-KitPort) $Monitor }
            Done (M ('drag-and-drop programmed and verified in ' + $dt + ' s') ('surukle-birak ile programlandi ve dogrulandi, ' + $dt + ' sn'))
        }
        if ($Monitor -gt 0) { Run-Monitor (Find-KitPort) $Monitor }
        Done (M 'drag-and-drop done (not verified; watch the PS LED)' 'surukle-birak bitti (dogrulanmadi; PS LED''e bakin)')
    }
    'freeloader' {
        if ($Freeloader -eq '') {
            $c = Join-Path $Here 'FREELOADER.exe'
            if (Test-Path $c) { $Freeloader = $c }
            else { $g = Get-Command FREELOADER.exe -ErrorAction SilentlyContinue; if ($g) { $Freeloader = $g.Source } }
        }
        if (($Freeloader -eq '') -or -not (Test-Path $Freeloader)) { Fail (M 'FREELOADER.exe not found - put it next to CNanoProg.exe or give -Freeloader <path>' 'FREELOADER.exe bulunamadi - CNanoProg.exe yanina koyun veya -Freeloader <yol> verin') }
        Log (M 'NOTE: the kit''s USB-serial bridge passes data only while DTR is ON. FREELOADER 1.1 opens the port with DTR off and cannot reach the bootloader on this kit (tested 01 Oct 2026).' 'NOT: kitin USB-seri koprusu yalniz DTR ACIKKEN veri gecirir. FREELOADER 1.1 portu DTR kapali acar ve bu kitte bootloader''a ulasamaz (01.10.2026 test).') 'Yellow'
        $com = Find-KitPort
        $fa = '"' + $Hex + '" ' + $com
        if ($FreeloaderArgs -ne '') { $fa += ' ' + $FreeloaderArgs }
        Log ('> FREELOADER ' + $fa) 'DarkGray'
        $fo = Join-Path $LogDir 'freeloader_out.txt'
        $fe = Join-Path $LogDir 'freeloader_err.txt'
        $p = Start-Process -FilePath $Freeloader -ArgumentList $fa -NoNewWindow -PassThru -RedirectStandardOutput $fo -RedirectStandardError $fe
        $shown = 0; $resetDone = $false; $t0 = Get-Date
        while (-not $p.HasExited) {
            Start-Sleep -Milliseconds 100
            $txt = ''
            try { $txt = [IO.File]::ReadAllText($fo) } catch { }
            if ($txt.Length -gt $shown) { Write-Host -NoNewline $txt.Substring($shown); $shown = $txt.Length }
            $ask = ($txt -match 'Reset the board now')
            $quiet = ($txt.Length -eq 0) -and (((Get-Date) - $t0).TotalSeconds -gt 2.5)
            if ((-not $resetDone) -and (-not $NoReset) -and ($ask -or $quiet)) {
                if ($canPym) { [void](Run-Pymcuprog ((@('reset') + (Pym-Base $kit $Device $packDir)))) } else { Reset-ByDrive $kit }
                Log (M 'target reset by the kit debugger' 'islemci kitin debugger''i ile resetlendi') 'DarkGray'
                $resetDone = $true
            }
            if (((Get-Date) - $t0).TotalSeconds -gt 60) { $p.Kill(); Fail (M 'FREELOADER did not finish in 60 s (see the NOTE above)' 'FREELOADER 60 sn icinde bitmedi (yukaridaki NOT''a bakin)') }
        }
        $p.WaitForExit()
        $txt = [IO.File]::ReadAllText($fo) + [IO.File]::ReadAllText($fe)
        if ($txt.Length -gt $shown) { Write-Host $txt.Substring($shown) }
        Add-Content -Path $LogFile -Value $txt
        if ($p.ExitCode -ne 0) { Fail ((M 'FREELOADER exit code ' 'FREELOADER cikis kodu ') + $p.ExitCode) }
        if ($Monitor -gt 0) { Run-Monitor $com $Monitor }
        Done (M 'uploaded through the bootloader' 'bootloader ile yuklendi')
    }
}
