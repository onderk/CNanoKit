# Uyum raporu — CNanoKit, JonW (FREELOADER) ve Les (Positron / Proton IDE)

Tarih: 01.10.2026 · Kapsam: bu oturumda üretilen her dosya · Yalnız sizin için, paylaşılmaz.

## 1. JonW (FREELOADER) — lisansındaki kurallar ve durumumuz

JonW'nin lisans başlığı (P56Q71 dosyalarında): *"Free to use under LICENSE.txt – modified versions may not be distributed and this notice must stay."*

| Kural | Durum | Kanıt / yer |
|---|---|---|
| Değiştirilmiş sürüm dağıtılamaz | ✅ Uyuluyor | Tek değiştirilmiş kopya `P56Q71_CNANO_BLINK.bas`/`_UART.bas` (yalnız LED pini). Yerelde duruyor: `C:\Tarim\Q71_CNano_Test_01102026_1706\`. Hiçbir pakette yok. |
| Lisans başlığı kalmalı | ✅ | Yerel kopyada başlık korundu. |
| Python kaynakları pakete konamaz | ✅ | CNanoKit'te JonW'nin Python ya da Positron kodu yok. |
| FREELOADER.exe yalnız değiştirilmeden, ücretsiz paketlerde | ✅ (daha iyisi) | Hiç konmadı; kılavuz yalnız forum konusuna yönlendiriyor. |
| Özel test istemcisi `mwtest_upload.py` | ⚠ Dikkat | Protokolü JonW'nin kaynak yorumlarından okuyarak yazıldı. Yalnız yerel test içindir (`araclar\CNano_Prog_01102026_1706\`). **Asla paylaşmayın.** Forum mesajında da bunu açıkça söylüyoruz. |
| `CNanoProg -Mode freeloader` | ✅ | Yalnız kullanıcının kendi indirdiği FREELOADER.exe'yi çağırır; FREELOADER'dan kod içermez. |
| Kablo resmi | ✅ | JonW'ye ait bir şey içermez. |

## 2. Les (Positron8, Positron Studio, Proton IDE)

| Konu | Durum | Not |
|---|---|---|
| Positron/Proton dosyalarını kopyalama veya değiştirme | ✅ Yok | Pakette Positron'a ait hiçbir dosya yok (derleyici, DLL, IDE). |
| Lisans/aktivasyon | ✅ Dokunulmadı | Derleme, kullanıcının kendi lisanslı Positron'u ile yapılıyor. |
| `PositronStudio.ini`, VS Code `settings.json` | ✅ | Yalnız kullanıcı ayarına programlayıcı/araç satırı ekleniyor, önce yedekleniyor. IDE'nin kendi menüsünden yapılabilecek işin aynısı. |
| Proton IDE eklentisi | ✅ belgeli arabirim | `mcPluginMgr.dll` Proton IDE ile gelen **Plugin Manager**'ın belgelenmiş arabirimi (PluginMgr.chm, cPluginInterface.pas). DLL pakete konmuyor, yalnız çağrılıyor. |
| `.mcp` dosyaları | ⚠ küçük not | Biçim, Proton IDE'nin kendi Plugin Editor'ünün ürettiği dosyadan okunarak kopyalandı. Zararsız, ama paylaşmadan önce Les'e "uygun mu?" diye sormak nazik olur (forum mesajında var). |
| "Proton IDE Program düğmesi çalışmıyor" ifadesi | ✅ yumuşatıldı | Kılavuzlarda "geliştiricinin Windows 11 PC'sinde harici programlayıcıyı başlatmadı" diye, hata suçlaması olmadan yazıldı. |

## 3. Microchip

- Pinout çizimi Microchip'e ait. Resimlerde kaynak belirtildi ("Pinout drawing: Microchip Technology Inc.").
- Belge açıklaması için yaygın bir kullanımdır, ama ticari bir paket olacaksa Microchip'in kullanım koşullarına ayrıca bakılmalı. Bu bir varsayımdır; hukuki görüş değildir.
- pymcuprog (MIT) ve cihaz paketleri (Apache-2.0) pakete konmuyor, kurulumda Microchip'ten indiriliyor.

## 4. Yayın kararı (sizin kararınız, kayıt altında)

- GitHub ve forumda paket/bağlantı paylaşımı, **JonW ve Les görüş bildirdikten sonra** yapılacak.
- İlk yayında `src\` (C kaynakları) yok. `.ps1` dosyaları doğası gereği düz metindir; bu, kullanıcının programın zararsız olduğunu görebilmesi için bir artıdır.

**Sonuç:** Bilinen bir ihlal yok. Tek hassas nokta özel test betiği `mwtest_upload.py`; asla paylaşılmamalı.
