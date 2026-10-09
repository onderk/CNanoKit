' CNANO_WIREDIAG - private bench test: are the FREELOADER wires (RC6-RB4, RB5-RC7) fitted?
' Never drives RC7. Reports over UART2 (RB4/RB5, 115200).
    Device = 18F56Q71
    Declare Xtal = 64
    Dim sTx As String * 64
    Dim bChar As Byte
    Dim bI As Byte
    Dim bW1 As Bit
    Dim bW2 As Bit
    Dim bW3 As Bit
    Dim bW4 As Bit
    Dim bW5 As Bit
    Dim bW6 As Bit
    Dim wLow5 As Word
    Dim wLow7 As Word
    Dim wN As Word
    OSCCON1 = $60
    OSCFRQ  = $08
    ANSELA = 0 : ANSELB = 0 : ANSELC = 0
    TRISC.7 = 1 : WPUC.7 = 1                   ' RC7 input with pull-up, never driven
    ' T1: RB4 drives, RC6 reads (pull-up on RC6)
    TRISC.6 = 1 : WPUC.6 = 1
    LATB.4 = 1 : TRISB.4 = 0 : DelayUS 50
    LATB.4 = 0 : DelayUS 20 : bW1 = PORTC.6
    LATB.4 = 1 : DelayUS 20 : bW2 = PORTC.6
    LATB.4 = 0 : DelayUS 20 : bW3 = PORTC.6
    LATB.4 = 1
    ' T2: RC6 drives, RB4 reads (pull-up on RB4)
    TRISB.4 = 1 : WPUB.4 = 1 : WPUC.6 = 0
    LATC.6 = 1 : TRISC.6 = 0 : DelayUS 50
    LATC.6 = 0 : DelayUS 20 : bW4 = PORTB.4
    LATC.6 = 1 : DelayUS 20 : bW5 = PORTB.4
    LATC.6 = 0 : DelayUS 20 : bW6 = PORTB.4
    LATC.6 = 1 : TRISC.6 = 1 : WPUB.4 = 0
    ' UART2
    LATB.4 = 1 : TRISB.4 = 0
    RB4PPS = PPS_Fn_TX2
    U2RXPPS = ((1 << 3) | 5)
    U2BRGH = 0 : U2BRGL = 138
    U2CON0 = ((1 << 7) | (1 << 5) | (1 << 4))
    U2CON1 = (1 << 7)
    Do
        While U2FIFO.1 = 0
            bChar = U2RXB
            If bChar = "?" Then GoSub Report
            If bChar = "w" Then GoSub Watch
        Wend
    Loop
Report:
    sTx = "T1 RB4->RC6 read: " + Str$(Dec bW1) + Str$(Dec bW2) + Str$(Dec bW3) + "  (010 = wire1 fitted)"
    GoSub Tx_Line
    sTx = "T2 RC6->RB4 read: " + Str$(Dec bW4) + Str$(Dec bW5) + Str$(Dec bW6) + "  (010 = wire1 fitted)"
    GoSub Tx_Line
    Return
Watch:                                          ' sample RB5 and RC7 for ~200 ms while the PC sends 0x00
    wLow5 = 0 : wLow7 = 0 : wN = 0
    Repeat
        If PORTB.5 = 0 Then Inc wLow5
        If PORTC.7 = 0 Then Inc wLow7
        While U2FIFO.1 = 0
            bChar = U2RXB
        Wend
        Inc wN
        DelayUS 5
    Until wN >= 20000
    sTx = "T3 low samples RB5=" + Str$(Dec wLow5) + " RC7=" + Str$(Dec wLow7) + "  (similar = wire2 fitted)"
    GoSub Tx_Line
    Return
Tx_Line:
    bI = 0
    While bI < Len(sTx)
        Repeat : Until U2FIFO.4 = 0
        U2TXB = sTx[bI]
        Inc bI
    Wend
    Repeat : Until U2FIFO.4 = 0
    U2TXB = 13
    Repeat : Until U2FIFO.4 = 0
    U2TXB = 10
    Return
Config_Start
    FEXTOSC = OFF
    RSTOSC = HFINTOSC_64MHZ
    CLKOUTEN = OFF
    PR1WAY = OFF
    CSWEN = On
    BBEN = OFF
    FCMEN = OFF
    FCMENP = OFF
    FCMENS = OFF
    MCLRE = EXTMCLR
    PWRTS = PWRT_64
    MVECEN = OFF
    IVT1WAY = OFF
    LPBOREN = OFF
    BOREN = SBORDIS
    BORV = VBOR_2P45
    ZCD = OFF
    PPS1WAY = OFF
    STVREN = On
    LVP = On
    XINST = OFF
    Debug = OFF
    WDTCPS = WDTCPS_31
    WDTE = OFF
    WDTCWS = WDTCWS_7
    WDTCCS = SC
    WRTB = OFF
    WRTC = OFF
    WRTD = OFF
    WRTSAF = OFF
    WRTAPP = OFF
    CPD = OFF
    Cp = OFF
Config_End
