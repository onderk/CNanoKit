# Les'e yeni konu — Positron derleyici bank hatası (02.10.2026)

Foruma **yalnız İngilizce (EN)** kısmı konur. Ekte `BANK_REPRO_56Q71_02102026_1240.bas` (projeden bağımsız, 25 satırlık örnek).

> **Göndermeden önce (zorunlu):** örnek dosyayı bir kez derle (VS Code: **Ctrl+Alt+C**, programlama yok). Bana "derlendi" yaz; `.asm` dosyasından (A), (B) ve (C) satırlarının gerçek çıktısını alıp aşağıdaki kutuya koyacağım. Böylece Les'e yalnız **bu örnekte gerçekten görülen** çıktı gider.
> Şu anki kutu, aynı derleyicinin başka bir dosyada (aynı kalıpta) ürettiği gerçek çıktıdır; değişken adları farklı olabilir.

---

**Başlık (EN):** `Positron8 4.0.6.4, PIC18F56Q71: "LATD.0 = BitVar" compiled without MOVLB (writes to RAM, pin never changes)`

**EN**

Hi Les,

I think I found a small bank-select problem. Short example attached (BANK_REPRO_56Q71.bas, compile only).

**Setup:** Positron8 4.0.6.4, Device = 18F56Q71 (LATD is at 0x143, bank 1; variables from bank 5).

**What I see in the .asm** (from my first finding, same pattern):

```
Led_Out
    btfsc _B__VR1,1      ; bit variable
    bsf   LATD,0         ; <- no MOVLB 1 before this
    btfss _B__VR1,1
    bcf   LATD,0
    ...
    movlb 0x01           ; <- a few lines later, "LATC.7 = 0" DOES get MOVLB 1
    bcf   LATC,7
    movlb 0x05
```

**Result on the chip:** BSR is still 5, so `bsf LATD,0` sets bit 0 of RAM 0x543, not the port. The pin never moves, and a byte of my string variable got changed. Measured on a real PIC18F56Q71 Curiosity Nano: the LED on RD0 stayed dark.

**Works:** `If bFlag = 1 Then : LATD.0 = 1 : Else : LATD.0 = 0 : EndIf` — the constant form gets its MOVLB.

**Question:** is `PortBit = BitVariable` meant to select the bank, like `PortBit = constant` does? If it's already known or fixed in a newer update, sorry for the noise.

Thanks for Positron!
okmn

**TR (sizin için)**

Merhaba Les,

Sanırım küçük bir bank seçme sorunu buldum. Kısa bir örnek ekledim (BANK_REPRO_56Q71.bas, yalnız derleyin).

**Ortam:** Positron8 4.0.6.4, Device = 18F56Q71 (LATD 0x143'te, bank 1; değişkenler bank 5'ten başlıyor).

**.asm'de gördüğüm:** bit değişkenini port bitine kopyalayan `bsf LATD,0` satırından önce `MOVLB 1` yok. Birkaç satır sonraki `LATC.7 = 0` ise `MOVLB 1` alıyor.

**Çipteki sonuç:** BSR 5'te kaldığı için `bsf LATD,0`, port yerine RAM 0x543'ün 0. bitini değiştiriyor. Pin hiç değişmiyor, metin değişkenimin bir baytı bozuluyor. Gerçek PIC18F56Q71 Curiosity Nano'da ölçüldü: RD0'daki LED hiç yanmadı.

**Çalışan:** sabit atama (`If ... LATD.0 = 1 Else LATD.0 = 0`) `MOVLB` alıyor.

**Soru:** `PortBit = BitDeğişkeni` de, `PortBit = sabit` gibi bankı seçmeli değil mi? Biliniyorsa ya da yeni güncellemede düzeldiyse kusura bakma.

Positron için teşekkürler!
okmn

---

**Kanıt (bizim için, foruma konmaz):**
- `CNANO_KOMUT_56Q71.asm` (eski derleme, 02.10 00:09): `Led_Out` etiketinden sonra `bsf LATD,0` bank seçimsiz; aynı rutindeki `LATC,7` için `movlb 0x01` var.
- JonW'nin `MWBOOT_PIC.html` belgesi: "Positron assumes BSR = 5 whenever BASIC runs" — yani bank seçilmezse yazma bank 5'e (RAM 0x5xx) gider.
- Kitte gözlem: kablolu ve kablosuz durumda KOMUT okmn/53 sırasında RD0 sönük kaldı; monitör kaydı LED ON/off satırlarını gösterdi.
