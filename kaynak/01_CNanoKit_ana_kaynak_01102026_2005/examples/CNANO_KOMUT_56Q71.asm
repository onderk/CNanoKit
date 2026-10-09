;   /\\\\\\\\\
;  /\\\///////\\\
;  \/\\\     \/\\\                                                 /\\\          /\\\
;   \/\\\\\\\\\\\/        /\\\\\     /\\\\\\\\\\     /\\\\\\\\   /\\\\\\\\\\\  /\\\\\\\\\\\  /\\\\\\\\\
;    \/\\\//////\\\      /\\\///\\\  \/\\\//////    /\\\/////\\\ \////\\\////  \////\\\////  \////////\\\
;     \/\\\    \//\\\    /\\\  \//\\\ \/\\\\\\\\\\  /\\\\\\\\\\\     \/\\\         \/\\\        /\\\\\\\\\\
;      \/\\\     \//\\\  \//\\\  /\\\  \////////\\\ \//\\///////      \/\\\ /\\     \/\\\ /\\   /\\\/////\\\
;       \/\\\      \//\\\  \///\\\\\/    /\\\\\\\\\\  \//\\\\\\\\\\    \//\\\\\      \//\\\\\   \//\\\\\\\\/\\
;        \///        \///     \/////     \//////////    \//////////      \/////        \/////     \////////\//
;                                  Let's find out together what makes a PIC Tick!
;
; Code Produced by the Positron8 Compiler. Version 4.0.6.4
; Created and Written by Les Johnson. 
; Compiler version for Önder Kaman
;----------------------------------------------------------
;
#define config_req 1
 LIST  P = 18F56Q71, F = INHX32, W = 2, X = ON, R = DEC, MM = ON, N = 0, C = 255, T = ON
; MICROCONTROLLER'S SFRS
CLKRCON equ 0x39
CLKRCLK equ 0x3A
NVMCON0 equ 0x40
NVMCON1 equ 0x41
EECON1 equ 0x41
NVMLOCK equ 0x42
NVMADRL equ 0x43
EEADRL equ 0x43
NVMADRH equ 0x44
NVMADRLH equ 0x44
EEADRH equ 0x44
EEADRLH equ 0x44
NVMADRU equ 0x45
NVMADRLHH equ 0x45
NVMADRLHHH equ 0X04E8
EEADRHH equ 0x45
EEADRHHH equ 0X04E8
EEADRLHH equ 0x45
EEADRLHHH equ 0X04E8
NVMDATL equ 0x46
NVMDATAL equ 0x46
EEDATL equ 0x46
EEDATAL equ 0x46
NVMDATH equ 0x47
NVMDATAH equ 0x47
EEDATH equ 0x47
EEDATAH equ 0x47
VREGCON equ 0x48
BORCON equ 0x49
HLVDCON0 equ 0x4A
HLVDCON1 equ 0x4B
ZCDCON equ 0x4C
PMD0 equ 0x62
PMD1 equ 0x63
PMD2 equ 0x64
PMD3 equ 0x65
PMD4 equ 0x66
PMD5 equ 0x67
PMD6 equ 0x68
CMOUT equ 0x6F
CM1CON0 equ 0x70
CM1CON1 equ 0x71
CM1NCH equ 0x72
CM1PCH equ 0x73
CM2CON0 equ 0x74
CM2CON1 equ 0x75
CM2NCH equ 0x76
CM2PCH equ 0x77
WDTCON0 equ 0x78
WDTCON1 equ 0x79
WDTPSL equ 0x7A
WDTPSH equ 0x7B
WDTPSLH equ 0x7B
WDTTMR equ 0x7C
DAC1DATL equ 0x7D
DAC1DATH equ 0x7E
DAC1CON equ 0x7F
SPI1RXB equ 0x80
SPI1TXB equ 0x81
SPI1TCNTL equ 0x82
SPI1TCNTH equ 0x83
SPI1TCNTLH equ 0x83
SPI1CON0 equ 0x84
SPI1CON1 equ 0x85
SPI1CON2 equ 0x86
SPI1STATUS equ 0x87
SPI1TWIDTH equ 0x88
SPI1BAUD equ 0x89
SPI1INTF equ 0x8A
SPI1INTE equ 0x8B
SPI1CLK equ 0x8C
ACTCON equ 0xAC
OSCCON1 equ 0xAD
OSCCON2 equ 0xAE
OSCCON3 equ 0xAF
OSCTUNE equ 0xB0
OSCFRQ equ 0xB1
OSCFREQ equ 0xB1
OSCSTAT equ 0xB2
OSCSTAT1 equ 0xB2
OSCEN equ 0xB3
PRLOCK equ 0xB4
SCANPR equ 0xB5
DMA1PR equ 0xB6
DMA2PR equ 0xB7
DMA3PR equ 0xB8
DMA4PR equ 0xB9
MAINPR equ 0xBE
ISRPR equ 0xBF
DAC2DAT equ 0xC0
DAC2DATL equ 0xC0
DAC2CON equ 0xC2
DAC3DAT equ 0xC3
DAC3DATL equ 0xC3
DAC3CON equ 0xC5
CLCDATA equ 0xD4
CLCSELECT equ 0xD5
CLCNCON equ 0xD6
CLCNPOL equ 0xD7
CLCNSEL0 equ 0xD8
CLCNSEL1 equ 0xD9
CLCNSEL2 equ 0xDA
CLCNSEL3 equ 0xDB
CLCNGLS0 equ 0xDC
CLCNGLS1 equ 0xDD
CLCNGLS2 equ 0xDE
CLCNGLS3 equ 0xDF
DMASELECT equ 0xE8
DMANBUF equ 0xE9
DMANDCNTL equ 0xEA
DMANDCNTH equ 0xEB
DMANDCNTLH equ 0xEB
DMANDPTRL equ 0xEC
DMANDPTRH equ 0xED
DMANDPTRLH equ 0xED
DMANDSZL equ 0xEE
DMANDSZH equ 0xEF
DMANDSZLH equ 0xEF
DMANDSAL equ 0xF0
DMANDSAH equ 0xF1
DMANDSAH equ 0xF1
DMANSCNTL equ 0xF2
DMANSCNTH equ 0xF3
DMANSCNTLH equ 0xF3
DMANSPTRL equ 0xF4
DMANSPTRH equ 0xF5
DMANSPTRLH equ 0xF5
DMANSPTRU equ 0xF6
DMANSPTRLHH equ 0xF6
DMANSPTRLHHH equ 0X04E8
DMANSSZL equ 0xF7
DMANSSZH equ 0xF8
DMANSSZLH equ 0xF8
DMANSSAL equ 0xF9
DMANSSAH equ 0xFA
DMANSSALH equ 0xFA
DMANSSAU equ 0xFB
DMANSSALHH equ 0xFB
DMANSSALHHH equ 0X04E8
DMANCON0 equ 0xFC
DMANCON1 equ 0xFD
DMANAIRQ equ 0xFE
DMANSIRQ equ 0xFF
; START OF SFR RAM BANK 1
PORTW equ 0X0100
LATW equ 0X0101
PORTWIN0 equ 0X0102
PORTWIN1 equ 0X0103
PORTWIN2 equ 0X0104
PORTWIN3 equ 0X0105
PORTWIN4 equ 0X0106
PORTWIN5 equ 0X0107
PORTWIN6 equ 0X0108
PORTWIN7 equ 0X0109
PORTWCLK equ 0X010A
PORTWDF equ 0X010B
PORTWCON equ 0X010C
ADCGA equ 0X0110
ADCGB equ 0X0111
ADCGC equ 0X0112
ADCGD equ 0X0113
ADCGE equ 0X0114
ADCGF equ 0X0115
OPA1CON0 equ 0X011F
OPA1CON1 equ 0X0120
OPA1CON2 equ 0X0121
OPA1CON3 equ 0X0122
OPA1CON4 equ 0X0123
OPA1HWC equ 0X0124
OPA1OFFSET equ 0X0125
OPA1ORS equ 0X0126
OPA2CON0 equ 0X0127
OPA2CON1 equ 0X0128
OPA2CON2 equ 0X0129
OPA2CON3 equ 0X012A
OPA2CON4 equ 0X012B
OPA2HWC equ 0X012C
OPA2OFFSET equ 0X012D
OPA2ORS equ 0X012E
LATA equ 0X0140
LATB equ 0X0141
LATC equ 0X0142
LATD equ 0X0143
LATE equ 0X0144
LATF equ 0X0145
TRISA equ 0X0148
TRISB equ 0X0149
TRISC equ 0X014A
TRISD equ 0X014B
TRISE equ 0X014C
TRISF equ 0X014D
PORTA equ 0X0150
PORTB equ 0X0151
PORTC equ 0X0152
PORTD equ 0X0153
PORTE equ 0X0154
PORTF equ 0X0155
APMCON equ 0X01C0
APMPREL equ 0X01C1
APMPREH equ 0X01C2
APMPERL equ 0X01C3
APMPERH equ 0X01C4
APMSTART1L equ 0X01C5
APMSTART1H equ 0X01C6
APMPERS1L equ 0X01C7
APMPERS1H equ 0X01C8
APMSTART2L equ 0X01C9
APMSTART2H equ 0X01CA
APMSTART2U equ 0X01CB
APMPERS2L equ 0X01CC
APMPERS2H equ 0X01CD
APMEND1L equ 0X01CE
APMEND1H equ 0X01CF
APMEND1U equ 0X01D0
APMPERE1L equ 0X01D1
APMPERE1H equ 0X01D2
APMEND2L equ 0X01D3
APMEND2H equ 0X01D4
APMEND2U equ 0X01D5
APMPERE2L equ 0X01D6
APMPERE2H equ 0X01D7
APMCLK equ 0X01D8
APMSTATUSL equ 0X01D9
APMSTATUSH equ 0X01DA
; START OF SFR RAM BANK 2
PPSLOCK equ 0X0200
RA0PPS equ 0X0201
RA1PPS equ 0X0202
RA2PPS equ 0X0203
RA3PPS equ 0X0204
RA4PPS equ 0X0205
RA5PPS equ 0X0206
RA6PPS equ 0X0207
RA7PPS equ 0X0208
RB0PPS equ 0X0209
RB1PPS equ 0X020A
RB2PPS equ 0X020B
RB3PPS equ 0X020C
RB4PPS equ 0X020D
RB5PPS equ 0X020E
RB6PPS equ 0X020F
RB7PPS equ 0X0210
RC0PPS equ 0X0211
RC1PPS equ 0X0212
RC2PPS equ 0X0213
RC3PPS equ 0X0214
RC4PPS equ 0X0215
RC5PPS equ 0X0216
RC6PPS equ 0X0217
RC7PPS equ 0X0218
RD0PPS equ 0X0219
RD1PPS equ 0X021A
RD2PPS equ 0X021B
RD3PPS equ 0X021C
RD4PPS equ 0X021D
RD5PPS equ 0X021E
RD6PPS equ 0X021F
RD7PPS equ 0X0220
RE0PPS equ 0X0221
RE1PPS equ 0X0222
RE2PPS equ 0X0223
RF0PPS equ 0X0225
RF1PPS equ 0X0226
RF2PPS equ 0X0227
RF3PPS equ 0X0228
RF4PPS equ 0X0229
RF5PPS equ 0X022A
RF6PPS equ 0X022B
RF7PPS equ 0X022C
INT0PPS equ 0X023E
INT1PPS equ 0X023F
INT2PPS equ 0X0240
T0CKIPPS equ 0X0241
T1CKIPPS equ 0X0242
T1GPPS equ 0X0243
T3CKIPPS equ 0X0244
T3GPPS equ 0X0245
T2INPPS equ 0X0248
T4INPPS equ 0X0249
CCP1PPS equ 0X024F
CCP2PPS equ 0X0250
PWM1ERSPPS equ 0X0251
PWM2ERSPPS equ 0X0252
PWM3ERSPPS equ 0X0253
PWMIN0PPS equ 0X0257
PWMIN1PPS equ 0X0258
CWG1PPS equ 0X025B
CWG1INPPS equ 0X025B
CLCIN0PPS equ 0X0261
CLCIN1PPS equ 0X0262
CLCIN2PPS equ 0X0263
CLCIN3PPS equ 0X0264
CLCIN4PPS equ 0X0265
CLCIN5PPS equ 0X0266
CLCIN6PPS equ 0X0267
CLCIN7PPS equ 0X0268
ADACTPPS equ 0X0269
SPI1SCKPPS equ 0X026A
SPI1SDIPPS equ 0X026B
SPI1SSPPS equ 0X026C
I2C1SDAPPS equ 0X0270
I2C1SCLPPS equ 0X0271
U1RXPPS equ 0X0272
U1CTSPPS equ 0X0273
U2RXPPS equ 0X0274
U2CTSPPS equ 0X0275
OPA1ORPPS equ 0X0276
OPA2ORPPS equ 0X0277
TUIN0PPS equ 0X0278
TUIN1PPS equ 0X0279
APMCLKPPS equ 0X027A
RB2I2C equ 0X0285
RB1I2C equ 0X0286
RC4I2C equ 0X0287
RC3I2C equ 0X0288
I2C1RXB equ 0X0289
I2C1TXB equ 0X028A
I2C1CNTL equ 0X028B
I2C1CNTH equ 0X028C
I2C1CNTLH equ 0X028C
I2C1ADB0 equ 0X028D
I2C1ADB1 equ 0X028E
I2C1ADR0 equ 0X028F
I2C1ADR1 equ 0X0290
I2C1ADR2 equ 0X0291
I2C1ADR3 equ 0X0292
I2C1CON0 equ 0X0293
I2C1CON1 equ 0X0294
I2C1CON2 equ 0X0295
I2C1CON3 equ 0X0296
I2C1ERR equ 0X0297
I2C1STAT0 equ 0X0298
I2C1STAT1 equ 0X0299
I2C1PIR equ 0X029A
I2C1PIE equ 0X029B
I2C1BTO equ 0X029C
I2C1BAUD equ 0X029D
I2C1CLK equ 0X029E
I2C1BTOC equ 0X029F
U1RXB equ 0X02A0
U1RXBL equ 0X02A0
U1RXCHK equ 0X02A1
U1TXB equ 0X02A2
U1TXBL equ 0X02A2
U1TXCHK equ 0X02A3
U1P1L equ 0X02A4
U1P1H equ 0X02A5
U1P1LH equ 0X02A5
U1P2L equ 0X02A6
U1P2H equ 0X02A7
U1P2LH equ 0X02A7
U1P3L equ 0X02A8
U1P3H equ 0X02A9
U1P3LH equ 0X02A9
U1CON0 equ 0X02AA
U1CON1 equ 0X02AB
U1CON2 equ 0X02AC
U1BRGL equ 0X02AD
U1BRGH equ 0X02AE
U1BRGLH equ 0X02AE
U1FIFO equ 0X02AF
U1UIR equ 0X02B0
U1ERRIR equ 0X02B1
U1ERRIE equ 0X02B2
U2RXB equ 0X02B4
U2RXBL equ 0X02B4
U2TXB equ 0X02B6
U2TXBL equ 0X02B6
U2P1 equ 0X02B8
U2P1L equ 0X02B8
U2P2 equ 0X02BA
U2P2L equ 0X02BA
U2P3 equ 0X02BC
U2P3L equ 0X02BC
U2CON0 equ 0X02BE
U2CON1 equ 0X02BF
U2CON2 equ 0X02C0
U2BRGL equ 0X02C1
U2BRGH equ 0X02C2
U2BRGLH equ 0X02C2
U2FIFO equ 0X02C3
U2UIR equ 0X02C4
U2ERRIR equ 0X02C5
U2ERRIE equ 0X02C6
TMR1L equ 0X0312
TMR1H equ 0X0313
TMR1LH equ 0X0313
T1CON equ 0X0314
TMR1CON equ 0X0314
T1GCON equ 0X0315
TMR1GCON equ 0X0315
T1GATE equ 0X0316
TMR1GATE equ 0X0316
T1CLK equ 0X0317
TMR1CLK equ 0X0317
PR1 equ 0X0317
TMR0L equ 0X0318
TMR0 equ 0X0318
TMR0H equ 0X0319
TMR0LH equ 0X0319
PR0 equ 0X0319
T0CON0 equ 0X031A
T0CON1 equ 0X031B
T2TMR equ 0X031D
TMR2 equ 0X031D
T2PR equ 0X031E
PR2 equ 0X031E
T2CON equ 0X031F
T2HLT equ 0X0320
T2CLKCON equ 0X0321
T2CLK equ 0X0321
T2RST equ 0X0322
TMR3L equ 0X0323
TMR3H equ 0X0324
TMR3LH equ 0X0324
T3CON equ 0X0325
TMR3CON equ 0X0325
T3GCON equ 0X0326
TMR3GCON equ 0X0326
T3GATE equ 0X0327
TMR3GATE equ 0X0327
T3CLK equ 0X0328
TMR3CLK equ 0X0328
PR3 equ 0X0328
T4TMR equ 0X032A
TMR4 equ 0X032A
T4PR equ 0X032B
PR4 equ 0X032B
T4CON equ 0X032C
T4HLT equ 0X032D
T4CLKCON equ 0X032E
T4CLK equ 0X032E
T4RST equ 0X032F
CCPR1L equ 0X0340
CCPR1H equ 0X0341
CCPR1LH equ 0X0341
CCP1CON equ 0X0342
CCP1CAP equ 0X0343
CCPR2L equ 0X0344
CCPR2H equ 0X0345
CCPR2LH equ 0X0345
CCP2CON equ 0X0346
CCP2CAP equ 0X0347
CCPTMRS0 equ 0X034C
CRCDATAL equ 0X034E
CRCDATAH equ 0X034F
CRCDATALH equ 0X034F
CRCDATAU equ 0X0350
CRCDATALHH equ 0X0350
CRCDATAT equ 0X0351
CRCOUTL equ 0X0352
CRCSHFTL equ 0X0352
CRCSHIFTL equ 0X0352
CRCXORL equ 0X0352
CRCOUTH equ 0X0353
CRCOUTLH equ 0X0353
CRCSHFTH equ 0X0353
CRCSHFTLH equ 0X0353
CRCSHIFTH equ 0X0353
CRCSHIFTLH equ 0X0353
CRCXORH equ 0X0353
CRCXORLH equ 0X0353
CRCOUTU equ 0X0354
CRCOUTLHH equ 0X0354
CRCSHFTU equ 0X0354
CRCSHFTLHH equ 0X0354
CRCSHIFTU equ 0X0354
CRCSHIFTLHH equ 0X0354
CRCXORU equ 0X0354
CRCXORLHH equ 0X0354
CRCOUTT equ 0X0355
CRCSHFTT equ 0X0355
CRCSHIFTT equ 0X0355
CRCXORT equ 0X0355
CRCCON0 equ 0X0356
CRCCON1 equ 0X0357
CRCCON2 equ 0X0358
SCANLADRL equ 0X035A
SCANLADRH equ 0X035B
SCANLADRLH equ 0X035B
SCANLADRU equ 0X035C
SCANLADRLHH equ 0X035C
SCANLADRLHHH equ 0X04E8
SCANHADRL equ 0X035D
SCANHADRH equ 0X035E
SCANHADRLH equ 0X035E
SCANHADRU equ 0X035F
SCANHADRLHH equ 0X035F
SCANHADRLHHH equ 0X04E8
SCANCON0 equ 0X0360
SCANTRIG equ 0X0361
STATUS_CSHAD equ 0X0373
WREG_CSHAD equ 0X0374
BSR_CSHAD equ 0X0375
SHADCON equ 0X0376
STATUS_SHAD equ 0X0377
WREG_SHAD equ 0X0378
BSR_SHAD equ 0X0379
PCLATH_SHAD equ 0X037A
PCLATLH_SHAD equ 0X037A
PCLATU_SHAD equ 0X037B
PCLATHH_SHAD equ 0X037B
PCLATHHH equ 0X04E8
FSR0L_SHAD equ 0X037C
FSR0H_SHAD equ 0X037D
FSR0LH_SHAD equ 0X037D
FSR1L_SHAD equ 0X037E
FSR1H_SHAD equ 0X037F
FSR1LH_SHAD equ 0X037F
FSR2L_SHAD equ 0X0380
FSR2H_SHAD equ 0X0381
FSR2LH_SHAD equ 0X0381
PRODL_SHAD equ 0X0382
PRODH_SHAD equ 0X0383
PRODLH_SHAD equ 0X0383
TU16ACON0 equ 0X03A0
TU16ACON1 equ 0X03A1
TU16AHLT equ 0X03A2
TU16APS equ 0X03A3
TU16ATMRL equ 0X03A4
TU16ACRL equ 0X03A4
TU16ATMRH equ 0X03A5
TU16ACRH equ 0X03A5
TU16APRL equ 0X03A6
TU16APRH equ 0X03A7
TU16ACLK equ 0X03A8
TU16AERS equ 0X03A9
TU16BCON0 equ 0X03AA
TU16BCON1 equ 0X03AB
TU16BHLT equ 0X03AC
TU16BPS equ 0X03AD
TU16BTMRL equ 0X03AE
TU16BCRL equ 0X03AE
TU16BTMRH equ 0X03AF
TU16BCRH equ 0X03AF
TU16BPRL equ 0X03B0
TU16BPRH equ 0X03B1
TU16BCLK equ 0X03B2
TU16BERS equ 0X03B3
TUCHAIN equ 0X03B4
CWG1CLK equ 0X03BC
CWG1CLKCON equ 0X03BC
CWG1ISM equ 0X03BD
CWG1DAT equ 0X03BD
CWG1DBR equ 0X03BE
CWG1DBF equ 0X03BF
CWG1CON0 equ 0X03C0
CWG1CON1 equ 0X03C1
CWG1AS0 equ 0X03C2
CWG1AS1 equ 0X03C3
CWG1STR equ 0X03C4
FVRCON equ 0X03D7
ADCPCON equ 0X03D8
ADCP equ 0X03D8
ADLTHL equ 0X03D9
ADLTHH equ 0X03DA
ADLTHLH equ 0X03DA
ADUTHL equ 0X03DB
ADUTHH equ 0X03DC
ADUTHLH equ 0X03DC
ADERRL equ 0X03DD
ADERRH equ 0X03DE
ADERRLH equ 0X03DE
ADSTPTL equ 0X03DF
ADSTPTH equ 0X03E0
ADSTPTLH equ 0X03E0
ADFLTRL equ 0X03E1
ADFLTRH equ 0X03E2
ADFLTRLH equ 0X03E2
ADACCL equ 0X03E3
ADACCH equ 0X03E4
ADACCLH equ 0X03E4
ADACCU equ 0X03E5
ADACCLHH equ 0X03E5
ADACCLHHH equ 0X04E8
ADCNT equ 0X03E6
ADRPT equ 0X03E7
ADPREVL equ 0X03E8
ADPREVH equ 0X03E9
ADPREVLH equ 0X03E9
ADRESL equ 0X03EA
ADRESH equ 0X03EB
ADRESLH equ 0X03EB
ADPCH equ 0X03EC
ADNCH equ 0X03ED
ADACQL equ 0X03EE
ADACQH equ 0X03EF
ADACQLH equ 0X03EF
ADCAP equ 0X03F0
ADPREL equ 0X03F1
ADPREH equ 0X03F2
ADPRELH equ 0X03F2
ADCON0 equ 0X03F3
ADCON1 equ 0X03F4
ADCON2 equ 0X03F5
ADCON3 equ 0X03F6
ADSTAT equ 0X03F7
ADREF equ 0X03F8
ADACT equ 0X03F9
ADCLK equ 0X03FA
ADCTX equ 0X03FB
ADCSEL1 equ 0X03FC
ADCSEL2 equ 0X03FD
ADCSEL3 equ 0X03FE
ADCSEL4 equ 0X03FF
; START OF SFR RAM BANK 4
ANSELA equ 0X0400
WPUA equ 0X0401
ODCONA equ 0X0402
SLRCONA equ 0X0403
INLVLA equ 0X0404
IOCAP equ 0X0405
IOCAN equ 0X0406
IOCAF equ 0X0407
ANSELB equ 0X0408
WPUB equ 0X0409
ODCONB equ 0X040A
SLRCONB equ 0X040B
INLVLB equ 0X040C
IOCBP equ 0X040D
IOCBN equ 0X040E
IOCBF equ 0X040F
ANSELC equ 0X0410
WPUC equ 0X0411
ODCONC equ 0X0412
SLRCONC equ 0X0413
INLVLC equ 0X0414
IOCCP equ 0X0415
IOCCN equ 0X0416
IOCCF equ 0X0417
ANSELD equ 0X0418
WPUD equ 0X0419
ODCOND equ 0X041A
SLRCOND equ 0X041B
INLVLD equ 0X041C
ANSELE equ 0X0420
WPUE equ 0X0421
ODCONE equ 0X0422
SLRCONE equ 0X0423
INLVLE equ 0X0424
IOCEP equ 0X0425
IOCEN equ 0X0426
IOCEF equ 0X0427
ANSELF equ 0X0428
WPUF equ 0X0429
ODCONF equ 0X042A
SLRCONF equ 0X042B
INLVLF equ 0X042C
IOCWP equ 0X043D
IOCWN equ 0X043E
IOCWF equ 0X043F
NCO1ACCL equ 0X0440
NCO1ACCH equ 0X0441
NCO1ACCLH equ 0X0441
NCO1ACCU equ 0X0442
NCO1ACCLHH equ 0X0442
NCO1ACCLHHH equ 0X04E8
NCO1INCL equ 0X0443
NCO1INCH equ 0X0444
NCO1INCLH equ 0X0444
NCO1INCU equ 0X0445
NCO1INCLHH equ 0X0445
NCO1INCLHHH equ 0X04E8
NCO1CON equ 0X0446
NCO1CLK equ 0X0447
FSCMCON equ 0X0458
IVTLOCK equ 0X0459
IVTADL equ 0X045A
IVTADH equ 0X045B
IVTADLH equ 0X045B
IVTADU equ 0X045C
IVTADLHH equ 0X045C
IVTADLHHH equ 0X04E8
IVTBASEL equ 0X045D
IVTBASEH equ 0X045E
IVTBASELH equ 0X045E
IVTBASEU equ 0X045F
IVTBASELHH equ 0X045F
IVTBASELHHH equ 0X04E8
; START OF ACCESS SFRS
PWM1ERS equ 0X0460
PWM1CLK equ 0X0461
PWM1LDS equ 0X0462
PWM1PRL equ 0X0463
PWM1PRH equ 0X0464
PWM1PRLH equ 0X0464
PWM1CPRE equ 0X0465
PWM1PIPOS equ 0X0466
PWM1GIR equ 0X0467
PWM1GIE equ 0X0468
PWM1CON equ 0X0469
PWM1S1CFG equ 0X046A
PWM1S1P1L equ 0X046B
PWM1S1P1H equ 0X046C
PWM1S1P1LH equ 0X046C
PWM1S1P2L equ 0X046D
PWM1S1P2H equ 0X046E
PWM1S1P2LH equ 0X046E
PWM2ERS equ 0X046F
PWM2CLK equ 0X0470
PWM2LDS equ 0X0471
PWM2PRL equ 0X0472
PWM2PRH equ 0X0473
PWM2PRLH equ 0X0473
PWM2CPRE equ 0X0474
PWM2PIPOS equ 0X0475
PWM2GIR equ 0X0476
PWM2GIE equ 0X0477
PWM2CON equ 0X0478
PWM2S1CFG equ 0X0479
PWM2S1P1L equ 0X047A
PWM2S1P1H equ 0X047B
PWM2S1P1LH equ 0X047B
PWM2S1P2L equ 0X047C
PWM2S1P2H equ 0X047D
PWM2S1P2LH equ 0X047D
PWM3ERS equ 0X047E
PWM3CLK equ 0X047F
PWM3LDS equ 0X0480
PWM3PRL equ 0X0481
PWM3PRH equ 0X0482
PWM3PRLH equ 0X0482
PWM3CPRE equ 0X0483
PWM3PIPOS equ 0X0484
PWM3GIR equ 0X0485
PWM3GIE equ 0X0486
PWM3CON equ 0X0487
PWM3S1CFG equ 0X0488
PWM3S1P1L equ 0X0489
PWM3S1P1H equ 0X048A
PWM3S1P1LH equ 0X048A
PWM3S1P2L equ 0X048B
PWM3S1P2H equ 0X048C
PWM3S1P2LH equ 0X048C
PWMLOAD equ 0X0499
PWMEN equ 0X049A
IPR0 equ 0X049C
IPR1 equ 0X049D
IPR2 equ 0X049E
IPR3 equ 0X049F
IPR4 equ 0X04A0
IPR5 equ 0X04A1
IPR6 equ 0X04A2
IPR7 equ 0X04A3
IPR8 equ 0X04A4
IPR9 equ 0X04A5
IPR10 equ 0X04A6
PIE0 equ 0X04A7
PIE1 equ 0X04A8
PIE2 equ 0X04A9
PIE3 equ 0X04AA
PIE4 equ 0X04AB
PIE5 equ 0X04AC
PIE6 equ 0X04AD
PIE7 equ 0X04AE
PIE8 equ 0X04AF
PIE9 equ 0X04B0
PIE10 equ 0X04B1
PIR0 equ 0X04B2
PIR1 equ 0X04B3
PIR2 equ 0X04B4
PIR3 equ 0X04B5
PIR4 equ 0X04B6
PIR5 equ 0X04B7
PIR6 equ 0X04B8
PIR7 equ 0X04B9
PIR8 equ 0X04BA
PIR9 equ 0X04BB
PIR10 equ 0X04BC
INTCON0 equ 0X04D6
INTCON1 equ 0X04D7
STATUS equ 0X04D8
FSR2L equ 0X04D9
FSR2H equ 0X04DA
FSR2LH equ 0X04DA
PLUSW2 equ 0X04DB
PREINC2 equ 0X04DC
POSTDEC2 equ 0X04DD
POSTINC2 equ 0X04DE
INDF2 equ 0X04DF
BSR equ 0X04E0
FSR1L equ 0X04E1
FSR1H equ 0X04E2
FSR1LH equ 0X04E2
PLUSW1 equ 0X04E3
PREINC1 equ 0X04E4
POSTDEC1 equ 0X04E5
POSTINC1 equ 0X04E6
INDF1 equ 0X04E7
WREG equ 0X04E8
FSR0L equ 0X04E9
FSR0H equ 0X04EA
FSR0LH equ 0X04EA
PLUSW0 equ 0X04EB
PREINC0 equ 0X04EC
POSTDEC0 equ 0X04ED
POSTINC0 equ 0X04EE
INDF0 equ 0X04EF
PCON0 equ 0X04F0
PCON1 equ 0X04F1
CPUDOZE equ 0X04F2
PRODL equ 0X04F3
PRODH equ 0X04F4
PRODLH equ 0X04F4
TABLAT equ 0X04F5
TBLPTRL equ 0X04F6
TBLPTRH equ 0X04F7
TBLPTRLH equ 0X04F7
TBLPTRU equ 0X04F8
TBLPTRLHH equ 0X04F8
TBLPTRLHHH equ 0X04E8
PCL equ 0X04F9
PCLATH equ 0X04FA
PCLATLH equ 0X04FA
PCLATU equ 0X04FB
PCLATHH equ 0X04FB
PCLATHHH equ 0X04E8
STKPTR equ 0X04FC
TOSL equ 0X04FD
TOSH equ 0X04FE
TOSLH equ 0X04FE
TOSU equ 0X04FF
TOSLHH equ 0X04FF
TOSLHHH equ 0X04E8
; I2C PINS USED BY HBUSIN AND HBUSOUT
_I2C_SDA_port = TRISC
_I2C_SDA_pin = 4
_I2C_SCL_port = TRISC
_I2C_SCL_pin = 3
; SFR BITS USED INTERNALLY BY THE COMPILER
C=0
DC=1
Z=2
OV=3
N=4
PD=5
To=6
PP_GO=0
PP_WRERR=7
PP_RDY=4
PP_SEN=7
PP_RD0=0
PP_RD1=1
PP_RD2=2
PP_RD3=3
PP_RD4=4
PP_RD5=5
PP_RD6=6
PP_RD7=7
PP_RD0PPS0=0
PP_RD0PPS1=1
PP_RD0PPS2=2
PP_RD0PPS3=3
PP_RD0PPS4=4
PP_RD0PPS5=5
PP_RD1PPS0=0
PP_RD1PPS1=1
PP_RD1PPS2=2
PP_RD1PPS3=3
PP_RD1PPS4=4
PP_RD1PPS5=5
PP_RD2PPS0=0
PP_RD2PPS1=1
PP_RD2PPS2=2
PP_RD2PPS3=3
PP_RD2PPS4=4
PP_RD2PPS5=5
PP_RD3PPS0=0
PP_RD3PPS1=1
PP_RD3PPS2=2
PP_RD3PPS3=3
PP_RD3PPS4=4
PP_RD3PPS5=5
PP_RD4PPS0=0
PP_RD4PPS1=1
PP_RD4PPS2=2
PP_RD4PPS3=3
PP_RD4PPS4=4
PP_RD4PPS5=5
PP_RD5PPS0=0
PP_RD5PPS1=1
PP_RD5PPS2=2
PP_RD5PPS3=3
PP_RD5PPS4=4
PP_RD5PPS5=5
PP_RD6PPS0=0
PP_RD6PPS1=1
PP_RD6PPS2=2
PP_RD6PPS3=3
PP_RD6PPS4=4
PP_RD6PPS5=5
PP_RD7PPS0=0
PP_RD7PPS1=1
PP_RD7PPS2=2
PP_RD7PPS3=3
PP_RD7PPS4=4
PP_RD7PPS5=5
PP_RSEN=6
PP_ACKDT=6
PP_WRIF=4
PP_WR1IF=4
PP_WRIE=4
PP_WR1IE=4
PP_SENDB=0
PP_RXBE=1
PP_RXFOIF=1
PP_RD16=1
PP_RD161=1
PP_T2CKPS0=4
PP_T2CKPS1=5
PP_T2CKPS2=6
PP_TMR2ON=7
PP_RD163=1
PP_TMR4ON=7
PP_C1TSEL0=0
PP_C1TSEL1=1
PP_C2TSEL0=2
PP_C2TSEL1=3
PP_RDSEL=3
PP_ADCS=4
PP_ADCSEN=5
PP_ADON=7
PP_GO_NOT_DONE=0
PP_GO_DONE=0
PP_ADCS0=0
PP_ADCS1=1
PP_ADCS2=2
PP_ADCS3=3
PP_ADCS4=4
PP_ADCS5=5
PP_U1RXIF=0
PP_U1TXIF=1
PP_U2RXIF=0
PP_U2TXIF=1
; PPS INTERNAL VALUES
_PPS_FN_ADGRDB=40
_PPS_FN_ADGRDA=39
_PPS_FN_CLKR=38
_PPS_FN_NCO1=37
_PPS_FN_TU16B=36
_PPS_FN_TU16A=35
_PPS_FN_TMR0=34
_PPS_FN_SDA1=33
_PPS_FN_SCL1=32
_PPS_FN_SS1=31
_PPS_FN_SDO1=30
_PPS_FN_SCK1=29
_PPS_FN_C2OUT=28
_PPS_FN_C1OUT=27
_PPS_FN_RTS2=26
_PPS_FN_TXDE2=25
_PPS_FN_TX2=24
_PPS_FN_RTS1=23
_PPS_FN_TXDE1=22
_PPS_FN_TX1=21
_PPS_FN_PWM32=20
_PPS_FN_PWM31=19
_PPS_FN_PWM22=18
_PPS_FN_PWM21=17
_PPS_FN_PWM12=16
_PPS_FN_PWM11=15
_PPS_FN_CCP2=14
_PPS_FN_CCP1=13
_PPS_FN_CWG1D=12
_PPS_FN_CWG1C=11
_PPS_FN_CWG1B=10
_PPS_FN_CWG1A=9
_PPS_FN_CLC8=8
_PPS_FN_CLC7=7
_PPS_FN_CLC6=6
_PPS_FN_CLC5=5
_PPS_FN_CLC4=4
_PPS_FN_CLC3=3
_PPS_FN_CLC2=2
_PPS_FN_CLC1=1
; COMPILER'S INTERNAL CONSTANTS AND ALIASES
#define __18F56Q71 1
#define xtal 64
#define _core 16
#define _MaxRAM 4096
#define _RAM_End 0X14FF
#define _MaxMem 0X010000
#define _ADC 2
#define _ADC_res 12
#define _eeprom 256
#define ram_banks 16
#define _USART 2
#define _USB 0
#define _flash 1
#define _cwrite_block 1
#define _TRIS_offset -8
#define __EE_RW_type 3
#define __Flash_RW_type 3
#define __MSSP_type 1
#define __HPWM_type 1
#define __adin_type 1
#define __UART_type 3
#define __PPS 1
#define __PPS_type 1
#define __movffl 1
#define BankA_Start 0X500
#define BankA_End 0X55F
#define clrw clrf WREG
#define negw negf WREG
#define skpc btfss STATUS,0
#define skpnc btfsc STATUS,0
#define clrc bcf STATUS,0
#define setc bsf STATUS,0
#define skpz btfss STATUS,2
#define skpnz btfsc STATUS,2
#define clrz bcf STATUS,2
#define setz bsf STATUS,2
; COMPILER SYSTEM VARIABLES
BPF equ 0X500
BPFH equ 0X501
GEN4 equ 0X502
GEN4H equ 0X503
PBS_VAR0 equ 0X504
PBS_VAR0H equ 0X505
PP0 equ 0X506
PP0H equ 0X507
PP0HH equ 0X508
PP0HHH equ 0X509
PP1 equ 0X50A
PP1H equ 0X50B
PP1HH equ 0X50C
PP1HHH equ 0X50D
PP2 equ 0X50E
PP2H equ 0X50F
PP2HH equ 0X510
PP2HHH equ 0X511
PP3 equ 0X512
PP7 equ 0X513
PP7H equ 0X514
PP7HH equ 0X515
PP7HHH equ 0X516
PPZ equ 0X517
PPZH equ 0X518
PPZHH equ 0X519
PPZHHH equ 0X51A
SP__P9_ equ 0X51B
; BIT HOLDER VARIABLES
_B__VR1 equ 0X51C
; STANDARD VARIABLES
sTx equ 0X51D
variable sTx#0=0X51D,sTx#1=0X51E,sTx#2=0X51F,sTx#3=0X520
variable sTx#4=0X521,sTx#5=0X522,sTx#6=0X523,sTx#7=0X524
variable sTx#8=0X525,sTx#9=0X526,sTx#10=0X527,sTx#11=0X528
variable sTx#12=0X529,sTx#13=0X52A,sTx#14=0X52B,sTx#15=0X52C
variable sTx#16=0X52D,sTx#17=0X52E,sTx#18=0X52F,sTx#19=0X530
variable sTx#20=0X531,sTx#21=0X532,sTx#22=0X533,sTx#23=0X534
variable sTx#24=0X535,sTx#25=0X536,sTx#26=0X537,sTx#27=0X538
variable sTx#28=0X539,sTx#29=0X53A,sTx#30=0X53B,sTx#31=0X53C
variable sTx#32=0X53D,sTx#33=0X53E,sTx#34=0X53F,sTx#35=0X540
variable sTx#36=0X541,sTx#37=0X542,sTx#38=0X543,sTx#39=0X544
variable sTx#40=0X545,sTx#41=0X546,sTx#42=0X547,sTx#43=0X548
variable sTx#44=0X549,sTx#45=0X54A,sTx#46=0X54B,sTx#47=0X54C
variable sTx#48=0X54D,sTx#49=0X54E,sTx#50=0X54F,sTx#51=0X550
variable sTx#52=0X551,sTx#53=0X552,sTx#54=0X553,sTx#55=0X554
variable sTx#56=0X555,sTx#57=0X556,sTx#58=0X557,sTx#59=0X558
variable sTx#60=0X559,sTx#61=0X55A,sTx#62=0X55B,sTx#63=0X55C
variable sTx#64=0X55D,sTx#65=0X55E,sTx#66=0X55F,sTx#67=0X560
variable sTx#68=0X561,sTx#69=0X562,sTx#70=0X563,sTx#71=0X564
variable sTx#72=0X565,sTx#73=0X566,sTx#74=0X567,sTx#75=0X568
variable sTx#76=0X569,sTx#77=0X56A,sTx#78=0X56B,sTx#79=0X56C
variable sTx#80=0X56D,sTx#81=0X56E,sTx#82=0X56F,sTx#83=0X570
variable sTx#84=0X571,sTx#85=0X572,sTx#86=0X573,sTx#87=0X574
variable sTx#88=0X575,sTx#89=0X576,sTx#90=0X577,sTx#91=0X578
variable sTx#92=0X579,sTx#93=0X57A,sTx#94=0X57B,sTx#95=0X57C
variable sTx#96=0X57D
sCmd equ 0X57E
variable sCmd#0=0X57E,sCmd#1=0X57F,sCmd#2=0X580,sCmd#3=0X581
variable sCmd#4=0X582,sCmd#5=0X583,sCmd#6=0X584,sCmd#7=0X585
variable sCmd#8=0X586,sCmd#9=0X587,sCmd#10=0X588,sCmd#11=0X589
variable sCmd#12=0X58A,sCmd#13=0X58B,sCmd#14=0X58C,sCmd#15=0X58D
variable sCmd#16=0X58E,sCmd#17=0X58F
sLow equ 0X590
variable sLow#0=0X590,sLow#1=0X591,sLow#2=0X592,sLow#3=0X593
variable sLow#4=0X594,sLow#5=0X595,sLow#6=0X596,sLow#7=0X597
variable sLow#8=0X598,sLow#9=0X599,sLow#10=0X59A,sLow#11=0X59B
variable sLow#12=0X59C,sLow#13=0X59D,sLow#14=0X59E,sLow#15=0X59F
variable sLow#16=0X5A0,sLow#17=0X5A1
bLen equ 0X5A2
bRaw equ 0X5A3
bChar equ 0X5A4
bI equ 0X5A5
bSub equ 0X5A6
bIdle equ 0X5A7
bPhase equ 0X5A8
bDuty equ 0X5A9
bMode equ 0X5AA
wT equ 0X5AB
wTH equ 0X5AC
wX equ 0X5AD
wXH equ 0X5AE
wNext equ 0X5AF
wNextH equ 0X5B0
wN equ 0X5B1
wNH equ 0X5B2
dX equ 0X5B3
dXH equ 0X5B4
dXHH equ 0X5B5
dXHHH equ 0X5B6
Bk equ 0X5B7
bSw equ 0X5B8
wCyc equ 0X5B9
wCycH equ 0X5BA
; ALIAS VARIABLES
#define bSwOld _B__VR1,0
#define bLedOn _B__VR1,1
#define bLedWas _B__VR1,2
#define bWires _B__VR1,3
#define bKnown _B__VR1,4
; CONSTANTS
#define __xtal 64
#define cIdle 0
#define cBlink 1
#define cFade 2
#define cStream 3
;---------------------------------------------
; START OF THE COMPILER'S LIBRARY ROUTINES
_compiler__start_
    org 0x00
    nop
    nop
    goto _compiler_main_start_
    org 0x08
__hex__ASCII__outb
    clrf GEN4H,0
__hex__ASCII__outc
    movwf PP2,0
__hex__ASCII__outd
    clrf PP2H,0
__hex__ASCII__out
    bcf BPF,3
    movf GEN4H,W
    btfsc STATUS,2
    bsf BPF,3
    movlw 0x04
    movwf GEN4,0
    swapf PP2H,W
    rcall __send_hex_digit__
    movf PP2H,W
    rcall __send_hex_digit__
    swapf PP2,W
    rcall __send_hex_digit__
    movf PP2,W
__send_hex_digit__
    andlw 0x0F
    addlw 0xF6
    btfsc STATUS,0
    addlw 0x07
    addlw 0x0A
    bra __send__it__
__dec__ASCII__outb
    clrf GEN4H,0
__dec__ASCII__outc
    movwf PP2,0
__dec__ASCII__outd
    clrf PP2H,0
__dec__ASCII__out
    bcf BPF,3
    movf GEN4H,W
    btfsc STATUS,2
    bsf BPF,3
    movlw 0x05
    movwf GEN4,0
    movlw 0x27
    movwf PP1H,0
    movlw 0x10
    rcall __send_dec_digit__
    movlw 0x03
    movwf PP1H,0
    movlw 0xE8
    rcall __send_dec_digit__
    clrf PP1H,0
    movlw 0x64
    rcall __send_dec_digit__
    clrf PP1H,0
    movlw 0x0A
    rcall __send_dec_digit__
    movf PP2,W
    bra __send__it__
__send_dec_digit__
    movwf PP1,0
    movf PP2H,W
    movwf PP0H,0
    movf PP2,W
    movwf PP0,0
    rcall __divide_u1616_
    movf PP0,W
__send__it__
    movwf PP0,0
    dcfsnz GEN4,F
    bcf BPF,3
    movf GEN4H,W
    bz __send_it_skip__
    subwf GEN4,W
    bc __send_it_exit__
__send_it_skip__
    movf PP0,W
    btfss STATUS,2
    bcf BPF,3
    btfsc BPF,3
    bra __send_it_exit__
    addlw 0x30
    bra __byte_send__
__send_it_exit__
    return
__byte_send__
    btfss BPFH,1
    bra __byte_send__checknext4
    btfsc BPFH,0
    bra __byte_send__checknext4
    btfsc BPFH,1
    movwf POSTINC0,0
    return
__byte_send__checknext4
__delay_ms_
    clrf PP1H,0
__delay_ms_wreg_
    movwf PP1,0
__delayms_from_regs__
    movlw 0xFF
    addwf PP1,F
    addwfc PP1H,F
    bra $ + 2
    btfss STATUS,0
    return
    movlw 0x03
    movwf PP0H,0
    movlw 0xE6
    rcall __delay_us_wreg_
    bra __delayms_from_regs__
__delay_us_
    clrf PP0H,0
__delay_us_wreg_
    addlw 0xFE
    movwf PP0,0
    nop
    bra $ + 2
    bra $ + 2
    clrf WREG,0
    subwfb PP0H,F
    btfss STATUS,0
    return
    decf PP0,F
    bra $ + 2
    bra $ + 2
    bra $ - 20
__divide_u3232_
    clrf PPZ,0
    clrf PPZH,0
    clrf PPZHH,0
    clrf PPZHHH,0
    movlw 0x21
    movwf PP1HH,0
    bra __divide_u3232_skip_
__divide_u3232_loop_
    rlcf PPZ,F
    rlcf PPZH,F
    rlcf PPZHH,F
    rlcf PPZHHH,F
    movf PP2,W
    subwf PPZ,W
    movf PP2H,W
    subwfb PPZH,W
    movf PP2HH,W
    subwfb PPZHH,W
    movf PP2HHH,W
    subwfb PPZHHH,W
    bnc __divide_u3232_skip_
    movwf PPZHHH,0
    movf PP2,W
    subwf PPZ,F
    movf PP2H,W
    subwfb PPZH,F
    movf PP2HH,W
    subwfb PPZHH,F
    bsf STATUS,0
__divide_u3232_skip_
    rlcf PP0,F
    rlcf PP0H,F
    rlcf PP0HH,F
    rlcf PP0HHH,F
    decfsz PP1HH,F
    bra __divide_u3232_loop_
    movff PPZHHH,PP2HHH
    movff PPZHH,PP2HH
    movff PPZH,PP2H
    movf PPZ,W
    movwf PP2,0
    return
__divide_u1616_
    clrf PP2H,0
    clrf PP2,0
__divide_int_u1616_
    movlw 0x10
    movwf PRODL,0
__divide_u1616_loop_
    rlcf PP0H,W
    rlcf PP2,F
    rlcf PP2H,F
    movf PP1,W
    subwf PP2,W
    movf PP1H,W
    subwfb PP2H,W
    bnc __divide_u1616_k_
    movf PP1,W
    subwf PP2,F
    movf PP1H,W
    subwfb PP2H,F
    bsf STATUS,0
__divide_u1616_k_
    rlcf PP0,F
    rlcf PP0H,F
    decfsz PRODL,F
    bra __divide_u1616_loop_
    movf PP0,W
    return
__multiply_u3232_
    movff PP0HHH,PPZHHH
    movff PP0HH,PPZHH
    movff PP0H,PPZH
    movff PP0,PPZ
    movf PPZHH,W
    mulwf PP2,0
    movff PRODL,PP0HH
    movff PRODH,PP0HHH
    movf PPZH,W
    mulwf PP2H,0
    movf PRODL,W
    addwf PP0HH,F
    movf PRODH,W
    addwfc PP0HHH,F
    movf PPZ,W
    mulwf PP2HH,0
    movf PRODL,W
    addwf PP0HH,F
    movf PRODH,W
    addwfc PP0HHH,F
    movf PPZHHH,W
    mulwf PP2,0
    movf PRODL,W
    addwf PP0HHH,F
    movf PPZHH,W
    mulwf PP2H,0
    movf PRODL,W
    addwf PP0HHH,F
    movf PPZH,W
    mulwf PP2HH,0
    movf PRODL,W
    addwf PP0HHH,F
    movf PPZ,W
    mulwf PP2HHH,0
    movf PRODL,W
    addwf PP0HHH,F
    movf PPZ,W
    mulwf PP2,0
    movff PRODL,PP0
    movff PRODH,PP0H
    movf PPZH,W
    mulwf PP2,0
    movf PRODL,W
    addwf PP0H,F
    movf PRODH,W
    addwfc PP0HH,F
    movlw 0x00
    addwfc PP0HHH,F
    movf PPZ,W
    mulwf PP2H,0
    movf PRODL,W
    addwf PP0H,F
    movf PRODH,W
    addwfc PP0HH,F
    movlw 0x00
    addwfc PP0HHH,F
    return
__load_flashstring_to_RAM_
__load_flashstring_to_RAM_24_
    movlb high(NVMCON1)
    clrf NVMCON1,1
    movlb 0x05
    tblrd*+
    movf TABLAT,W
    bz $ + 6
    movwf POSTINC0,0
    bra $ - 8
    return
_to__lower_
    movlw 0x41
    subwf INDF1,W
    bn $ + 12
    movlw 0x5B
    subwf INDF1,W
    bnn $ + 6
    movlw 0x20
    iorwf INDF1,F
    movf POSTINC1,W
    movwf POSTINC0,0
    bnz $ - 20
    return
_FlashStr_RAMStr_Compare_
_FlashStr_RAMStr_Compare_24_
    movlb high(NVMCON1)
    clrf NVMCON1,1
    movlb 0x05
    movf POSTINC0,W
    tblrd*+
    subwf TABLAT,W
    bnz $ + 6
    tstfsz TABLAT
    bra $ - 10
    return
;---------------------------------------------
; USER. STRING VARIABLE PRE-LOADS
_strlb__1
    db 76,69,68,32,40,35
    db 41,32,79,78,32,32
    db 32,116,105,107,32,0
_strlb__2
    db 47,52,32,32,32,116
    db 117,114,32,0
_strlb__3
    db 76,69,68,32,40,32
    db 41,32,111,102,102,0
_strlb__4
    db 32,32,83,87,48,61
    db 0
_strlb__5
    db 79,75,32,53,51,58
    db 32,76,69,68,32,80
    db 87,77,32,48,45,62
    db 109,97,120,45,62,48
    db 32,40,53,48,48,43
    db 53,48,48,32,109,115
    db 41,44,32,115,116,111
    db 112,32,105,108,101,32
    db 100,117,114,117,114,0
_strlb__6
    db 111,107,109,110,0
_strlb__7
    db 79,75,32,111,107,109
    db 110,58,32,76,69,68
    db 32,116,105,107,45,116
    db 105,107,45,116,105,107
    db 45,116,105,107,32,43
    db 32,51,48,48,32,109
    db 115,44,32,115,116,111
    db 112,32,105,108,101,32
    db 100,117,114,117,114,0
_strlb__8
    db 99,111,109,101,0
_strlb__9
    db 79,75,32,99,111,109
    db 101,58,32,68,65,84
    db 65,32,104,101,114,32
    db 50,53,48,32,109,115
    db 44,32,115,116,111,112
    db 32,105,108,101,32,100
    db 117,114,117,114,0
_strlb__10
    db 115,116,111,112,0
_strlb__11
    db 79,75,32,115,116,111
    db 112,58,32,98,101,107
    db 108,105,121,111,114,32
    db 47,32,119,97,105,116
    db 105,110,103,0
_strlb__12
    db 104,101,108,112,0
_strlb__13
    db 63,32,98,105,108,105
    db 110,109,101,121,101,110
    db 32,107,111,109,117,116
    db 32,47,32,117,110,107
    db 110,111,119,110,58,32
    db 0
_strlb__14
    db 32,32,40,72,69,88
    db 32,0
_strlb__15
    db 46,46,46,41,32,32
    db 45,62,32,104,101,108
    db 112,0
_strlb__16
    db 45,45,32,100,117,114
    db 100,117,32,47,32,115
    db 116,111,112,112,101,100
    db 32,45,45,0
_strlb__17
    db 67,78,65,78,79,95
    db 75,79,77,85,84,32
    db 53,54,81,55,49,32
    db 104,97,122,105,114,32
    db 47,32,114,101,97,100
    db 121,0
_strlb__18
    db 32,32,75,97,98,108
    db 111,32,100,117,114,117
    db 109,117,32,105,108,107
    db 32,107,111,109,117,116
    db 116,97,32,98,101,108
    db 105,114,108,101,110,105
    db 114,32,47,32,119,105
    db 114,101,32,99,104,101
    db 99,107,32,97,116,32
    db 116,104,101,32,102,105
    db 114,115,116,32,99,111
    db 109,109,97,110,100,0
_strlb__19
    db 32,32,75,65,66,76
    db 79,76,85,32,40,82
    db 66,53,45,82,67,55
    db 41,32,47,32,119,105
    db 114,101,32,102,105,116
    db 116,101,100,58,32,76
    db 69,68,48,32,115,117
    db 114,117,108,109,101,122
    db 44,32,76,69,68,32
    db 98,117,114,97,100,97
    db 32,103,111,115,116,101
    db 114,105,108,105,114,0
_strlb__20
    db 32,32,75,65,66,76
    db 79,83,85,90,32,47
    db 32,110,111,32,119,105
    db 114,101,58,32,76,69
    db 68,48,32,107,117,108
    db 108,97,110,105,108,105
    db 121,111,114,32,40,43
    db 32,98,117,114,97,100
    db 97,32,103,111,115,116
    db 101,114,105,108,105,114
    db 41,0
_strlb__21
    db 32,32,111,107,109,110
    db 32,32,40,77,101,116
    db 105,110,47,84,101,120
    db 116,41,32,32,76,69
    db 68,32,116,105,107,32
    db 120,52,32,43,32,51
    db 48,48,32,109,115,44
    db 32,115,117,114,101,107
    db 108,105,0
_strlb__22
    db 32,32,53,51,32,32
    db 32,32,40,72,69,88
    db 41,32,32,32,32,32
    db 32,32,32,32,76,69
    db 68,32,80,87,77,32
    db 102,97,100,101,44,32
    db 115,117,114,101,107,108
    db 105,0
_strlb__23
    db 32,32,99,111,109,101
    db 32,32,40,77,101,116
    db 105,110,47,84,101,120
    db 116,41,32,32,68,65
    db 84,65,32,104,101,114
    db 32,50,53,48,32,109
    db 115,44,32,115,117,114
    db 101,107,108,105,0
_strlb__24
    db 32,32,115,116,111,112
    db 32,32,100,117,114,100
    db 117,114,117,114,32,32
    db 32,32,32,32,104,101
    db 108,112,32,32,98,117
    db 32,108,105,115,116,101
    db 0
_strlb__25
    db 32,32,68,105,115,32
    db 76,69,68,32,40,105
    db 115,116,101,103,101,32
    db 98,97,103,108,105,41
    db 58,32,82,68,48,32
    db 45,32,49,107,32,45
    db 32,76,69,68,32,45
    db 32,71,78,68,0
_compiler_main_start_
    clrf BPF,0
    movlb high(NVMCON1)
    clrf NVMCON1,1
;---------------------------------------------
; START OF THE USER'S PROGRAM CODE
F1_SOF equ $ ; CNANO_KOMUT_56Q71.BAS
    movlb 0x04
    clrf ANSELA
    clrf ANSELB
    clrf ANSELC
    clrf ANSELD
    clrf ANSELE
    clrf ANSELF
    clrf SLRCONA
    clrf SLRCONB
    clrf SLRCONC
    clrf SLRCOND
    clrf SLRCONE
    clrf SLRCONF
    clrf INLVLA
    clrf INLVLB
    clrf INLVLC
    clrf INLVLD
    clrf INLVLE
    clrf INLVLF
    movlb 0x00
    clrf CM1CON0
    clrf CM2CON0
F1_000076 equ $ ; in [CNANO_KOMUT_56Q71.BAS] OSCCON1 = $60
    movlw 96
    movwf OSCCON1
F1_000077 equ $ ; in [CNANO_KOMUT_56Q71.BAS] OSCFRQ  = $08
    movlw 8
    movwf OSCFRQ
F1_000080 equ $ ; in [CNANO_KOMUT_56Q71.BAS] ANSELA = 0 : ANSELB = 0 : ANSELC = 0
    movlb 0x04
    clrf ANSELA
    clrf ANSELB
    clrf ANSELC
F1_000081 equ $ ; in [CNANO_KOMUT_56Q71.BAS] WPUA.0 = 1
    bsf WPUA,0
F1_000082 equ $ ; in [CNANO_KOMUT_56Q71.BAS] WPUB.5 = 1
    bsf WPUB,5
F1_000089 equ $ ; in [CNANO_KOMUT_56Q71.BAS] ANSELD = 0 : LATD.0 = 0 : TRISD.0 = 0
    clrf ANSELD
    movlb 0x01
    bcf LATD,0
    bcf TRISD,0
F1_000090 equ $ ; in [CNANO_KOMUT_56Q71.BAS] TRISC.7 = 1 : WPUC.7 = 1
    bsf TRISC,7
    movlb 0x04
    bsf WPUC,7
F1_000091 equ $ ; in [CNANO_KOMUT_56Q71.BAS] IOCBN.5 = 1 : IOCCN.7 = 1
    bsf IOCBN,5
    bsf IOCCN,7
F1_000092 equ $ ; in [CNANO_KOMUT_56Q71.BAS] IOCBF.5 = 0 : IOCCF.7 = 0
    bcf IOCBF,5
    bcf IOCCF,7
F1_000093 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bWires = 1 : bKnown = 0
    bsf _B__VR1,3
    bcf _B__VR1,4
F1_000097 equ $ ; in [CNANO_KOMUT_56Q71.BAS] LATB.4  = 1
    movlb 0x01
    bsf LATB,4
F1_000098 equ $ ; in [CNANO_KOMUT_56Q71.BAS] TRISB.4 = 0
    bcf TRISB,4
F1_000099 equ $ ; in [CNANO_KOMUT_56Q71.BAS] RB4PPS  = 24
    movlb 0x02
    movlw 24
    movwf RB4PPS
F1_000100 equ $ ; in [CNANO_KOMUT_56Q71.BAS] U2RXPPS = ((1 << 3) | 5)
    movlw 13
    movwf U2RXPPS
F1_000101 equ $ ; in [CNANO_KOMUT_56Q71.BAS] U2BRGH  = 0
    clrf U2BRGH
F1_000102 equ $ ; in [CNANO_KOMUT_56Q71.BAS] U2BRGL  = 138
    movlw 138
    movwf U2BRGL
F1_000103 equ $ ; in [CNANO_KOMUT_56Q71.BAS] U2CON0  = ((1 << 7) | (1 << 5) | (1 << 4))
    movlw 176
    movwf U2CON0
F1_000104 equ $ ; in [CNANO_KOMUT_56Q71.BAS] U2CON1  = (1 << 7)
    movlw 128
    movwf U2CON1
F1_000106 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bLen = 0 : sCmd = "" : bSub = 0 : bIdle = 0 : bPhase = 0 : bDuty = 0
    movlb 0x05
    clrf bLen
    lfsr 0,sCmd
    clrf INDF0
    clrf bSub
    clrf bIdle
    clrf bPhase
    clrf bDuty
F1_000107 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bMode = cIdle : wT = 0 : bSwOld = 1 : bLedOn = 0 : bLedWas = 0
    clrf bMode
    clrf wTH
    clrf wT
    bsf _B__VR1,0
    bcf _B__VR1,1
    bcf _B__VR1,2
F1_000108 equ $ ; in [CNANO_KOMUT_56Q71.BAS] DelayMs 100
    movlw 100
    call __delay_ms_
F1_000109 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tx_Help
    call Tx_Help
F1_000112 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Do
_lbl__2
F1_000114 equ $ ; in [CNANO_KOMUT_56Q71.BAS] While U2FIFO.1 = 0
_lbl__5
    movff U2FIFO,WREG
    btfsc WREG,1
    bra _lbl__6
F1_000115 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bChar = U2RXB
    movff U2RXB,bChar
F1_000116 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bKnown = 0 Then GoSub Wire_Decide
    btfss _B__VR1,4,0
    call Wire_Decide
_lbl__8
F1_000117 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bIdle = 0
    clrf bIdle
F1_000118 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bChar = 13 Or bChar = 10 Then
    movlw 13
    subwf bChar,W
    movlw 1
    btfss STATUS,2
    movlw 0
    movwf SP__P9_
    movlw 10
    subwf bChar,W
    movlw 1
    btfss STATUS,2
    movlw 0
    iorwf SP__P9_,F
    bz _lbl__10
F1_000119 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLen > 0 Then GoSub Do_Command
    movf bLen,F
    bz _lbl__12
    rcall Do_Command
_lbl__12
    bra _lbl__13
_lbl__10
F1_000120 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000121 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLen = 0 Then bRaw = bChar
    movf bLen,F
    bnz _lbl__15
    movff bChar,bRaw
_lbl__15
F1_000122 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLen < 16 Then
    movlw 16
    cpfslt bLen
    bra _lbl__17
F1_000123 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sCmd[bLen] = bChar
    lfsr 0,sCmd
    movf bLen,W
    movff bChar,PLUSW0
F1_000124 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc bLen
    incf bLen,F
F1_000125 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sCmd[bLen] = 0
    clrf PRODL
    lfsr 0,sCmd
    movf bLen,W
    movff PRODL,PLUSW0
F1_000126 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__17
F1_000127 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__13
F1_000128 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Wend
    bra _lbl__5
_lbl__6
F1_000131 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bMode = cFade Then
    movlw 2
    cpfseq bMode
    bra _lbl__19
F1_000132 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc bPhase
    incf bPhase,F
F1_000133 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bPhase >= 40 Then bPhase = 0
    movlw 39
    cpfsgt bPhase
    bra _lbl__21
    clrf bPhase
_lbl__21
F1_000134 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bPhase < bDuty Then
    movf bDuty,W
    cpfslt bPhase
    bra _lbl__23
F1_000135 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bLedOn = 1
    bsf _B__VR1,1
    bra _lbl__24
_lbl__23
F1_000136 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000137 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bLedOn = 0
    bcf _B__VR1,1
F1_000138 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__24
F1_000139 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Led_Out
    call Led_Out
F1_000140 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__19
F1_000143 equ $ ; in [CNANO_KOMUT_56Q71.BAS] DelayUs 46
    movlw 46
    call __delay_us_
F1_000144 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc bSub
    incf bSub,F
F1_000145 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bSub >= 20 Then
    movlw 19
    cpfsgt bSub
    bra _lbl__26
F1_000146 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bSub = 0
    clrf bSub
F1_000147 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tick_1ms
    rcall Tick_1ms
F1_000148 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__26
_lbl__4
F1_000149 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Loop
    bra _lbl__2
_lbl__3
Tick_1ms
F1_000154 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLen > 0 Then
    movf bLen,F
    bz _lbl__28
F1_000155 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc bIdle
    incf bIdle,F
F1_000156 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bIdle >= 30 Then GoSub Do_Command
    movlw 29
    cpfsgt bIdle
    bra _lbl__30
    rcall Do_Command
_lbl__30
F1_000157 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__28
F1_000160 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if PORTA.0 <> bSwOld Then
    movlb 0x01
    movf PORTA,W
    xorwf _B__VR1,W
    andlw 1
    movlb 0x05
    bz _lbl__32
F1_000161 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bSwOld = PORTA.0
    movlb 0x01
    bsf _B__VR1,0
    btfss PORTA,0
    bcf _B__VR1,0
F1_000162 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bSwOld = 0 Then
    movlb 0x05
    btfsc _B__VR1,0,0
    bra _lbl__34
F1_000163 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "SW0"
    lfsr 0,sTx
    movlw 83
    movwf POSTINC0
    movlw 87
    movwf POSTINC0
    movlw 48
    movwf POSTINC0
    clrf INDF0
F1_000164 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tx_Line
    call Tx_Line
F1_000165 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__34
F1_000166 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__32
F1_000168 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bMode = cIdle Then return
    movf bMode,F
    bnz _lbl__36
    return 0
_lbl__36
F1_000169 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc wT
    infsnz wT,F
    incf wTH,F
F1_000171 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Select bMode
F1_000172 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case cBlink
    decfsz bMode,W
    bra _lbl__38
F1_000173 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if wT >= 1100 Then
    movlw 76
    subwf wT,W
    movlw 4
    subwfb wTH,W
    bnc _lbl__41
F1_000174 equ $ ; in [CNANO_KOMUT_56Q71.BAS] wT = 0 : Inc wCyc
    clrf wTH
    clrf wT
    infsnz wCyc,F
    incf wCycH,F
F1_000175 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__41
F1_000176 equ $ ; in [CNANO_KOMUT_56Q71.BAS] wX = wT
    movff wTH,wXH
    movff wT,wX
F1_000177 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bLedOn = 0
    bcf _B__VR1,1
F1_000178 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if wX < 800 Then
    movlw 32
    subwf wX,W
    movlw 3
    subwfb wXH,W
    bc _lbl__43
F1_000179 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if (wX // 200) < 80 Then bLedOn = 1
    movff wXH,PP0H
    movff wX,PP0
    clrf PP1H
    movlw 200
    movwf PP1
    call __divide_u1616_
    movff PP2H,PBS_VAR0H
    movff PP2,PBS_VAR0
    movf PBS_VAR0H,F
    bnz _lbl__45
    movlw 80
    cpfslt PBS_VAR0
    bra _lbl__45
    bsf _B__VR1,1
_lbl__45
F1_000180 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__43
F1_000181 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Led_Out
    rcall Led_Out
F1_000182 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLedOn <> bLedWas Then
    clrf WREG,0
    btfsc _B__VR1,1
    addlw 1
    btfsc _B__VR1,2
    sublw 1
    bz _lbl__47
F1_000183 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bLedWas = bLedOn
    bsf _B__VR1,2
    btfss _B__VR1,1
    bcf _B__VR1,2
F1_000184 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLedOn = 1 Then
    btfss _B__VR1,1,0
    bra _lbl__49
F1_000185 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Bk = wX / 200 : Inc Bk
    movff wXH,PP0H
    movff wX,PP0
    clrf PP1H
    movlw 200
    movwf PP1
    call __divide_u1616_
    movwf Bk
    incf Bk,F
F1_000186 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "LED (#) on   TIK " + Str$(Dec Bk) + "/4   TUR " + Str$(Dec wCyc)
    lfsr 0,sTx
    movlw ((_strlb__1 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__1 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    movlw 2
    movwf BPFH
    movf Bk,W
    call __dec__ASCII__outb
    movlw ((_strlb__2 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__2 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    movlw 2
    movwf BPFH
    clrf GEN4H
    movff wCycH,PP2H
    movff wCyc,PP2
    call __dec__ASCII__out
    clrf INDF0
    bra _lbl__50
_lbl__49
F1_000187 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000188 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "LED ( ) off"
    lfsr 0,sTx
    movlw ((_strlb__3 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__3 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
F1_000189 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__50
F1_000190 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tx_Line
    rcall Tx_Line
F1_000191 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__47
    bra _lbl__37
_lbl__38
F1_000193 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case cFade
    movlw 2
    cpfseq bMode
    bra _lbl__52
F1_000194 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if wT >= 1000 Then
    movlw 232
    subwf wT,W
    movlw 3
    subwfb wTH,W
    bnc _lbl__54
F1_000195 equ $ ; in [CNANO_KOMUT_56Q71.BAS] wT = 0 : Inc wCyc
    clrf wTH
    clrf wT
    infsnz wCyc,F
    incf wCycH,F
F1_000196 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__54
F1_000197 equ $ ; in [CNANO_KOMUT_56Q71.BAS] wX = wT
    movff wTH,wXH
    movff wT,wX
F1_000198 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if wX >= 500 Then wX = 1000 - wX
    movlw 244
    subwf wX,W
    movlw 1
    subwfb wXH,W
    bnc _lbl__56
    movf wX,W
    sublw 232
    movwf wX
    movlw 3
    subfwb wXH,W
    movwf wXH
_lbl__56
F1_000199 equ $ ; in [CNANO_KOMUT_56Q71.BAS] dX = wX
    movff wX,dX
    movff wXH,dXH
    clrf dXHH
    clrf dXHHH
F1_000200 equ $ ; in [CNANO_KOMUT_56Q71.BAS] dX = (dX * dX * 40) / 250000
    movff dX,PP7
    movff dXH,PP7H
    movff dXHH,PP7HH
    movff dXHHH,PP7HHH
    movff PP7,PP0
    movff PP7H,PP0H
    movff PP7HH,PP0HH
    movff PP7HHH,PP0HHH
    movff dX,PP2
    movff dXH,PP2H
    movff dXHH,PP2HH
    movff dXHHH,PP2HHH
    call __multiply_u3232_
    movff PP0,PP7
    movff PP0H,PP7H
    movff PP0HH,PP7HH
    movff PP0HHH,PP7HHH
    movff PP7,PP0
    movff PP7H,PP0H
    movff PP7HH,PP0HH
    movff PP7HHH,PP0HHH
    clrf PP2HHH
    clrf PP2HH
    clrf PP2H
    movlw 40
    movwf PP2
    call __multiply_u3232_
    movff PP0,PP7
    movff PP0H,PP7H
    movff PP0HH,PP7HH
    movff PP0HHH,PP7HHH
    movff PP7,PP0
    movff PP7H,PP0H
    movff PP7HH,PP0HH
    movff PP7HHH,PP0HHH
    clrf PP2HHH
    movlw 3
    movwf PP2HH
    movlw 208
    movwf PP2H
    movlw 144
    movwf PP2
    call __divide_u3232_
    movff PP0,dX
    movff PP0H,dXH
    movff PP0HH,dXHH
    movff PP0HHH,dXHHH
F1_000201 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bDuty = dX
    movff dX,bDuty
F1_000203 equ $ ; in [CNANO_KOMUT_56Q71.BAS] wX = wT // 100
    movff wTH,PP0H
    movff wT,PP0
    clrf PP1H
    movlw 100
    movwf PP1
    call __divide_u1616_
    movff PP2H,wXH
    movff PP2,wX
F1_000204 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if wX = 0 Then GoSub Tx_Bar
    movf wXH,W
    iorwf wX,W
    bnz _lbl__58
    rcall Tx_Bar
_lbl__58
    bra _lbl__37
_lbl__52
F1_000206 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case cStream
    movlw 3
    cpfseq bMode
    bra _lbl__60
F1_000207 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if wT >= wNext Then
    movf wNext,W
    subwf wT,W
    movf wNextH,W
    subwfb wTH,W
    bnc _lbl__62
F1_000208 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if wT >= 60000 Then
    movlw 96
    subwf wT,W
    movlw 234
    subwfb wTH,W
    bnc _lbl__64
F1_000209 equ $ ; in [CNANO_KOMUT_56Q71.BAS] wT = 0 : wNext = 0
    clrf wTH
    clrf wT
    clrf wNextH
    clrf wNext
F1_000210 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__64
F1_000211 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc wN
    infsnz wN,F
    incf wNH,F
F1_000212 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bSw = PORTA.0
    clrf bSw
    movlb 0x01
    btfsc PORTA,0
    movlb 0x05
    incf bSw,F
F1_000213 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "DATA " + Str$(Dec wN) + "  SW0=" + Str$(Dec bSw)
    lfsr 0,sTx
    movlw 68
    movwf POSTINC0
    movlw 65
    movwf POSTINC0
    movlw 84
    movwf POSTINC0
    movlw 65
    movwf POSTINC0
    movlw 32
    movwf POSTINC0
    movlw 2
    movwf BPFH
    clrf GEN4H
    movff wNH,PP2H
    movff wN,PP2
    call __dec__ASCII__out
    movlw ((_strlb__4 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__4 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    movlw 2
    movwf BPFH
    movf bSw,W
    call __dec__ASCII__outb
    clrf INDF0
F1_000214 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tx_Line
    rcall Tx_Line
F1_000215 equ $ ; in [CNANO_KOMUT_56Q71.BAS] wNext = wNext + 250
    movlw 250
    addwf wNext,F
    movlw 0
    addwfc wNextH,F
F1_000216 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__62
F1_000217 equ $ ; in [CNANO_KOMUT_56Q71.BAS] EndSelect
_lbl__60
_lbl__37
F1_000218 equ $ ; in [CNANO_KOMUT_56Q71.BAS] return
    return 0
Do_Command
F1_000222 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sLow = ToLower(sCmd)
    lfsr 0,sLow
    lfsr 1,sCmd
    call _to__lower_
F1_000223 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLen = 1 And bRaw = $53 Then
    movlw 1
    subwf bLen,W
    movlw 1
    btfss STATUS,2
    movlw 0
    movwf SP__P9_
    movlw 83
    subwf bRaw,W
    movlw 1
    btfss STATUS,2
    movlw 0
    andwf SP__P9_,F
    bz _lbl__66
F1_000224 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Stop_All
    rcall Stop_All
F1_000225 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bMode = cFade : wT = 0 : bPhase = 0 : bDuty = 0 : wCyc = 1
    movlw 2
    movwf bMode
    clrf wTH
    clrf wT
    clrf bPhase
    clrf bDuty
    clrf wCycH
    movlw 1
    movwf wCyc
F1_000226 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "OK 53: LED PWM 0->MAX->0 (500+500 MS), Stop ILE DURUR" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__5 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__5 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
    bra _lbl__67
_lbl__66
F1_000227 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000228 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Select sLow
F1_000229 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case "OKMN"
    movlw ((_strlb__6 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__6 & 0xFF)
    movwf TBLPTRL
    lfsr 0,sLow
    call _FlashStr_RAMStr_Compare_
    bnz _lbl__69
F1_000230 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Stop_All
    rcall Stop_All
F1_000231 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bMode = cBlink : wT = 0 : wCyc = 1
    movlw 1
    movwf bMode
    clrf wTH
    clrf wT
    clrf wCycH
    movwf wCyc
F1_000232 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "OK OKMN: LED TIK-TIK-TIK-TIK + 300 MS, Stop ILE DURUR" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__7 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__7 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
    bra _lbl__68
_lbl__69
F1_000233 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case "COME"
    movlw ((_strlb__8 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__8 & 0xFF)
    movwf TBLPTRL
    lfsr 0,sLow
    call _FlashStr_RAMStr_Compare_
    bnz _lbl__72
F1_000234 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Stop_All
    rcall Stop_All
F1_000235 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bMode = cStream : wT = 0 : wNext = 0 : wN = 0
    movlw 3
    movwf bMode
    clrf wTH
    clrf wT
    clrf wNextH
    clrf wNext
    clrf wNH
    clrf wN
F1_000236 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "OK COME: DATA HER 250 MS, Stop ILE DURUR" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__9 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__9 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
    bra _lbl__68
_lbl__72
F1_000237 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case "Stop"
    movlw ((_strlb__10 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__10 & 0xFF)
    movwf TBLPTRL
    lfsr 0,sLow
    call _FlashStr_RAMStr_Compare_
    bnz _lbl__74
F1_000238 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Stop_All
    rcall Stop_All
F1_000239 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "OK Stop: BEKLIYOR / WAITING" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__11 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__11 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
    bra _lbl__68
_lbl__74
F1_000240 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case "HELP"
    movlw ((_strlb__12 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__12 & 0xFF)
    movwf TBLPTRL
    lfsr 0,sLow
    call _FlashStr_RAMStr_Compare_
    bnz _lbl__76
F1_000241 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tx_Help
    rcall Tx_Help
    bra _lbl__68
_lbl__76
F1_000242 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case "?"
    lfsr 0,sLow
    movff POSTINC0,PRODL
    movff INDF0,PRODH
    movf PRODL,W
    xorlw 63
    iorwf PRODLH,W
    bnz _lbl__78
F1_000243 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tx_Help
    rcall Tx_Help
F1_000244 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Case else
    bra _lbl__80
_lbl__78
F1_000245 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "? BILINMEYEN KOMUT / UNKNOWN: " + sCmd + "  (Hex " + Str$(Hex2 bRaw) + "...)  -> HELP" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__13 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__13 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    lfsr 1,sCmd
    movlw 17
_pblb__81
    movf INDF1,F
    bz _pblb__82
    movff POSTINC1,POSTINC0
    decfsz WREG,F
    bra _pblb__81
_pblb__82
    movlw ((_strlb__14 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__14 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    movlw 2
    movwf BPFH
    movwf GEN4H
    movf bRaw,W
    call __hex__ASCII__outc
    movlw ((_strlb__15 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__15 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000246 equ $ ; in [CNANO_KOMUT_56Q71.BAS] EndSelect
_lbl__80
_lbl__68
F1_000247 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__67
F1_000248 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bLen = 0 : sCmd = "" : bIdle = 0
    clrf bLen
    lfsr 0,sCmd
    clrf INDF0
    clrf bIdle
F1_000249 equ $ ; in [CNANO_KOMUT_56Q71.BAS] return
    return 0
Stop_All
F1_000252 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bMode <> cIdle Then
    movf bMode,F
    bz _lbl__84
F1_000253 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "-- DURDU / STOPPED --" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__16 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__16 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000254 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__84
F1_000255 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bMode = cIdle : bDuty = 0 : bLedOn = 0 : bLedWas = 0
    clrf bMode
    clrf bDuty
    bcf _B__VR1,1
    bcf _B__VR1,2
F1_000256 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Led_Out
    bra Led_Out
Led_Out
F1_000260 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLedOn = 1 Then
    btfss _B__VR1,1,0
    bra _lbl__86
F1_000261 equ $ ; in [CNANO_KOMUT_56Q71.BAS] LATD.0 = 1
    movlb 0x01
    bsf LATD,0
    movlb 0x05
    bra _lbl__87
_lbl__86
F1_000262 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000263 equ $ ; in [CNANO_KOMUT_56Q71.BAS] LATD.0 = 0
    movlb 0x01
    bcf LATD,0
F1_000264 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__87
    movlb 0x05
F1_000265 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bWires = 1 Then return
    btfsc _B__VR1,3,0
    return 0
_lbl__89
F1_000266 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bLedOn = 1 Then
    btfss _B__VR1,1,0
    bra _lbl__91
F1_000267 equ $ ; in [CNANO_KOMUT_56Q71.BAS] LATC.7 = 0
    movlb 0x01
    bcf LATC,7
    movlb 0x05
    bra _lbl__92
_lbl__91
F1_000268 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000269 equ $ ; in [CNANO_KOMUT_56Q71.BAS] LATC.7 = 1
    movlb 0x01
    bsf LATC,7
F1_000270 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__92
    movlb 0x05
F1_000271 equ $ ; in [CNANO_KOMUT_56Q71.BAS] return
    return 0
Tx_Bar
F1_000274 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "LED ["
    lfsr 0,sTx
    movlw 76
    movwf POSTINC0
    movlw 69
    movwf POSTINC0
    movlw 68
    movwf POSTINC0
    movlw 32
    movwf POSTINC0
    movlw 91
    movwf POSTINC0
    clrf INDF0
F1_000275 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bI = 0
    clrf bI
F1_000276 equ $ ; in [CNANO_KOMUT_56Q71.BAS] While bI < 20
_lbl__93
    movlw 20
    cpfslt bI
    bra _lbl__94
F1_000277 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bI < (bDuty / 2) Then
    bcf STATUS,0
    rrcf bDuty,W
    movwf PBS_VAR0
    clrf PBS_VAR0H
    movf PBS_VAR0H,F
    bnz _cplb__8
    movf PBS_VAR0,W
    cpfslt bI
    bra _lbl__96
_cplb__8
F1_000278 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = sTx + "#"
    lfsr 0,sTx
    movf POSTINC0,W
    bnz $ - 2
    movf POSTDEC0,F
    movlw 35
    movwf POSTINC0
    clrf INDF0
    bra _lbl__97
_lbl__96
F1_000279 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000280 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = sTx + "-"
    lfsr 0,sTx
    movf POSTINC0,W
    bnz $ - 2
    movf POSTDEC0,F
    movlw 45
    movwf POSTINC0
    clrf INDF0
F1_000281 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__97
F1_000282 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc bI
    incf bI,F
F1_000283 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Wend
    bra _lbl__93
_lbl__94
F1_000284 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Bk = bDuty * 5
    movf bDuty,W
    mullw 5
    movff PRODL,Bk
F1_000285 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Bk = Bk / 2
    bcf STATUS,0
    rrcf Bk,F
F1_000286 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = sTx + "] " + Str$(Dec Bk) + " %"
    lfsr 0,sTx
    movf POSTINC0,W
    bnz $ - 2
    movf POSTDEC0,F
    movlw 93
    movwf POSTINC0
    movlw 32
    movwf POSTINC0
    movlw 2
    movwf BPFH
    movf Bk,W
    call __dec__ASCII__outb
    movlw 32
    movwf POSTINC0
    movlw 37
    movwf POSTINC0
    clrf INDF0
F1_000287 equ $ ; in [CNANO_KOMUT_56Q71.BAS] GoSub Tx_Line
    bra Tx_Line
Tx_Char
F1_000292 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Repeat : Until U2FIFO.4 = 0
_lbl__98
    movff U2FIFO,WREG
    btfsc WREG,4
    bra _lbl__98
_lbl__99
F1_000293 equ $ ; in [CNANO_KOMUT_56Q71.BAS] U2TXB = bChar
    movff bChar,U2TXB
F1_000294 equ $ ; in [CNANO_KOMUT_56Q71.BAS] return
    return 0
Tx_Line
F1_000297 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bI = 0
    clrf bI
F1_000298 equ $ ; in [CNANO_KOMUT_56Q71.BAS] While bI < Len(sTx)
_lbl__101
    lfsr 0,sTx
    movlw 0
    movf POSTINC0,F
    bz $ + 6
    incfsz WREG,F
    bra $ - 6
    movwf PBS_VAR0
    movf PBS_VAR0,W
    cpfslt bI
    bra _lbl__102
F1_000299 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bChar = sTx[bI] : GoSub Tx_Char
    lfsr 0,sTx
    movf bI,W
    movf PLUSW0,W
    movwf bChar
    rcall Tx_Char
F1_000300 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Inc bI
    incf bI,F
F1_000301 equ $ ; in [CNANO_KOMUT_56Q71.BAS] Wend
    bra _lbl__101
_lbl__102
F1_000302 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bChar = 13 : GoSub Tx_Char
    movlw 13
    movwf bChar
    rcall Tx_Char
F1_000303 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bChar = 10 : GoSub Tx_Char
    movlw 10
    movwf bChar
    bra Tx_Char
Tx_Help
F1_000307 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "CNANO_KOMUT 56Q71 HAZIR / READY" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__17 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__17 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000308 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bKnown = 0 Then
    btfsc _B__VR1,4,0
    bra _lbl__104
F1_000309 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  KABLO DURUMU ILK KOMUTTA BELIRLENIR / WIRE CHECK At THE FIRST COMMAND" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__18 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__18 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
    bra _lbl__105
_lbl__104
F1_000310 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000311 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if bWires = 1 Then
    btfss _B__VR1,3,0
    bra _lbl__107
F1_000312 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  KABLOLU (RB5-RC7) / WIRE FITTED: LED0 SURULMEZ, LED BURADA GOSTERILIR" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__19 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__19 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
    bra _lbl__108
_lbl__107
F1_000313 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000314 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  KABLOSUZ / NO WIRE: LED0 KULLANILIYOR (+ BURADA GOSTERILIR)" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__20 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__20 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000315 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__108
F1_000316 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__105
F1_000317 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  OKMN  (METIN/TEXT)  LED TIK X4 + 300 MS, SUREKLI" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__21 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__21 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000318 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  53    (Hex)         LED PWM FADE, SUREKLI" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__22 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__22 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000319 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  COME  (METIN/TEXT)  DATA HER 250 MS, SUREKLI" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__23 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__23 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000320 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  Stop  DURDURUR      HELP  BU LISTE" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__24 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__24 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    rcall Tx_Line
F1_000321 equ $ ; in [CNANO_KOMUT_56Q71.BAS] sTx = "  DIS LED (ISTEGE BAGLI): RD0 - 1K - LED - GND" : GoSub Tx_Line
    lfsr 0,sTx
    movlw ((_strlb__25 >> 8) & 0xFF)
    movwf TBLPTRLH
    movlw (_strlb__25 & 0xFF)
    movwf TBLPTRL
    call __load_flashstring_to_RAM_
    clrf INDF0
    bra Tx_Line
Wire_Decide
F1_000325 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if IOCBF.5 = 1 Then
    movff IOCBF,WREG
    btfss WREG,5
    bra _lbl__110
F1_000326 equ $ ; in [CNANO_KOMUT_56Q71.BAS] if IOCCF.7 = 1 Then
    movlb 0x04
    rlcf IOCCF,W
    movlb 0x05
    bnc _lbl__112
F1_000327 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bWires = 1
    bsf _B__VR1,3
    bra _lbl__113
_lbl__112
F1_000328 equ $ ; in [CNANO_KOMUT_56Q71.BAS] else
F1_000329 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bWires = 0
    bcf _B__VR1,3
F1_000330 equ $ ; in [CNANO_KOMUT_56Q71.BAS] WPUC.7 = 0 : LATC.7 = 1 : TRISC.7 = 0
    movlb 0x04
    bcf WPUC,7
    movlb 0x01
    bsf LATC,7
    bcf TRISC,7
F1_000331 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__113
    movlb 0x05
F1_000332 equ $ ; in [CNANO_KOMUT_56Q71.BAS] bKnown = 1
    bsf _B__VR1,4
F1_000333 equ $ ; in [CNANO_KOMUT_56Q71.BAS] endif
_lbl__110
F1_000334 equ $ ; in [CNANO_KOMUT_56Q71.BAS] IOCBF.5 = 0 : IOCCF.7 = 0
    movlb 0x04
    bcf IOCBF,5
    bcf IOCCF,7
F1_000335 equ $ ; in [CNANO_KOMUT_56Q71.BAS] return
    movlb 0x05
    return 0
F1_EOF equ $ ; CNANO_KOMUT_56Q71.BAS
_pblb__114
    bra _pblb__114
;---------------------------------------------
__eof
;---------------------------------------------
; CONFIG FUSES
config FEXTOSC  = off
config RSTOSC   = HFINTOSC_64MHZ
config CLKOUTEN = off
config PR1WAY   = off
config CSWEN    = on
config BBEN     = off
config FCMEN    = off
config FCMENP   = off
config FCMENS   = off
config MCLRE    = EXTMCLR
config PWRTS    = PWRT_64
config MVECEN   = off
config IVT1WAY  = off
config LPBOREN  = off
config BOREN    = SBORDIS
config BORV     = VBOR_2P45
config ZCD      = off
config PPS1WAY  = off
config STVREN   = on
config LVP      = on
config XINST    = off
config DEBUG    = off
config WDTCPS   = WDTCPS_31
config WDTE     = off
config WDTCWS   = WDTCWS_7
config WDTCCS   = SC
config WRTB     = off
config WRTC     = off
config WRTD     = off
config WRTSAF   = off
config WRTAPP   = off
config CPD      = off
config CP       = off
    end
