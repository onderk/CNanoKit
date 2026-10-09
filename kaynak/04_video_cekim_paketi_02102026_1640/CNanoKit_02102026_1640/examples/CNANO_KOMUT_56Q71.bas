'****************************************************************************
'*  CNANO_KOMUT_56Q71.bas - command test for CNano Monitor (TR / EN)        *
'*  CNano Monitor komut testi - PIC18F56Q71 Curiosity Nano                  *
'*                                                                          *
'*  The PIC stays QUIET and waits for a command from the PC:                *
'*  PIC SESSIZ bekler, PC'den komut gelince calisir:                        *
'*                                                                          *
'*    okmn      (Text / Metin)  LED: tik-tik-tik-tik + 300 ms pause, repeat *
'*    53        (HEX bytes)     LED: PWM fade up 500 ms + down 500 ms, repeat*
'*    come      (Text / Metin)  PIC sends a DATA line every 250 ms, repeat  *
'*    stop      (Text / Metin)  stop whatever runs / calismayi durdur       *
'*  Every command repeats until "stop" (or another command).                *
'*  Her komut "stop" gelene kadar (ya da yeni komut gelene kadar) surer.    *
'*    help      (Text / Metin)  list the commands / komut listesi           *
'*                                                                          *
'*  A new command always replaces the running one.                          *
'*  Text commands: any case, with or without a line end (CR/LF/CR+LF/None). *
'*  HEX 53 = the single byte $53 (it is also the letter "S" in ASCII).      *
'*  SW0 press -> "SW0" line.                                                *
'*                                                                          *
'*  Kit pins (DS50003481A): UART2 TX = RB4 -> kit CDC RX, RX = RB5 <- CDC TX *
'*    LED0 = RC7 (active low)   SW0 = RA0 (to GND, internal pull-up)        *
'*  WIRES / KABLOLAR: works with or without the FREELOADER test wires.      *
'*  At the first received byte it checks wire 2 (RB5 - RC7) safely.         *
'*   - wire fitted (or not yet known): RC7 = the kit's CDC TX line, it is   *
'*     NEVER driven; the LED is shown on the monitor as text (virtual LED). *
'*     (LED0 then only flickers when the PC sends bytes - not a fault.)     *
'*   - no wire: LED0 is driven as usual (and also shown on the monitor).    *
'*  OPTIONAL external LED on RD0 (left row hole 16): RD0 -> 1 kOhm -> LED   *
'*  anode, LED cathode -> GND (hole 15).  RD0 always follows the LED state, *
'*  so a real LED is visible even with the wires fitted.                    *
'*  ISTEGE BAGLI dis LED: RD0 -> 1 kOhm -> LED -> GND. Kablolu da yanar.    *
'*  Kablolu: RC7 hic surulmez, LED monitorde yazi ile gosterilir.           *
'*  Kablosuz: LED0 gercekten yanar.  Ayni kod, ayar gerekmez.               *
'*                                                                          *
'*  Timing: one main-loop pass is about 50 us (DelayUS 46 + code), 20 passes *
'*  = 1 "ms" tick; times are about +-5 %.  Software PWM: 40 levels, ~500 Hz *
'*  Free to use, no warranty.  okmn 2026.                                   *
'****************************************************************************
    Device = 18F56Q71
    Declare Xtal = 64


    Dim sTx    As String * 96               ' line to send
    Dim sCmd   As String * 17               ' received command
    Dim sLow   As String * 17
    Dim bLen   As Byte                      ' bytes in sCmd
    Dim bRaw   As Byte                      ' first raw byte of the packet
    Dim bChar  As Byte
    Dim bI     As Byte
    Dim bSub   As Byte                      ' 0..19 passes -> 1 ms
    Dim bIdle  As Byte                      ' ms since the last received byte
    Dim bPhase As Byte                      ' software PWM phase 0..39
    Dim bDuty  As Byte                      ' software PWM duty 0..40
    Dim bMode  As Byte                      ' 0 idle, 1 blink, 2 fade, 3 stream
    Dim wT     As Word                      ' ms since the mode started
    Dim wX     As Word
    Dim wNext  As Word                      ' stream: next send time
    Dim wN     As Word                      ' stream: line counter
    Dim dX     As Dword
    Dim bSwOld As Bit
    Dim bLedOn As Bit
    Dim bLedWas As Bit                          ' last state shown on the monitor
    Dim bWires As Bit                           ' 1 = FREELOADER test wires detected
    Dim bKnown As Bit                           ' 1 = wire state decided
    Dim Bk     As Byte
    Dim bSw    As Byte
    Dim wCyc   As Word                      ' repeat counter

    Symbol cIdle   = 0
    Symbol cBlink  = 1
    Symbol cFade   = 2
    Symbol cStream = 3

'--- clock: HFINTOSC 64 MHz (OSCFRQ FRQ = 1000) -----------------------------
    OSCCON1 = $60
    OSCFRQ  = $08

'--- ports -------------------------------------------------------------------
    ANSELA = 0 : ANSELB = 0 : ANSELC = 0
    WPUA.0 = 1                                  ' SW0 pull-up
    WPUB.5 = 1                                  ' RB5 pull-up (CDC line floats until the PC opens the port)

'--- wire 2 (RB5 - RC7) check, done safely at the FIRST received byte --------
'    Until we know, RC7 is an input (pull-up on, LED off) and is never driven.
'    Interrupt-on-change flags latch falling edges on RB5 (CDC TX -> PIC RX)
'    and on RC7.  First byte arrives: RB5 saw an edge and RC7 too -> wire fitted.
'    RB5 saw an edge, RC7 not -> no wire -> LED0 may be driven.
    ANSELD = 0 : LATD.0 = 0 : TRISD.0 = 0      ' optional external LED on RD0 (active high)
    TRISC.7 = 1 : WPUC.7 = 1
    IOCBN.5 = 1 : IOCCN.7 = 1
    IOCBF.5 = 0 : IOCCF.7 = 0
    bWires = 1 : bKnown = 0                     ' "wired" until proven otherwise

'--- UART2 115200 8N1 on RB4 (TX) / RB5 (RX) ---------------------------------
'    BRGS = 1: baud = 64 MHz / (4 * (138 + 1)) = 115108 (-0.08 %)
    LATB.4  = 1
    TRISB.4 = 0
    RB4PPS  = PPS_Fn_TX2                        ' 0x18
    U2RXPPS = ((1 << 3) | 5)                    ' RB5
    U2BRGH  = 0
    U2BRGL  = 138
    U2CON0  = ((1 << 7) | (1 << 5) | (1 << 4)) ' BRGS, TXEN, RXEN, async 8-bit
    U2CON1  = (1 << 7)                          ' ON

    bLen = 0 : sCmd = "" : bSub = 0 : bIdle = 0 : bPhase = 0 : bDuty = 0
    bMode = cIdle : wT = 0 : bSwOld = 1 : bLedOn = 0 : bLedWas = 0
    DelayMS 100
    GoSub Tx_Help

'============================================================================ main loop
    Do
        '--- receive: collect bytes into one packet ----------------------------
        While U2FIFO.1 = 0                      ' RXBE = 0 -> a byte is waiting
            bChar = U2RXB
            If bKnown = 0 Then GoSub Wire_Decide
            bIdle = 0
            If bChar = 13 Or bChar = 10 Then
                If bLen > 0 Then GoSub Do_Command
            Else
                If bLen = 0 Then bRaw = bChar
                If bLen < 16 Then
                    sCmd[bLen] = bChar
                    Inc bLen
                    sCmd[bLen] = 0
                EndIf
            EndIf
        Wend

        '--- software PWM on LED0 (fade mode) ----------------------------------
        If bMode = cFade Then
            Inc bPhase
            If bPhase >= 40 Then bPhase = 0
            If bPhase < bDuty Then
                bLedOn = 1
            Else
                bLedOn = 0
            EndIf
            GoSub Led_Out
        EndIf

        '--- 1 ms tick --------------------------------------------------------
        DelayUS 46
        Inc bSub
        If bSub >= 20 Then
            bSub = 0
            GoSub Tick_1ms
        EndIf
    Loop

'============================================================================ every ms
Tick_1ms:
    ' a packet without line end ends after 30 ms of silence (HEX 53, or "okmn" with line end "None")
    If bLen > 0 Then
        Inc bIdle
        If bIdle >= 30 Then GoSub Do_Command
    EndIf

    ' SW0
    If PORTA.0 <> bSwOld Then
        bSwOld = PORTA.0
        If bSwOld = 0 Then
            sTx = "SW0"
            GoSub Tx_Line
        EndIf
    EndIf

    If bMode = cIdle Then Return
    Inc wT

    Select bMode
    Case cBlink                                 ' 4 x (80 ms on, 120 ms off) + 300 ms pause, repeat
        If wT >= 1100 Then
            wT = 0 : Inc wCyc
        EndIf
        wX = wT                                 ' position inside the group
        bLedOn = 0
        If wX < 800 Then
            If (wX // 200) < 80 Then bLedOn = 1
        EndIf
        GoSub Led_Out
        If bLedOn <> bLedWas Then               ' virtual LED on the monitor
            bLedWas = bLedOn
            If bLedOn = 1 Then
                Bk = wX / 200 : Inc Bk
                sTx = "LED (#) ON   tik " + Str$(Dec Bk) + "/4   tur " + Str$(Dec wCyc)
            Else
                sTx = "LED ( ) off"
            EndIf
            GoSub Tx_Line
        EndIf

    Case cFade                                  ' 0 -> max 500 ms, max -> 0 500 ms, repeat
        If wT >= 1000 Then
            wT = 0 : Inc wCyc
        EndIf
        wX = wT
        If wX >= 500 Then wX = 1000 - wX        ' 0..500..0
        dX = wX
        dX = (dX * dX * 40) / 250000            ' square law: looks linear to the eye
        bDuty = dX
        ' virtual LED: a bar every 100 ms (short enough to follow, long enough to keep the PWM smooth)
        wX = wT // 100
        If wX = 0 Then GoSub Tx_Bar

    Case cStream                                ' a DATA line every 250 ms, repeat
        If wT >= wNext Then
            If wT >= 60000 Then                 ' keep the Word counters small
                wT = 0 : wNext = 0
            EndIf
            Inc wN
            bSw = PORTA.0
            sTx = "DATA " + Str$(Dec wN) + "  SW0=" + Str$(Dec bSw)
            GoSub Tx_Line
            wNext = wNext + 250
        EndIf
    EndSelect
    Return

'============================================================================ commands
Do_Command:
    sLow = ToLower(sCmd)
    If bLen = 1 And bRaw = $53 Then
        GoSub Stop_All
        bMode = cFade : wT = 0 : bPhase = 0 : bDuty = 0 : wCyc = 1
        sTx = "OK 53: LED PWM 0->max->0 (500+500 ms), stop ile durur" : GoSub Tx_Line
    Else
        Select sLow
        Case "okmn"
            GoSub Stop_All
            bMode = cBlink : wT = 0 : wCyc = 1
            sTx = "OK okmn: LED tik-tik-tik-tik + 300 ms, stop ile durur" : GoSub Tx_Line
        Case "come"
            GoSub Stop_All
            bMode = cStream : wT = 0 : wNext = 0 : wN = 0
            sTx = "OK come: DATA her 250 ms, stop ile durur" : GoSub Tx_Line
        Case "stop"
            GoSub Stop_All
            sTx = "OK stop: bekliyor / waiting" : GoSub Tx_Line
        Case "help"
            GoSub Tx_Help
        Case "?"
            GoSub Tx_Help
        Case Else
            sTx = "? bilinmeyen komut / unknown: " + sCmd + "  (HEX " + Str$(Hex2 bRaw) + "...)  -> help" : GoSub Tx_Line
        EndSelect
    EndIf
    bLen = 0 : sCmd = "" : bIdle = 0
    Return

Stop_All:
    If bMode <> cIdle Then
        sTx = "-- durdu / stopped --" : GoSub Tx_Line
    EndIf
    bMode = cIdle : bDuty = 0 : bLedOn = 0 : bLedWas = 0
    GoSub Led_Out
    Return

Led_Out:
    If bLedOn = 1 Then                          ' optional external LED on RD0 (active high)
        LATD.0 = 1                              ' constant form: the compiler selects bank 1 itself
    Else                                        ' ("LATD.0 = bLedOn" was compiled without a bank
        LATD.0 = 0                              '  select and hit RAM 0x543, so RD0 stayed dark)
    EndIf
    If bWires = 1 Then Return                   ' RC7 is the kit's CDC TX line: never drive it
    If bLedOn = 1 Then
        LATC.7 = 0                              ' active low
    Else
        LATC.7 = 1
    EndIf
    Return

Tx_Bar:                                         ' "LED [##########----------]  50 %"
    sTx = "LED ["
    bI = 0
    While bI < 20
        If bI < (bDuty / 2) Then
            sTx = sTx + "#"
        Else
            sTx = sTx + "-"
        EndIf
        Inc bI
    Wend
    Bk = bDuty * 5
    Bk = Bk / 2
    sTx = sTx + "] " + Str$(Dec Bk) + " %"
    GoSub Tx_Line
    Return

'============================================================================ UART2 output
Tx_Char:
    Repeat : Until U2FIFO.4 = 0                 ' TXBF = 0 -> room in the buffer
    U2TXB = bChar
    Return

Tx_Line:                                        ' sends sTx + CR LF
    bI = 0
    While bI < Len(sTx)
        bChar = sTx[bI] : GoSub Tx_Char
        Inc bI
    Wend
    bChar = 13 : GoSub Tx_Char
    bChar = 10 : GoSub Tx_Char
    Return

Tx_Help:
    sTx = "CNANO_KOMUT 56Q71 hazir / ready" : GoSub Tx_Line
    If bKnown = 0 Then
        sTx = "  Kablo durumu ilk komutta belirlenir / wire check at the first command" : GoSub Tx_Line
    Else
        If bWires = 1 Then
            sTx = "  KABLOLU (RB5-RC7) / wire fitted: LED0 surulmez, LED burada gosterilir" : GoSub Tx_Line
        Else
            sTx = "  KABLOSUZ / no wire: LED0 kullaniliyor (+ burada gosterilir)" : GoSub Tx_Line
        EndIf
    EndIf
    sTx = "  okmn  (Metin/Text)  LED tik x4 + 300 ms, surekli" : GoSub Tx_Line
    sTx = "  53    (HEX)         LED PWM fade, surekli" : GoSub Tx_Line
    sTx = "  come  (Metin/Text)  DATA her 250 ms, surekli" : GoSub Tx_Line
    sTx = "  stop  durdurur      help  bu liste" : GoSub Tx_Line
    sTx = "  Dis LED (istege bagli): RD0 - 1k - LED - GND" : GoSub Tx_Line
    Return

Wire_Decide:                                    ' called once, right after the first received byte
    If IOCBF.5 = 1 Then
        If IOCCF.7 = 1 Then
            bWires = 1                          ' RC7 followed RB5: wire fitted, never drive RC7
        Else
            bWires = 0                          ' RC7 stayed quiet: no wire
            WPUC.7 = 0 : LATC.7 = 1 : TRISC.7 = 0
        EndIf
        bKnown = 1
    EndIf
    IOCBF.5 = 0 : IOCCF.7 = 0
    Return

'--- configuration: internal 64 MHz, LVP on (the kit programs by LVP) ------
Config_Start
    FEXTOSC  = OFF
    RSTOSC   = HFINTOSC_64MHZ
    CLKOUTEN = OFF
    PR1WAY   = OFF
    CSWEN    = On
    BBEN     = OFF
    FCMEN    = OFF
    FCMENP   = OFF
    FCMENS   = OFF
    MCLRE    = EXTMCLR
    PWRTS    = PWRT_64
    MVECEN   = OFF
    IVT1WAY  = OFF
    LPBOREN  = OFF
    BOREN    = SBORDIS
    BORV     = VBOR_2P45
    ZCD      = OFF
    PPS1WAY  = OFF
    STVREN   = On
    LVP      = On
    XINST    = OFF
    Debug    = OFF
    WDTCPS   = WDTCPS_31
    WDTE     = OFF
    WDTCWS   = WDTCWS_7
    WDTCCS   = SC
    WRTB     = OFF
    WRTC     = OFF
    WRTD     = OFF
    WRTSAF   = OFF
    WRTAPP   = OFF
    CPD      = OFF
    Cp       = OFF
Config_End
