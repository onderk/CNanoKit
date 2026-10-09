# CNanoKit — Kütük 04.10.2026 23:00 (İstanbul) — ilk bulut oturumu: ad temizliği

## Yapılanlar
1. **Kural 0 (kalıcı):** depodaki hiçbir dosya/dosya adı/kod/commit/PR metninde kişi adı, asistan/üretici adı ve eski proje adı geçmez; proje adı yalnız "Tarim", bu depoda "CNanoKit". İstisnalar CLAUDE.md'de: dosyanın adı, kural bölümü, JonW/Les atıfları, Positron'un `.asm` lisans satırı, git geçmişi. → `/CLAUDE.md`
2. **Otomatik imza kapatıldı:** `/.claude/settings.json` (`attribution.commit=""`, `attribution.pr=""`, `attribution.sessionUrl=false`, `includeCoAuthoredBy=false`; belgeden doğrulandı [A]). Commit yazarı depo yerelinde `okmn <onderk@users.noreply.github.com>`.
3. **Tarama** (dosya adı + içerik, UTF-8 ve UTF-16, zip içi, git geçmişi): git geçmişi temiz; 100 dosyada eşleşme; "gönder" kelimesi ve "onderk" yanlış alarm.
4. **Temizlik (kullanıcı onayı 04.10 22:40):** 37 dosya; kütükler ve bulut kılavuzunda adlar → "asistan/üretici/kullanıcı"; yollar `C:\Tarim\...`, `C:\CNanoKit\...`; derleyici izleri (`.lst/.mci/.mcp/.bat/.txt` içindeki yollar) düzeltildi (`.mcp` uzunluk baytı yeniden hesaplandı); üretici sitelerine giden 4 bağlantı açıklamaya çevrildi; `kaynak/Tarim_KUTUK_03102026_1855.md` yeniden adlandırıldı; `_silinecek/` klasörü açıldı (eski `_claude_delete` yerine).
5. **Resimler:** `/yayin/images/` 2 PNG public depodaki temiz kopyalarla değiştirildi (SHA256 public ile aynı, C2PA yok). 5 C2PA'lı eski PNG + özel arşiv zip'i → `/_silinecek/` (içlerinde eski adlar duruyor; gerçek silme kullanıcının).
6. Dış kontrol: public depo README.md ve index.html'de forum bağlantısı (topic 3440) var = 3. ders tamam.

## Kararlar (kullanıcı)
- JonW / Jon Walker / Les adlarına dokunulmaz (atıf).
- Positron'un `.asm` 14. satırına yazdığı lisans adı kalır.
- Git geçmişi yeniden yazılmaz.

## Bekleyenler
- PR'ı kullanıcı birleştirir; GitHub Desktop'ta Pull.
- `_silinecek/` içindekilerin gerçek silinmesi (kullanıcı).
- `kaynak/02_test_araclari/CNanoProg_01102026_1721/KILAVUZ_TR_01102026_1850.md` ve `kaynak/06_paylasim_metinleri/Video_Senaryosu_01102026_2330.md` taşınan PNG'lere atıf yapıyor (arşiv belgesi, dokunulmadı).
- Sıradaki: CNanoKit 2.0 seçenek raporu (kod yazmadan); JonW 2. cevap; Les'e bank hatası konusu.
