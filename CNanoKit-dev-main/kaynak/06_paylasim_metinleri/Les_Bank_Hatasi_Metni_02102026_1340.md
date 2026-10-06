# Les'e yeni konu — Positron bank hatası (02.10.2026, gerçek derleme çıktısıyla)

Foruma **yalnız EN kısmı** konur. Ek: `BANK_REPRO_56Q71_02102026_1240.bas` (25 satır, projeden bağımsız). İstersen `.asm` dosyasını da ekle.

---

**Title:** `Positron8 4.0.6.4 / 18F56Q71: "LATD.0 = BitVar" gets no MOVLB (writes RAM 0x543, pin never changes)`

**EN**

Hi Les,

I think I found a small bank-select problem. A 25-line example is attached (BANK_REPRO_56Q71.bas). It compiles OK (172 bytes).

Positron8 4.0.6.4, Device = 18F56Q71. LATD is at 0x143 (bank 1), the variables are in bank 5.

From the .asm:

```
    movlb 0x05
    incf  bCount,F
    ...
; LATD.2 = bFlag            (A) bit variable -> port bit
    btfsc _B__VR1,0
    bsf   LATD,2            ; no MOVLB 1: BSR is still 5
    btfss _B__VR1,0
    bcf   LATD,2

Copy_Flag
; LATD.0 = bFlag            (B) same, first line after a label
    btfsc _B__VR1,0
    bsf   LATD,0            ; no MOVLB 1
    btfss _B__VR1,0
    bcf   LATD,0
; LATD.1 = 1                (C) constant -> port bit
    movlb 0x01              ; MOVLB is there
    bsf   LATD,1
```

With BSR = 5, `bsf LATD,0` sets a bit in RAM 0x543, not the pin. I saw it on a real PIC18F56Q71 Curiosity Nano: the LED on RD0 never lit, and a string variable got one bit changed.

Workaround that works: `If bFlag = 1 Then : LATD.0 = 1 : Else : LATD.0 = 0 : EndIf`

Could you have a look? If it is already fixed in a newer update, sorry for the noise.

Thanks for Positron!
okmn

**TR (sizin için)**

Merhaba Les,

Sanırım küçük bir bank seçme sorunu buldum. 25 satırlık bir örnek ekledim (BANK_REPRO_56Q71.bas). Sorunsuz derleniyor (172 bayt).

Positron8 4.0.6.4, Device = 18F56Q71. LATD 0x143'te (bank 1), değişkenler bank 5'te.

.asm'de: (A) satır içinde ve (B) etiketten hemen sonra gelen `LATD.x = BitDeğişkeni` için `MOVLB 1` yok, BSR 5'te kalıyor. (C) sabit atama `LATD.1 = 1` ise `MOVLB 1` alıyor.

BSR 5 iken `bsf LATD,0`, pini değil RAM 0x543'teki bir biti değiştiriyor. Gerçek PIC18F56Q71 Curiosity Nano'da gördüm: RD0'daki LED hiç yanmadı ve bir metin değişkeninin bir biti değişti.

Çalışan geçici çözüm: `If bFlag = 1 Then : LATD.0 = 1 : Else : LATD.0 = 0 : EndIf`

Bakabilir misin? Yeni bir güncellemede düzeldiyse kusura bakma.

Positron için teşekkürler!
okmn

---
**Kanıt (foruma konmaz):** `BANK_REPRO_56Q71_02102026_1240.asm` satır 1137–1141 (A), 1153–1158 (B), 1159–1161 (C); hemen önce satır ~1116'da `movlb 0x05`. `LATD equ 0X0143`, `_B__VR1 equ 0X504`. JonW'nin MWBOOT_PIC.html belgesi de "Positron assumes BSR = 5 whenever BASIC runs" diyor.
