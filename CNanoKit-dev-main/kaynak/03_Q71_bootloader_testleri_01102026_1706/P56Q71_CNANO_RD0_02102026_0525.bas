' FREELOADER / mwboot / mwload
' Copyright (c) 2026 Jon Walker.  All rights reserved.
' Free to use under LICENSE.txt - modified versions may not be distributed
' and this notice must stay.  Contact: mwave.dude@gmail.com
'****************************************************************************
'*  P56Q71_CNANO_RD0   - test app for mwboot on the PIC18F56Q71             *
'*  LOCAL TEST COPY (okmn, 01 Oct 2026) - adapted from JonW's P56Q43_BLINK  *
'*  for the PIC18F56Q71 Curiosity Nano (EV01G21A).  NOT for distribution.   *
'*                                                                          *
'*  Curiosity Nano facts (kit user guide DS50003481A):                      *
'*    LED0 (yellow) = RC7, active LOW  -> also mwboot's UART1 RX pin!       *
'*    SW0           = RA0, to GND, needs the internal pull-up               *
'*    nEDBG CDC     : RB4 = target TX, RB5 = target RX (not RC6/RC7)        *
'*                                                                          *
'*  cLedOnRC7 = 1 : no wires fitted. RC7 drives LED0 (proof of life).       *
'*  cLedOnRC7 = 0 : jumper RB5 -> RC7 fitted for FREELOADER. RC7 is left    *
'*                  an input (never fight the CDC TX line); proof = UART.   *
'*                                                                          *
'*  UART1 115200 on RC6 (TX), same as mwboot: "BLINK 56Q71 n" CR LF.        *
'****************************************************************************
'*  RD0 version (02 Oct 2026): external LED RD0 -> 1k -> LED -> GND.       *
'*  After the bootloader starts this app:                                   *
'*    1) 3 s  RD0 fast blink (50 ms / 50 ms)          UART: "1 FAST"         *
'*    2) 3 s  RD0 fade up 1.5 s, fade down 1.5 s      UART: "2 FADE"         *
'*    3) loop RD0 double flash + "UART 56Q71 n" every ~1 s                  *
'*       cLedOnRC7 = 1 (no wires): LED0 flashes together with RD0.         *
'*       cLedOnRC7 = 0 (wires fitted): RC7 is NEVER driven (kit CDC TX).    *
'****************************************************************************
    Device = 18F56Q71
    Declare Xtal = 64

$define cLedOnRC7 0

    Dim bChar  As Byte
    Dim bIdx   As Byte
    Dim bCount As Byte
    Dim bI     As Byte
    Dim bLvl   As Byte
    Dim bDuty  As Byte
    Dim bRep   As Byte
    Dim bSlot  As Byte
    Dim wTmp   As Word

    TBLPTRU = 0                                 ' Cread8 below assumes the low 64K

'--- clock: HFINTOSC 64 MHz (DS40002329F: OSCFRQ FRQ = 1000 -> 64 MHz)
    OSCCON1 = $60
    OSCFRQ  = $08

    ANSELA = 0
    ANSELB = 0
    ANSELC = 0
    ANSELD = 0

'--- external LED on RD0 (active high), off
    LATD.0  = 0
    TRISD.0 = 0

'--- UART1 115200 on RC6 (TX) / RC7 (RX) - mwboot's own setting
'    BRGS = 1: baud = 64 MHz / (4 * (138 + 1)) = 115108
    TRISC.6 = 0
    U1RXPPS = ((2 << 3) | 7)                    ' RC7 -> U1RX
    RC6PPS  = PPS_Fn_TX1                        ' U1TX -> RC6
    U1BRGH  = 0
    U1BRGL  = 138
    U1CON0  = ((1 << 7) | (1 << 5) | (1 << 4))  ' BRGS, TXEN, RXEN, async 8-bit
    U1CON1  = (1 << 7)                          ' ON

$if cLedOnRC7 = 1
    LATC.7  = 1                                 ' LED0 off (active low)
    TRISC.7 = 0
$endif

'=== 1) 3 s fast blink ======================================================
    bChar = "1" : GoSub Tx_Char : bChar = " " : GoSub Tx_Char
    bChar = "F" : GoSub Tx_Char : bChar = "A" : GoSub Tx_Char
    bChar = "S" : GoSub Tx_Char : bChar = "T" : GoSub Tx_Char : GoSub Tx_Crlf
    For bI = 1 To 30
        LATD.0 = 1
        DelayMS 50
        LATD.0 = 0
        DelayMS 50
    Next

'=== 2) 3 s fade (soft PWM 1 kHz, 40 steps, square law) =====================
    bChar = "2" : GoSub Tx_Char : bChar = " " : GoSub Tx_Char
    bChar = "F" : GoSub Tx_Char : bChar = "A" : GoSub Tx_Char
    bChar = "D" : GoSub Tx_Char : bChar = "E" : GoSub Tx_Char : GoSub Tx_Crlf
    For bI = 0 To 39                            ' up, 40 x 37 ms = 1.5 s
        bLvl = bI
        GoSub Pwm_37ms
    Next
    For bI = 0 To 39                            ' down, 1.5 s
        bLvl = 39 - bI
        GoSub Pwm_37ms
    Next
    LATD.0 = 0

'=== 3) loop: double flash + "UART 56Q71 n" =================================
    bCount = 0
    Do
        LATD.0 = 1
$if cLedOnRC7 = 1
        LATC.7 = 0
$endif
        DelayMS 100
        LATD.0 = 0
$if cLedOnRC7 = 1
        LATC.7 = 1
$endif
        DelayMS 100
        LATD.0 = 1
$if cLedOnRC7 = 1
        LATC.7 = 0
$endif
        DelayMS 100
        LATD.0 = 0
$if cLedOnRC7 = 1
        LATC.7 = 1
$endif
        GoSub Send_Msg
        DelayMS 700
    Loop

Pwm_37ms:                                       ' 37 periods of 1 ms, RD0 on for bDuty/40
    wTmp = bLvl                                 ' square law (looks even to the eye)
    wTmp = wTmp * wTmp
    wTmp = wTmp / 39
    bDuty = wTmp
    For bRep = 1 To 37
        For bSlot = 0 To 39
            If bSlot < bDuty Then
                LATD.0 = 1
            Else
                LATD.0 = 0
            EndIf
            DelayUS 20
        Next
    Next
    Return

Tx_Crlf:
    bChar = 13 : GoSub Tx_Char
    bChar = 10 : GoSub Tx_Char
    Return

Send_Msg:
    bIdx = 0
    Repeat
        bChar = CRead8 Msg_Tab[bIdx]
        If bChar = 0 Then Break
        GoSub Tx_Char
        Inc bIdx
    Until bIdx = 0
    bChar = "0" + bCount
    GoSub Tx_Char
    GoSub Tx_Crlf
    Inc bCount
    If bCount > 9 Then bCount = 0
    Return

Tx_Char:
    Repeat : Until U1FIFO.4 = 0                 ' TXBF
    U1TXB = bChar
    Return

Msg_Tab:
    CData "UART 56Q71 ", 0

'---------------------------------------------------------------------------
' EEPROM test data (Q71: 256 B at 0x380000).
'---------------------------------------------------------------------------
    EData $11, $22, $33, "HELLO"

'---------------------------------------------------------------------------
' Config = the bootloader's own (8C 1D E5 F6 9F FF ...), so a direct load
' by the kit (CNanoProg / drag-and-drop) runs exactly as under mwboot.
' FREELOADER ignores these (the bootloader's stay).  LVP stays ON: the
' kit's nEDBG programs the Q71 by low-voltage programming.
'---------------------------------------------------------------------------
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
