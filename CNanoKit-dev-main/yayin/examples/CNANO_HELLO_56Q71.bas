'****************************************************************************
'*  CNANO_HELLO_56Q71.bas - first program for the PIC18F56Q71 Curiosity Nano  *
'*  CNANO_HELLO_56Q71.bas - PIC18F56Q71 Curiosity Nano icin ilk program        *
'*                                                                          *
'*  - sends "Hello / Merhaba n" every 500 ms over UART2 -> kit USB COM port *
'*  - echoes every character you type in CNano Monitor                     *
'*  - reports SW0 presses                                                   *
'*  - blinks LED0 (only when no FREELOADER test wires are fitted)          *
'*                                                                          *
'*  Kit pins (Microchip user guide DS50003481A):                            *
'*    UART2 TX = RB4 -> kit "CDC RX"   UART2 RX = RB5 <- kit "CDC TX"       *
'*    LED0 = RC7 (active low)          SW0 = RA0 (to GND, use pull-up)      *
'*  PPS (data sheet DS40002329F): RB4PPS = 0x18 (UART2 TX),                 *
'*    U2RXPPS = 'b001 101 (RB5)                                             *
'*                                                                          *
'*  Wires: the FREELOADER test wire RB5 - RC7 is checked safely at the     *
'*  first received byte. Until then, and if it is fitted, RC7 (= kit CDC TX *
'*  line) is never driven: LED0 blinks only after a character is received   *
'*  and no wire was found.  Kablo varsa RC7 hic surulmez.                   *
'*  Optional external LED: RD0 (left row hole 16) -> 1 kOhm -> LED -> GND,  *
'*  blinks always, also with the wires fitted.                              *
'*  Freeware, see LICENSE.txt.  okmn 2026.                                  *
'****************************************************************************
    Device = 18F56Q71
    Declare Xtal = 64


    Dim bCount As Byte
    Dim bChar  As Byte
    Dim bTick  As Word
    Dim bSwOld As Bit
    Dim bWires As Bit
    Dim bKnown As Bit                           ' 1 = wire state decided

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

    bCount = 0 : bTick = 0 : bSwOld = 1
    Do
        '--- echo whatever the PC sends, byte for byte (same rate in and out) ---
        While U2FIFO.1 = 0                      ' RXBE = 0 -> a byte is waiting
            bChar = U2RXB
            If bKnown = 0 Then GoSub Wire_Decide
            GoSub Tx_Char
        Wend
        '--- SW0 -------------------------------------------------------------
        If PORTA.0 <> bSwOld Then
            bSwOld = PORTA.0
            If bSwOld = 0 Then GoSub Tx_Sw
        EndIf
        '--- every 500 ms (poll every 50 us so no received byte is lost) -----
        DelayUS 50
        Inc bTick
        If bTick >= 10000 Then
            bTick = 0
            If LATD.0 = 1 Then                  ' optional external LED on RD0 (always safe)
                LATD.0 = 0
            Else
                LATD.0 = 1
            EndIf
            If bWires = 0 Then                  ' never drive RC7 when the wires are fitted
                If LATC.7 = 1 Then
                    LATC.7 = 0
                Else
                    LATC.7 = 1
                EndIf
            EndIf
            GoSub Tx_Hello
        EndIf
    Loop

Tx_Char:
    Repeat : Until U2FIFO.4 = 0                 ' TXBF = 0 -> room in the buffer
    U2TXB = bChar
    Return

Tx_CrLf:
    bChar = 13 : GoSub Tx_Char
    bChar = 10 : GoSub Tx_Char
    Return

Tx_Hello:
    bChar = "H" : GoSub Tx_Char : bChar = "e" : GoSub Tx_Char : bChar = "l" : GoSub Tx_Char
    bChar = "l" : GoSub Tx_Char : bChar = "o" : GoSub Tx_Char : bChar = "/" : GoSub Tx_Char
    bChar = "M" : GoSub Tx_Char : bChar = "e" : GoSub Tx_Char : bChar = "r" : GoSub Tx_Char
    bChar = "h" : GoSub Tx_Char : bChar = "a" : GoSub Tx_Char : bChar = "b" : GoSub Tx_Char
    bChar = "a" : GoSub Tx_Char : bChar = " " : GoSub Tx_Char
    bChar = "0" + bCount : GoSub Tx_Char
    If bKnown = 0 Then                          ' LED0 waits for the first key (safe wire check)
        bChar = " " : GoSub Tx_Char : bChar = "(" : GoSub Tx_Char : bChar = "L" : GoSub Tx_Char
        bChar = "E" : GoSub Tx_Char : bChar = "D" : GoSub Tx_Char : bChar = ":" : GoSub Tx_Char
        bChar = " " : GoSub Tx_Char : bChar = "E" : GoSub Tx_Char : bChar = "n" : GoSub Tx_Char
        bChar = "t" : GoSub Tx_Char : bChar = "e" : GoSub Tx_Char : bChar = "r" : GoSub Tx_Char
        bChar = ")" : GoSub Tx_Char
    EndIf
    GoSub Tx_CrLf
    Inc bCount
    If bCount > 9 Then bCount = 0
    Return

Tx_Sw:
    bChar = "S" : GoSub Tx_Char : bChar = "W" : GoSub Tx_Char : bChar = "0" : GoSub Tx_Char
    GoSub Tx_CrLf
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
