# CNanoKit — her bulut oturumunun kuralları (asistan aracı bu dosyayı otomatik okur)

## 0. KALICI ÜST KURAL — adlar (04.10.2026, kullanıcı kararı)
Bu depodaki HİÇBİR dosyada, dosya adında, kodda, commit mesajında ve PR metninde **kişi adı**, "Claude"/"Anthropic" adı ve **"Etna"** kelimesi GEÇMEZ. Proje adı yalnızca **"Tarim"**; bu depoda **"CNanoKit"** kalabilir. Dış kimlik yalnız **"okmn"** (GitHub hesabı onderk istisna — kalıcı karar).
İstisnalar: (a) bu dosyanın adı (araç bu adı zorunlu kılar) ve yasaklı kelimeleri tanımlayan bu kural bölümü; (b) forum takma adları JonW/Jon Walker ve Les (atıf, kullanıcı kararı 04.10.2026); (c) Positron derleyicisinin `.asm` dosyalarına kendisi yazdığı lisans satırı ("Compiler version for …", kullanıcı kararı: kalsın); (d) git geçmişi yeniden yazılmaz. Silinecek dosyalar `_silinecek/` klasörüne taşınır (içlerinde eski adlar kalabilir; gerçek silme kullanıcınındır). Commit/PR'lara otomatik imza eklenmez (`.claude/settings.json` → `attribution`). Yayından önce her dosya UTF-8 + UTF-16 taranır.
1. ÖNCE oku: kökteki CNanoKit_TRANSFER_KUTUK_*.md + Kutuk/ içindeki EN SON kütük. Sonra kullanıcıya Türkçe kısa özet + sıradaki adım.
2. Cevaplar Türkçe; kısa ama eksiksiz; GitHub işlemlerini her adımda "çok kolay" dille anlat (kullanıcı öğreniyor); her dosya için TAM yol.
3. Kanıt: Microchip belgeleri, Positron el kitabı, Les'in forum cevapları; [A]/[B]/[C]; uydurma yok.
3a. KAYNAK HARİTASI: Teknik bir işe başlamadan önce kaynak/KAYNAK_HARITASI_*.md dosyasına (en yeni tarihli) bak; belgeyi Drive aracıyla (klasör/dosya ID'leri haritada) ya da katalogdaki resmî web adresinden oku; kaynağı [A] etiketiyle (belge adı + numara + sayfa/bölüm) göster. Dosya dosya liste: kaynak/KAYNAK_KATALOGU_*.md. Lisanslı içerik (Random Nerd, Positron8 kılavuzu, üçüncü kişi kodları) yalnız başvuru içindir; hiçbir herkese açık yere konmaz.
4. PAYLAŞIM: public depo onderk/CNanoKit'e ve foruma giden hiçbir şeyde kural 0'daki adlar, "Tarim" proje adı ve kişisel yollar (C:\Users\...) GEÇMEZ; yalnız "okmn". Yayından önce tarama (UTF-8 + UTF-16, exe içi). Kaynak kod (.ps1, src/) public depoya ASLA konmaz.
5. Resim: asistanın yazdığı PNG/JPG'ye C2PA üretici kimliği eklenebilir; silinmez; paylaşılacak resmi kullanıcı kendisi kaydedip yükler.
6. JonW dosyaları (P56Q71_MWBOOT.hex, FREELOADER) yeniden dağıtılmaz; bu depo herkese açılacaksa önce çıkar.
7. Hiçbir şey silinmez → _silinecek/ klasörüne taşı. Ad: ad_GGAAYYYY_SSDD (README.md, CLAUDE.md istisna).
8. Her oturum sonunda Kutuk/CNanoKit_KUTUK_GGAAYYYY_SSDD.md + commit + push.
9. Bu oturum kiti/IDE'leri/Positron'u GÖREMEZ: derleme, programlama, monitör ve video kullanıcının PC'sinde; ona adım ver.

## Kaydetme ve rapor (zorunlu)
10. Her anlamlı adımdan sonra kendi dalında commit + push yap; iş bitince PR aç (başlık Türkçe, kısa).
11. Her iş sonunda kullanıcıya TÜRKÇE RAPOR: ne yaptın, değişen dosyalar (depo içi tam yol), PR bağlantısı, kullanıcının yapacağı adım (Merge → GitHub Desktop'ta Fetch/Pull → bilgisayarında ne denenecek). GitHub adımlarını çok kolay dille anlat.
12. main dalına doğrudan push YOK; PR'ı kullanıcı birleştirir (Merge).
13. Commit yazarı depo yerelinde `okmn <onderk@users.noreply.github.com>` (git config user.name/user.email); otomatik imza satırı eklenmez.
