<#
  CNano Monitor 0.6 - serial monitor window for the PIC Curiosity Nano kits
  (the simple "debug" view: print from your Positron program over the kit's USB COM port,
  read it here; type text or HEX bytes here, the PIC receives them).  Turkish / English UI.
  CNano Monitor 0.6 - Curiosity Nano kitleri için seri monitör penceresi (Türkçe / İngilizce).

  Nothing connects by itself: choose the port, baud and format, then press Connect.
  Hiçbir şey kendiliğinden bağlanmaz: portu, hızı ve biçimi seçin, sonra Bağlan'a basın.

  MIT licence.  No warranty.  okmn, 2026.
#>
param(
    [ValidateSet('auto', 'tr', 'en')] [string] $Lang = 'auto',
    [string] $Port = '',
    [int]    $Baud = 0,
    [switch] $Connect          # optional: connect at start (only when asked for)
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogDir = Join-Path $Here 'log'
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }
$IniFile = Join-Path $Here 'settings.ini'

# ---------------------------------------------------------------- settings
$S = @{ Lang = 'auto'; Baud = '115200'; Port = ''; Stamp = '1'; Dtr = '1'; Rts = '0'; Eol = '3'
        DataBits = '8'; Parity = '0'; StopBits = '0'; View = '0'; SendMode = '0'
        Q1 = 'okmn'; Q2 = 'HEX:53'; Q3 = 'come'; Q4 = 'stop' }
if (Test-Path $IniFile) { foreach ($l in Get-Content $IniFile) { if ($l -match '^\s*(\w+)\s*=\s*(.*?)\s*$') { $S[$Matches[1]] = $Matches[2] } } }
if ($Lang -ne 'auto') { $S.Lang = $Lang }
if ($S.Lang -eq 'auto') { if ((Get-Culture).TwoLetterISOLanguageName -eq 'tr') { $S.Lang = 'tr' } else { $S.Lang = 'en' } }
if ($Baud -gt 0) { $S.Baud = [string]$Baud }
if ($Port -ne '') { $S.Port = $Port }
function Save-Settings { try { $S.GetEnumerator() | Sort-Object Name | ForEach-Object { $_.Name + '=' + $_.Value } | Set-Content $IniFile } catch { } }
function SelIdx([string] $v, [int] $max) { $i = 0; [void][int]::TryParse($v, [ref]$i); if ($i -lt 0 -or $i -gt $max) { $i = 0 }; return $i }

$TXT = @{
  title    = @{ tr = 'CNano Monitör — Curiosity Nano seri monitör'; en = 'CNano Monitor — Curiosity Nano serial monitor' }
  gConn    = @{ tr = 'Bağlantı'; en = 'Connection' }
  gView    = @{ tr = 'Görünüm'; en = 'View' }
  port     = @{ tr = 'Port:'; en = 'Port:' }
  baud     = @{ tr = 'Hız (baud):'; en = 'Baud:' }
  data     = @{ tr = 'Veri biti:'; en = 'Data bits:' }
  parity   = @{ tr = 'Eşlik:'; en = 'Parity:' }
  parnames = @{ tr = @('Yok', 'Tek', 'Çift'); en = @('None', 'Odd', 'Even') }
  stop     = @{ tr = 'Dur biti:'; en = 'Stop bits:' }
  connect  = @{ tr = 'Bağlan'; en = 'Connect' }
  disconn  = @{ tr = 'Bağlantıyı kes'; en = 'Disconnect' }
  refresh  = @{ tr = 'Portları tara'; en = 'Scan ports' }
  dtr      = @{ tr = 'DTR açık (kit için gerekli)'; en = 'DTR on (needed by the kit)' }
  rts      = @{ tr = 'RTS açık'; en = 'RTS on' }
  show     = @{ tr = 'Gelen veri:'; en = 'Received data:' }
  viewnames= @{ tr = @('Metin', 'HEX', 'Metin + HEX'); en = @('Text', 'HEX', 'Text + HEX') }
  stamp    = @{ tr = 'Zaman damgası'; en = 'Time stamp' }
  clear    = @{ tr = 'Temizle'; en = 'Clear' }
  save     = @{ tr = 'Kaydet...'; en = 'Save...' }
  reset    = @{ tr = 'PIC''i resetle'; en = 'Reset PIC' }
  send     = @{ tr = 'Gönder'; en = 'Send' }
  sendas   = @{ tr = 'Gönderme biçimi:'; en = 'Send as:' }
  sendnames= @{ tr = @('Metin', 'HEX baytlar'); en = @('Text', 'HEX bytes') }
  eol      = @{ tr = 'Satır sonu:'; en = 'Line end:' }
  eolnames = @{ tr = @('Yok', 'CR', 'LF', 'CR+LF'); en = @('None', 'CR', 'LF', 'CR+LF') }
  lang     = @{ tr = 'Dil:'; en = 'Language:' }
  st_off   = @{ tr = 'Bağlı değil — portu ve ayarları seçin, sonra Bağlan''a basın'; en = 'Not connected — choose the port and settings, then press Connect' }
  st_on    = @{ tr = 'Bağlı'; en = 'Connected' }
  st_lost  = @{ tr = 'Bağlantı koptu (kit çıkarıldı mı?)'; en = 'Connection lost (kit unplugged?)' }
  noport   = @{ tr = 'Hiç seri port bulunamadı. Kit USB ile takılı mı? Takıp "Portları tara"ya basın.'; en = 'No serial port found. Is the kit plugged in? Plug it in and press "Scan ports".' }
  badbaud  = @{ tr = 'Geçersiz hız. 1200 ile 500000 arasında bir sayı yazın (kitin USB-seri köprüsünün sınırı).'; en = 'Invalid baud. Type a number from 1200 to 500000 (the kit''s USB-serial bridge limit).' }
  badhex   = @{ tr = 'HEX biçimi hatalı. Örnek: 55 AA 0D 0A  veya  0x55,0xAA  veya  55AA0D0A'; en = 'Bad HEX. Example: 55 AA 0D 0A  or  0x55,0xAA  or  55AA0D0A' }
  openfail = @{ tr = 'Port açılamadı (başka bir program mı kullanıyor?):'; en = 'Cannot open the port (used by another program?):' }
  resetrun = @{ tr = 'PIC resetleniyor...'; en = 'Resetting the PIC...' }
  found    = @{ tr = 'Curiosity kitinin portu seçildi:'; en = 'Curiosity kit port selected:' }
  nokit    = @{ tr = 'Curiosity kiti bulunamadı; listeden portu kendiniz seçin.'; en = 'No Curiosity kit found; choose the port yourself.' }
  rx       = @{ tr = 'Alınan'; en = 'Received' }
  tx       = @{ tr = 'Gönderilen'; en = 'Sent' }
  logto    = @{ tr = 'Kayıt dosyası:'; en = 'Log file:' }
  quick    = @{ tr = 'Hızlı gönder:'; en = 'Quick send:' }
  quicktip = @{ tr = 'Tıkla = gönder.  Shift + tıkla = düğmeyi değiştir.  HEX için başına HEX: yazın (örn. HEX:53 0D)'; en = 'Click = send.  Shift + click = edit the button.  For HEX start with HEX: (e.g. HEX:53 0D)' }
  quickask = @{ tr = 'Bu düğme ne göndersin? Metin (ör. okmn) ya da HEX:53 0D gibi'; en = 'What should this button send? Text (e.g. okmn) or like HEX:53 0D' }
  hint     = @{ tr = 'PIC18F56Q71 kitinde USB-seri hattı: UART2, RB4 = TX, RB5 = RX (kablo gerekmez).'; en = 'PIC18F56Q71 kit USB-serial line: UART2, RB4 = TX, RB5 = RX (no wires needed).' }
}
function T([string] $k) { return $TXT[$k][$S.Lang] }

# ---------------------------------------------------------------- ports
function Get-PortList {
    $list = @()
    foreach ($p in (Get-CimInstance Win32_PnPEntity -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '\((COM\d+)\)' })) {
        $com = [regex]::Match($p.Name, '\((COM\d+)\)').Groups[1].Value
        $isKit = ($p.Name -like '*Curiosity*') -or ($p.PNPDeviceID -like '*VID_03EB&PID_2175*')
        $list += [pscustomobject]@{ Com = $com; Text = $com + ' - ' + ($p.Name -replace '\s*\(COM\d+\)', ''); Kit = $isKit }
    }
    return ($list | Sort-Object @{ Expression = { -not $_.Kit } }, @{ Expression = { [int]($_.Com -replace '\D', '') } })
}

# ---------------------------------------------------------------- UI
$f = New-Object Windows.Forms.Form
$f.Size = New-Object Drawing.Size(1000, 660); $f.MinimumSize = New-Object Drawing.Size(760, 460)
$f.StartPosition = 'CenterScreen'; $f.Font = New-Object Drawing.Font('Segoe UI', 9)
function L([string] $t) { $x = New-Object Windows.Forms.Label; $x.Text = $t; $x.AutoSize = $true; $x.Margin = '6,7,2,0'; return $x }
function CB([int] $w, [bool] $list) { $x = New-Object Windows.Forms.ComboBox; $x.Width = $w; if ($list) { $x.DropDownStyle = 'DropDownList' }; return $x }
function BT { $x = New-Object Windows.Forms.Button; $x.AutoSize = $true; return $x }
function CH { $x = New-Object Windows.Forms.CheckBox; $x.AutoSize = $true; $x.Margin = '10,5,0,0'; return $x }

# row 1: connection
$row1 = New-Object Windows.Forms.FlowLayoutPanel; $row1.Dock = 'Top'; $row1.AutoSize = $true; $row1.Padding = '6,6,6,0'; $row1.WrapContents = $true
$lPort = L ''; $cbPort = CB 290 $true; $bRefresh = BT
$lBaud = L ''; $cbBaud = CB 85 $false
foreach ($b in 1200, 2400, 4800, 9600, 14400, 19200, 38400, 57600, 76800, 115200, 230400, 250000, 460800, 500000) { [void]$cbBaud.Items.Add([string]$b) }
$cbBaud.Text = $S.Baud
$lData = L ''; $cbData = CB 45 $true; foreach ($d in 7, 8) { [void]$cbData.Items.Add([string]$d) }
$cbData.SelectedIndex = [Math]::Max(0, $cbData.Items.IndexOf($S.DataBits))
$lPar = L ''; $cbPar = CB 70 $true
$lStop = L ''; $cbStop = CB 45 $true; [void]$cbStop.Items.Add('1'); [void]$cbStop.Items.Add('2')
$chDtr = CH; $chDtr.Checked = ($S.Dtr -eq '1')
$chRts = CH; $chRts.Checked = ($S.Rts -eq '1')
$bConn = BT; $bConn.BackColor = [Drawing.Color]::FromArgb(220, 240, 220); $bConn.Margin = '12,3,3,3'
$row1.Controls.AddRange(@($lPort, $cbPort, $bRefresh, $lBaud, $cbBaud, $lData, $cbData, $lPar, $cbPar, $lStop, $cbStop, $chDtr, $chRts, $bConn))

# row 2: view
$row2 = New-Object Windows.Forms.FlowLayoutPanel; $row2.Dock = 'Top'; $row2.AutoSize = $true; $row2.Padding = '6,0,6,4'; $row2.WrapContents = $true
$lShow = L ''; $cbView = CB 110 $true
$chStamp = CH; $chStamp.Checked = ($S.Stamp -eq '1')
$bClear = BT; $bSave = BT; $bReset = BT
$lLang = L ''; $cbLang = CB 90 $true; [void]$cbLang.Items.Add('Türkçe'); [void]$cbLang.Items.Add('English')
$row2.Controls.AddRange(@($lShow, $cbView, $chStamp, $bClear, $bSave, $bReset, $lLang, $cbLang))

# row 3: quick-send buttons (stored in settings.ini as Q1..Q4)
$row3 = New-Object Windows.Forms.FlowLayoutPanel; $row3.Dock = 'Top'; $row3.AutoSize = $true; $row3.Padding = '6,0,6,4'; $row3.WrapContents = $true
$lQuick = L ''; $row3.Controls.Add($lQuick)
$tip = New-Object Windows.Forms.ToolTip
$qb = @()
foreach ($k in 1..4) { $b = BT; $b.Tag = 'Q' + $k; $b.MinimumSize = New-Object Drawing.Size(90, 0); $row3.Controls.Add($b); $qb += $b }

$box = New-Object Windows.Forms.RichTextBox; $box.Dock = 'Fill'; $box.ReadOnly = $true; $box.BackColor = [Drawing.Color]::FromArgb(20, 24, 28)
$box.ForeColor = [Drawing.Color]::FromArgb(200, 255, 200); $box.Font = New-Object Drawing.Font('Consolas', 10); $box.WordWrap = $false; $box.HideSelection = $false

# bottom: send
$bottom = New-Object Windows.Forms.FlowLayoutPanel; $bottom.Dock = 'Bottom'; $bottom.AutoSize = $true; $bottom.Padding = '6,4,6,2'
$tbSend = New-Object Windows.Forms.TextBox; $tbSend.Width = 470; $tbSend.Font = New-Object Drawing.Font('Consolas', 10)
$lSendAs = L ''; $cbSendAs = CB 100 $true
$lEol = L ''; $cbEol = CB 70 $true
$bSend = BT
$bottom.Controls.AddRange(@($tbSend, $lSendAs, $cbSendAs, $lEol, $cbEol, $bSend))

$status = New-Object Windows.Forms.StatusStrip
$stState = New-Object Windows.Forms.ToolStripStatusLabel; $stCount = New-Object Windows.Forms.ToolStripStatusLabel; $stHint = New-Object Windows.Forms.ToolStripStatusLabel
$stHint.Spring = $true; $stHint.TextAlign = 'MiddleRight'
[void]$status.Items.AddRange(@($stState, $stCount, $stHint))

$f.Controls.Add($box); $f.Controls.Add($bottom); $f.Controls.Add($row3); $f.Controls.Add($row2); $f.Controls.Add($row1); $f.Controls.Add($status)

# ---------------------------------------------------------------- state
$script:sp = $null; $script:rx = 0; $script:tx = 0; $script:lineStart = $true; $script:mlog = $null
$script:lineBuf = New-Object Collections.Generic.List[byte]; $script:lastRx = [DateTime]::Now; $script:lineTime = ''
$colRx = [Drawing.Color]::FromArgb(200, 255, 200); $colHex = [Drawing.Color]::FromArgb(140, 190, 255); $colTx = [Drawing.Color]::Gold

function Fill-Combo($cb, $names, [int] $sel) { $cb.Items.Clear(); foreach ($n in $names) { [void]$cb.Items.Add($n) }; $cb.SelectedIndex = $sel }
function Apply-Lang {
    $f.Text = T 'title'; $lPort.Text = T 'port'; $bRefresh.Text = T 'refresh'; $lBaud.Text = T 'baud'; $lData.Text = T 'data'
    $lPar.Text = T 'parity'; $lStop.Text = T 'stop'; $chDtr.Text = T 'dtr'; $chRts.Text = T 'rts'
    $lShow.Text = T 'show'; $chStamp.Text = T 'stamp'; $bClear.Text = T 'clear'; $bSave.Text = T 'save'; $bReset.Text = T 'reset'
    $lLang.Text = T 'lang'; $lSendAs.Text = T 'sendas'; $lEol.Text = T 'eol'; $bSend.Text = T 'send'; $stHint.Text = T 'hint'
    $lQuick.Text = T 'quick'
    foreach ($b in $qb) { $b.Text = $S[$b.Tag]; $tip.SetToolTip($b, (T 'quicktip')) }
    Fill-Combo $cbPar (T 'parnames') (SelIdx $S.Parity 2)
    Fill-Combo $cbView (T 'viewnames') (SelIdx $S.View 2)
    Fill-Combo $cbSendAs (T 'sendnames') (SelIdx $S.SendMode 1)
    Fill-Combo $cbEol (T 'eolnames') (SelIdx $S.Eol 3)
    $cbStop.SelectedIndex = (SelIdx $S.StopBits 1)
    Update-State
}
function Update-State {
    $on = [bool]($script:sp -and $script:sp.IsOpen)
    foreach ($c in $cbPort, $bRefresh, $cbBaud, $cbData, $cbPar, $cbStop) { $c.Enabled = -not $on }
    $tbSend.Enabled = $on; $bSend.Enabled = $on
    foreach ($b in $qb) { $b.Enabled = $on }
    if ($on) {
        $bConn.Text = T 'disconn'; $bConn.BackColor = [Drawing.Color]::FromArgb(250, 220, 210)
        $stState.Text = (T 'st_on') + ': ' + $script:sp.PortName + '  ' + $script:sp.BaudRate + ' ' + $script:sp.DataBits + '-' + $cbPar.Text + '-' + $cbStop.Text
    } else {
        $bConn.Text = T 'connect'; $bConn.BackColor = [Drawing.Color]::FromArgb(220, 240, 220); $stState.Text = T 'st_off'
    }
    $cbEol.Enabled = ($cbSendAs.SelectedIndex -eq 0)
    Update-Count
}
function Update-Count { $stCount.Text = (T 'rx') + ': ' + $script:rx + '   ' + (T 'tx') + ': ' + $script:tx }
function Fill-Ports([bool] $announce) {
    $cbPort.Items.Clear(); $script:ports = @(Get-PortList)
    foreach ($p in $script:ports) { [void]$cbPort.Items.Add($p.Text) }
    $i = -1
    for ($k = 0; $k -lt $script:ports.Count; $k++) { if ($script:ports[$k].Kit) { $i = $k; break } }          # the kit first
    if ($i -lt 0) { for ($k = 0; $k -lt $script:ports.Count; $k++) { if ($script:ports[$k].Com -eq $S.Port) { $i = $k } } }
    if ($i -lt 0 -and $script:ports.Count -gt 0) { $i = 0 }
    $cbPort.SelectedIndex = $i
    if ($announce) {
        if ($i -ge 0 -and $script:ports[$i].Kit) { Append ('--- ' + (T 'found') + ' ' + $script:ports[$i].Text + " ---`r`n") ([Drawing.Color]::Gray) }
        elseif ($script:ports.Count -gt 0) { Append ('--- ' + (T 'nokit') + " ---`r`n") ([Drawing.Color]::Khaki) }
        else { Append ('--- ' + (T 'noport') + " ---`r`n") ([Drawing.Color]::Khaki) }
    }
}
function Append([string] $t, [Drawing.Color] $c) {
    $box.SelectionStart = $box.TextLength; $box.SelectionLength = 0; $box.SelectionColor = $c
    $box.AppendText($t)
    if ($box.TextLength -gt 400000) { $box.Select(0, 100000); $box.ReadOnly = $false; $box.SelectedText = ''; $box.ReadOnly = $true }
    $box.SelectionStart = $box.TextLength; $box.ScrollToCaret()
    if ($script:mlog) { try { [IO.File]::AppendAllText($script:mlog, $t) } catch { } }
}
function Stamp { if ($chStamp.Checked) { return '[' + (Get-Date -Format 'HH:mm:ss.fff') + '] ' } else { return '' } }
function TextOf([byte[]] $bytes) {
    $o = New-Object Text.StringBuilder
    foreach ($b in $bytes) {
        if ($b -eq 10 -or $b -eq 13) { }
        elseif ($b -lt 32 -or $b -gt 126) { [void]$o.Append('<' + $b.ToString('X2') + '>') }
        else { [void]$o.Append([char]$b) }
    }
    return $o.ToString()
}
function HexOf([byte[]] $bytes) { return (($bytes | ForEach-Object { $_.ToString('X2') }) -join ' ') }
function Flush-Line {                      # Text + HEX view: one text line and its bytes underneath
    if ($script:lineBuf.Count -eq 0) { return }
    $bytes = $script:lineBuf.ToArray(); $script:lineBuf.Clear()
    Append ($script:lineTime + (TextOf $bytes) + "`r`n") $colRx
    $pad = ' ' * $script:lineTime.Length
    Append ($pad + 'HEX: ' + (HexOf $bytes) + "`r`n") $colHex
    $script:lineTime = ''
}
function Close-Port {
    Flush-Line
    if ($script:sp) { try { $script:sp.Close() } catch { }; $script:sp = $null }
    $timer.Stop(); Update-State
}
function Open-Port {
    if ($cbPort.Items.Count -eq 0) { Fill-Ports $true }
    if ($cbPort.SelectedIndex -lt 0) { [Windows.Forms.MessageBox]::Show((T 'noport'), 'CNano') | Out-Null; return }
    $baud = 0
    if (-not [int]::TryParse($cbBaud.Text.Trim(), [ref]$baud) -or $baud -lt 1200 -or $baud -gt 500000) { [Windows.Forms.MessageBox]::Show((T 'badbaud'), 'CNano') | Out-Null; return }
    $com = $script:ports[$cbPort.SelectedIndex].Com
    $par = @('None', 'Odd', 'Even')[$cbPar.SelectedIndex]; $stop = @('One', 'Two')[$cbStop.SelectedIndex]
    $sp = New-Object System.IO.Ports.SerialPort $com, $baud, $par, ([int]$cbData.Text), $stop
    $sp.DtrEnable = $chDtr.Checked; $sp.RtsEnable = $chRts.Checked; $sp.Encoding = [Text.Encoding]::GetEncoding(28591)
    try { $sp.Open() } catch { [Windows.Forms.MessageBox]::Show((T 'openfail') + "`n" + $_.Exception.Message, 'CNano') | Out-Null; return }
    $script:sp = $sp
    $S.Port = $com; $S.Baud = [string]$baud; $S.DataBits = $cbData.Text; $S.Parity = [string]$cbPar.SelectedIndex; $S.StopBits = [string]$cbStop.SelectedIndex; Save-Settings
    $script:mlog = Join-Path $LogDir ('monitor_' + (Get-Date -Format 'ddMMyyyy_HHmm') + '.txt')
    Append ("--- " + (T 'logto') + ' ' + $script:mlog + " ---`r`n") ([Drawing.Color]::Gray)
    $script:lineStart = $true; $script:lineBuf.Clear(); $timer.Start(); Update-State
}

$timer = New-Object Windows.Forms.Timer; $timer.Interval = 30
$timer.Add_Tick({
    if (-not $script:sp) { return }
    try {
        if (-not $script:sp.IsOpen) { throw 'closed' }
        $view = $cbView.SelectedIndex
        $n = $script:sp.BytesToRead
        if ($n -le 0) {
            if ($view -eq 2 -and $script:lineBuf.Count -gt 0 -and ([DateTime]::Now - $script:lastRx).TotalMilliseconds -gt 150) { Flush-Line }
            return
        }
        $buf = New-Object byte[] $n; $n = $script:sp.Read($buf, 0, $n); $script:rx += $n; $script:lastRx = [DateTime]::Now
        if ($view -eq 2) {                                     # Text + HEX
            for ($i = 0; $i -lt $n; $i++) {
                if ($script:lineBuf.Count -eq 0) { $script:lineTime = Stamp }
                $script:lineBuf.Add($buf[$i])
                if ($buf[$i] -eq 10 -or $script:lineBuf.Count -ge 32) { Flush-Line }
            }
        } else {
            $out = New-Object Text.StringBuilder
            for ($i = 0; $i -lt $n; $i++) {
                $b = $buf[$i]
                if ($script:lineStart) { [void]$out.Append((Stamp)); $script:lineStart = $false }
                if ($view -eq 1) {                                 # HEX: 16 bytes or LF per line
                    [void]$out.Append($b.ToString('X2') + ' '); $script:hexCount++
                    if ($b -eq 10 -or $script:hexCount -ge 16) { [void]$out.Append("`r`n"); $script:lineStart = $true; $script:hexCount = 0 }
                } else {                                           # Text
                    if ($b -eq 10) { [void]$out.Append("`r`n"); $script:lineStart = $true }
                    elseif ($b -eq 13) { }
                    elseif ($b -lt 32 -or $b -gt 126) { [void]$out.Append('<' + $b.ToString('X2') + '>') }
                    else { [void]$out.Append([char]$b) }
                }
            }
            Append $out.ToString() $colRx
        }
        Update-Count
    } catch {
        Close-Port; $stState.Text = T 'st_lost'
    }
})
$script:hexCount = 0

function Parse-Hex([string] $t) {
    $s = ($t -replace '0[xX]', '' -replace '[\s,;:\-]', '')
    if ($s.Length -eq 0 -or ($s.Length % 2) -ne 0 -or $s -notmatch '^[0-9A-Fa-f]+$') { return $null }
    $r = New-Object byte[] ($s.Length / 2)
    for ($i = 0; $i -lt $r.Length; $i++) { $r[$i] = [Convert]::ToByte($s.Substring($i * 2, 2), 16) }
    return ,$r
}
function Send-Bytes([byte[]] $bytes, [string] $label) {
    if (-not $script:sp) { return $false }
    try {
        Flush-Line
        $script:sp.Write($bytes, 0, $bytes.Length); $script:tx += $bytes.Length
        if ($cbView.SelectedIndex -eq 0) { $shown = $label } elseif ($cbView.SelectedIndex -eq 1) { $shown = HexOf $bytes } else { $shown = (TextOf $bytes) + '   HEX: ' + (HexOf $bytes) }
        if (-not $script:lineStart) { Append "`r`n" $colRx; $script:lineStart = $true; $script:hexCount = 0 }
        Append ((Stamp) + '> ' + $shown + "`r`n") $colTx
        Update-Count; return $true
    } catch { Close-Port; return $false }
}
function Text-Bytes([string] $t) {
    $eol = @('', "`r", "`n", "`r`n")[$cbEol.SelectedIndex]
    return ,([Text.Encoding]::GetEncoding(28591).GetBytes($t + $eol))
}
function Send-Data {
    if (-not $script:sp) { return }
    if ($cbSendAs.SelectedIndex -eq 1) {
        $bytes = Parse-Hex $tbSend.Text
        if ($null -eq $bytes) { [Windows.Forms.MessageBox]::Show((T 'badhex'), 'CNano') | Out-Null; return }
    } else { $bytes = Text-Bytes $tbSend.Text }
    if (Send-Bytes $bytes $tbSend.Text) { $tbSend.Clear() }
}
function Send-Quick($b) {
    if ([Windows.Forms.Control]::ModifierKeys -band [Windows.Forms.Keys]::Shift) {           # Shift + click: edit
        Add-Type -AssemblyName Microsoft.VisualBasic
        $v = [Microsoft.VisualBasic.Interaction]::InputBox((T 'quickask'), 'CNano', $S[$b.Tag])
        if ($v -ne '') { $S[$b.Tag] = $v; Save-Settings; $b.Text = $v }
        return
    }
    $q = [string]$S[$b.Tag]
    if ($q -match '^\s*HEX\s*:(.*)$') {
        $bytes = Parse-Hex $Matches[1]
        if ($null -eq $bytes) { [Windows.Forms.MessageBox]::Show((T 'badhex'), 'CNano') | Out-Null; return }
        [void](Send-Bytes $bytes $q)
    } else { [void](Send-Bytes (Text-Bytes $q) $q) }
}

$bConn.Add_Click({ if ($script:sp) { Close-Port } else { Open-Port } })
$bRefresh.Add_Click({ Fill-Ports $true })
$chDtr.Add_CheckedChanged({ $S.Dtr = [string][int]$chDtr.Checked; Save-Settings; if ($script:sp) { $script:sp.DtrEnable = $chDtr.Checked } })
$chRts.Add_CheckedChanged({ $S.Rts = [string][int]$chRts.Checked; Save-Settings; if ($script:sp) { $script:sp.RtsEnable = $chRts.Checked } })
$chStamp.Add_CheckedChanged({ $S.Stamp = [string][int]$chStamp.Checked; Save-Settings })
$cbView.Add_SelectedIndexChanged({ if ($cbView.SelectedIndex -ge 0) { Flush-Line; if (-not $script:lineStart) { Append "`r`n" $colRx; $script:lineStart = $true }; $script:hexCount = 0; $S.View = [string]$cbView.SelectedIndex; Save-Settings } })
$cbSendAs.Add_SelectedIndexChanged({ if ($cbSendAs.SelectedIndex -ge 0) { $S.SendMode = [string]$cbSendAs.SelectedIndex; Save-Settings; $cbEol.Enabled = ($cbSendAs.SelectedIndex -eq 0) } })
$cbEol.Add_SelectedIndexChanged({ if ($cbEol.SelectedIndex -ge 0) { $S.Eol = [string]$cbEol.SelectedIndex; Save-Settings } })
$bClear.Add_Click({ $box.Clear(); $script:rx = 0; $script:tx = 0; Update-Count })
$bSave.Add_Click({
    $d = New-Object Windows.Forms.SaveFileDialog; $d.Filter = 'Text (*.txt)|*.txt'; $d.FileName = 'monitor_' + (Get-Date -Format 'ddMMyyyy_HHmm') + '.txt'
    if ($d.ShowDialog() -eq 'OK') { [IO.File]::WriteAllText($d.FileName, $box.Text) }
})
$bReset.Add_Click({
    Append ('--- ' + (T 'resetrun') + " ---`r`n") ([Drawing.Color]::Khaki)
    $ps1 = Join-Path $Here 'CNanoProg.ps1'
    Start-Process powershell.exe -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', ('"' + $ps1 + '"'), '-Mode', 'reset', '-NoPause', '-Lang', $S.Lang) -WindowStyle Hidden
})
$bSend.Add_Click({ Send-Data })
foreach ($b in $qb) { $b.Add_Click({ param($sender, $e) Send-Quick $sender }) }
$tbSend.Add_KeyDown({ if ($_.KeyCode -eq 'Enter') { Send-Data; $_.SuppressKeyPress = $true } })
$cbLang.Add_SelectedIndexChanged({ $S.Lang = @('tr', 'en')[$cbLang.SelectedIndex]; Save-Settings; Apply-Lang })
$f.Add_FormClosing({ Close-Port })
$f.Add_Load({ $f.WindowState = 'Normal'; $f.TopMost = $true; $f.Activate(); $f.TopMost = $false })
# On start only the port list is filled (the kit's port preselected). Nothing is opened until Connect.
$f.Add_Shown({ Fill-Ports $true; if ($Connect) { Open-Port } })

if ($S.Lang -eq 'tr') { $cbLang.SelectedIndex = 0 } else { $cbLang.SelectedIndex = 1 }
Apply-Lang
[void]$f.ShowDialog()
