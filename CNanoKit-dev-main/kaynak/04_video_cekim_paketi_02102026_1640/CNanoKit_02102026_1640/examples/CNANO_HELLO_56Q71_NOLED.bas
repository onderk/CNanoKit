'****************************************************************************
'*  CNANO_HELLO_56Q71.bas - first program for the PIC18F56Q71 Curiosity Nano  *
'*  CNANO_HELLO_56Q71.bas - PIC18F56Q71 Curiosity Nano icin ilk program        *
'*                                                                          *
'*  - sends "Hello / Merhaba n" every 500 ms over UART2 -> kit USB COM port *
'*  - echoes every character you type in CNano Monitor                     *
'*  - reports SW0 presses                                                   *
'*  - blinks LED0 when USE_LED = 1                                          *
'*                                                                          *
'*  Kit pins (Microchip user guide DS50003481A):                            *
'*    UART2 TX = RB4 -> kit "CDC RX"   UART2 RX = RB5 <- kit "CDC TX"       *
'*    LED0 = RC7 (active low)          SW0 = RA0 (to GND, use pull-up)      *
'*  PPS (data sheet DS40002329F): RB4PPS = 0x18 (UART2 TX),                 *
'*    U2RXPPS = 'b001 101 (RB5)                                             *
'*                                                                          *
'*  USE_LED = 0 if jumper wires are fitted on RC7 (FREELOADER test wiring)  *
'*  MIT licence.  okmn 2026.                                                *
'****************************************************************************
    Device = 18F56Q71
    Declare Xtal = 64

$define USE_LED 0

    Dim bCount As Byte
    Dim bChar  As Byte
    Dim bTick  As Word
    Dim bSwOld As Bit

'--- clock: HFINTOSC 64 MHz (OSCFRQ FRQ = 1000) -----------------------------
    OSCCON1 = $60
    OSCFRQ  = $08

'--- ports -------------------------------------------------------------------
    ANSELA = 0 : ANSELB = 0 : ANSELC = 0
    WPUA.0 = 1                                  ' SW0 pull-up
    WPUB.5 = 1                                  ' RB5 pull-up (CDC line floats until the PC opens the port)
$if USE_LED = 1
    LATC.7 = 1 : TRISC.7 = 0                    ' LED0 off, output
$endif

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
$if USE_LED = 1
            If LATC.7 = 1 Then
                LATC.7 = 0
            Else
                LATC.7 = 1
            EndIf
$endif
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
    GoSub Tx_CrLf
    Inc bCount
    If bCount > 9 Then bCount = 0
    Return

Tx_Sw:
    bChar = "S" : GoSub Tx_Char : bChar = "W" : GoSub Tx_Char : bChar = "0" : GoSub Tx_Char
    GoSub Tx_CrLf
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
