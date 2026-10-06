# Telefon videosu senaryosu (2 kısa video)

## Video 1 — CNanoKit (≈2 dk, kitte KABLO YOK)

1. Proton IDE → `examples\CNANO_KOMUT_56Q71.bas` → **Program (CNanoProg)**.
   - Konsolda "programlandı ve doğrulandı" yazısını çek.
2. **Monitor (CNanoMonitor)** → Port: "COM… Curiosity" → **Bağlan**.
3. Kiti çek, sonra sırayla tıkla:
   - **okmn** → LED tık×4, 300 ms bekleme; **stop**'a basana kadar sürer.
   - **HEX:53** → LED yumuşak yanıp söner; stop'a kadar.
   - **come** → ekranda DATA satırları akar; stop'a kadar.
   - **stop** → durur.
   - Kablosuz çekimde kitteki LED0 gerçekten yanar; kablolu ise LED monitörde yazı/çubuk olarak görünür (ya da RD0'a takılı dış LED yanar).
4. Alttaki kutuya elle `okmn` yazıp **Gönder** → yazarak da çalıştığını göster.
5. (İsteğe bağlı) Positron Studio **F10** ve VS Code **Ctrl+Alt+M** ile aynı dosyayı bir kez daha programla.

## Video 2 — JonW önyükleyicisi (≈2 dk, kitte 2 KABLO)

Amaç dürüstçe şunu göstermek: önyükleyici çipte çalışıyor ve uygulamayı başlatıyor; FREELOADER.exe 1.1 ise DTR yüzünden bağlanamıyor.

1. Kit **USB'den çıkarılmışken** 2 kabloyu tak: RC6→RB4, RB5→RC7. Resim: `docs\Kablo_Baglanti_TR_01102026_2150.png`.
2. Kiti tak. Komut penceresinde şunu çalıştır. Birleşik hex = önyükleyici + JonW'nin UART test uygulaması:
   `CNanoProg.exe "C:\Tarim\araclar\CNano_Prog_01102026_1706\log\EXPECTED_UART_MERGED.hex" 18F56Q71`
   - Bu dosya daha önce `FREELOADER --merge` ile üretildi.
3. CNano Monitor → **Bağlan**.
   - Ekranda `UART 56Q71 n` satırları akar.
   - Bu satırları **önyükleyicinin başlattığı** uygulama yazıyor; uygulama UART1/RC6 üzerinden, kablo ile USB'ye ulaşıyor.
4. **PIC'i resetle** → satırlar yeniden başlar. Reset → önyükleyici → uygulama zinciri çalışıyor demektir.
5. Monitörde **Bağlantıyı kes**. Ardından FREELOADER.exe ile yüklemeyi dene → "Reset the board now…" ve zaman aşımı.
   - Bu, DTR sorununun kanıtıdır; JonW'ye anlatılan durum budur.
6. Bitince kabloları **USB çıkarılmışken** sök.

Not: Benim özel test betiğim (DTR açık) videoda gösterilmez ve paylaşılmaz.
