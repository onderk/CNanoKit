' BANK_REPRO_56Q71 - minimal test for Positron8 4.0.6.4, okmn, 02 Oct 2026
' Compile only and open the .asm. Look at the two marked lines.
    Device = 18F56Q71
    Declare Xtal = 64

    Dim bFlag  As Bit
    Dim bCount As Byte

    ANSELD = 0
    TRISD  = 0
    LATD   = 0
    Do
        Inc bCount                      ' BASIC works in the variables' bank (5)
        If bFlag = 1 Then
            bFlag = 0
        Else
            bFlag = 1
        EndIf
        LATD.2 = bFlag                  ' (A) bit variable -> SFR bit, in-line
        GoSub Copy_Flag
        DelayMS 500
    Loop

Copy_Flag:
    LATD.0 = bFlag                      ' (B) bit variable -> SFR bit, first line after a label
    LATD.1 = 1                          ' (C) constant -> SFR bit (for comparison)
    Return
