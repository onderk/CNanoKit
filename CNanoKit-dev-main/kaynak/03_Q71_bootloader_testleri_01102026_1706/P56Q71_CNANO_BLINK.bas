' FREELOADER / mwboot / mwload
' Copyright (c) 2026 Jon Walker.  All rights reserved.
' Free to use under LICENSE.txt - modified versions may not be distributed
' and this notice must stay.  Contact: mwave.dude@gmail.com
'****************************************************************************
'*  P56Q71_CNANO_BLINK - test app for mwboot on the PIC18F56Q71             *
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
    Device = 18F56Q71
    Declare Xtal = 64

$define cLedOnRC7 1

    Dim bChar  As Byte
    Dim bIdx   As Byte
    Dim bCount As Byte

    TBLPTRU = 0                                 ' Cread8 below assumes the low 64K

'---------------------------------------------------------------------------
' Clock: HFINTOSC 64 MHz (DS40002329F: OSCFRQ FRQ = 1000 -> 64 MHz).
'---------------------------------------------------------------------------
    OSCCON1 = $60
    OSCFRQ  = $08

    ANSELA = 0
    ANSELB = 0
    ANSELC = 0

'---------------------------------------------------------------------------
' UART1 115200 on RC6 (TX) / RC7 (RX) - mwboot's init.
'   BRGS = 1: baud = 64 MHz / (4 * (138 + 1)) = 115108
'   PPS (DS40002329F): U1RXPPS 'b010 111 = RC7;  RC6PPS 0x15 = UART1 TX
'---------------------------------------------------------------------------
    TRISC.6 = 0
    U1RXPPS = ((2 << 3) | 7)                    ' RC7 -> U1RX
    RC6PPS  = PPS_Fn_TX1                        ' U1TX -> RC6 (0x15 on the Q71)
    U1BRGH  = 0
    U1BRGL  = 138
    U1CON0  = ((1 << 7) | (1 << 5) | (1 << 4))  ' BRGS, TXEN, RXEN, async 8-bit
    U1CON1  = (1 << 7)                          ' ON

$if cLedOnRC7 = 1
    LATC.7  = 1                                 ' LED0 off (active low)
    TRISC.7 = 0
$endif

    bCount = 0
    Do
$if cLedOnRC7 = 1
        LATC.7 = 0                              ' LED0 on
        DelayMS 100
        LATC.7 = 1                              ' LED0 off
        DelayMS 100
        LATC.7 = 0
        DelayMS 100
        LATC.7 = 1                              ' double flash = this app, not the kit demo
$endif
        GoSub Send_Msg
        DelayMS 700
    Loop

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
    bChar = 13
    GoSub Tx_Char
    bChar = 10
    GoSub Tx_Char
    Inc bCount
    If bCount > 9 Then bCount = 0
    Return

Tx_Char:
    Repeat : Until U1FIFO.4 = 0                 ' TXBF
    U1TXB = bChar
    Return

Msg_Tab:
    CData "BLINK 56Q71 ", 0

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
