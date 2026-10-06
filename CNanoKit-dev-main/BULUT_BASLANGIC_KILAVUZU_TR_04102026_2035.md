# Bulutta Çalışmaya Başlama Kılavuzu — ilk kez öğrenen için (04.10.2026 20:35)

Bu dosya: C:\Tarim\Transfer_04102026_1955\BULUT_BASLANGIC_KILAVUZU_TR_04102026_2035.md
Kim için: GitHub'ı ve bulut asistanı'u ilk kez kullanan biri. Her adımı sırayla yap; bir adım bitmeden ötekine geçme. Takılırsan ekran görüntüsünü bana gönder.

> **Güncelleme 05.10.2026 (kullanıcı kararı):** yerel klasörler artık doğrudan C:\ altında: `C:\CNanoKit-dev`, `C:\Tarim_dev`, `C:\HLB_dev`, `C:\Video_Paketi_02102026_1640` (+ bir silinecekler klasörü). İçleri GitHub'dan çekilen temiz sürümlerle dolar. Aşağıdaki `C:\Tarim\Tarim-dev` ve `C:\CNanoKit\CNanoKit-dev` yolları ESKİDİR; okurken yerine yukarıdaki adları koy. Kaynak klasörleri (Microchip_Tools, Random Nerd…, FREELOADER…, DWIN…, ESP/STM/Arduino Tools, KiCad MCP Server) Google Drive ile eşitlenir; harita: `kaynak/KAYNAK_HARITASI_*.md`.


İşaretler: 🟢 = senin yapacağın iş · 🤖 = asistanın yapacağı iş · ⚠ = dikkat · ✔ = başarılı olduğunu nasıl anlarsın

---

## BÖLÜM 0 — Önce resmi büyük gör (masal gibi)

Üç tane "ev" var:
1. **Senin bilgisayarın** (C:\Tarim, C:\CNanoKit) → senin evin. Programları burada çalıştırırsın: Positron, KiCad, kit, LTspice.
2. **GitHub'daki gizli depo** (onderk/Tarim-dev, onderk/CNanoKit-dev) → kilitli bir **kasa**. Yalnız sen (ve izin verdiğin asistan) açabilir. Her şeyin resmi kopyası burada durur, eski hâlleri de saklanır.
3. **Bulut asistanı** (cloud session) → üreticinin uzaktaki bilgisayarında çalışan bir **usta**. Her sabah kasadan dosyaların bir kopyasını alır, çalışır, bitirdiğini yine kasaya koyar. Senin evine (bilgisayarına) giremez.

Dosyalar şöyle dolaşır:
```
 Senin bilgisayarın  ⇄  GitHub kasası (gizli depo)  ⇄  Bulut asistanı
 (GitHub Desktop ile)                                (kendisi alır/koyar)
```
**Cevaplar (senin soruların):**
- **"Her şey sadece bulutta mı kalacak?"** Hayır. Bulut asistanı ürettiği her şeyi GitHub kasasına koyar. Sen **GitHub Desktop** programıyla tek tıkla ("Pull") kasadakini kendi klasörüne indirirsin → her şeyin yedeği bilgisayarında da olur.
- **"Ürettiği kodu kendi bilgisayarımda çalıştırabilecek miyim?"** Evet. İndirdiğin .bas, .ps1, .py, .md… hepsi senin klasöründe normal dosyadır; Positron'da açıp derler, kite yüklersin.
- **"Commit + push'u ben mi yapacağım?"** Hayır. **Bulut asistanı kendi işini kendisi kaydeder ve kasaya gönderir** (commit + push) ve sana rapor verir. Bunu CLAUDE.md kurallarına yazdım (BÖLÜM 6). Senin yapacakların yalnız: 1) asistanın getirdiği değişikliği onaylamak (PR → Merge), 2) bilgisayarına indirmek (Pull), 3) senin bilgisayarında değiştirdiğin bir dosya varsa onu kasaya göndermek (GitHub Desktop'ta Commit + Push).
- **"Dal, PR, Merge'ü öğrettin mi?"** Hayır, henüz öğretmedim — önceki mesajımda "ilk oturumda öğretirim" demiştim; ayrı bir rehber YOKTU. Bu kılavuz o eksiği kapatıyor (BÖLÜM 7).

### Sözlük (5 kelime yeter)
| Kelime | Çocuk diliyle |
|---|---|
| **Repository / depo** | Projenin kilitli kasası (GitHub'da). Private = gizli kasa. |
| **Commit** | "Fotoğraf çek ve altına not yaz": dosyaların o anki hâli kaydedilir. Eskiye her zaman dönülebilir. |
| **Push / Pull** | Push = bilgisayardan kasaya gönder. Pull = kasadan bilgisayara indir. |
| **Branch / dal** | Kasanın içinde "deneme defteri". asistan önce kendi defterine yazar, ana defter (main) bozulmaz. |
| **Pull Request (PR) + Merge** | PR = "Defterimdeki değişiklikleri ana deftere geçireyim mi?" sorusu. Merge = "Evet, geçir." düğmesi. |

---

## BÖLÜM 1 — Klasör adlarını düzelt (1 dakika) 🟢
Bilgisayarında şu iki klasör var:
- C:\Tarim ✔ doğru
- **C:\CCNanoKit** ⚠ başında iki C var (bilgisayarını kontrol ettim). Konuştuğumuz ad **C:\CNanoKit**.

Düzeltme: Dosya Gezgini → C:\ → **CCNanoKit** klasörüne bir kez tıkla → klavyede **F2** → adı `CNanoKit` yap → Enter.
✔ C:\ içinde artık **CNanoKit** görünüyor.
(Not: C:\ içinde bir de **Taril** adlı klasör gördüm; yanlışlıkla açıldıysa kendin bakarsın — ben dokunmam.)

Bu iki klasör ne işe yarayacak? İçlerine birazdan GitHub kasalarının **kopyası** gelecek (BÖLÜM 4). Şimdilik boş kalsın; içine elle bir şey koyma.

---

## BÖLÜM 2 — Gizli kasa (Private depo) aç: Tarim-dev 🟢
1. Chrome/Edge'de **https://github.com/new** adresini aç (oturumun açık olmalı; sağ üstte senin fotoğrafın görünür).
2. Sayfada doldur:
   | Alan | Ne yazacaksın / seçeceksin | Neden |
   |---|---|---|
   | **Owner** | `onderk` | kasa senin hesabına ait olsun |
   | **Repository name** | `Tarim-dev` | adres github.com/onderk/Tarim-dev olur |
   | **Description** | `Private development workspace – not for distribution` | kendin için not; dışarı görünmez |
   | **Public / Private** | **● Private** ⚠ MUTLAKA | yalnız sen görürsün |
   | **Add a README file** | ☑ İşaretle | kasa boş kalmasın; bilgisayara kopyalarken boş kasa sorun çıkarır |
   | **Add .gitignore** | `None` | kendi .gitignore dosyamızı hazırladım (BÖLÜM 5) |
   | **Choose a license** | `None` | gizli iş; lisans gerekmez |
3. En alttaki yeşil **Create repository** düğmesine bas.
✔ Adres çubuğunda `github.com/onderk/Tarim-dev`, depo adının yanında gri **Private** etiketi görünür.
✔ Kontrol: Chrome'da **gizli pencere** (Ctrl+Shift+N) aç → github.com/onderk/Tarim-dev → **404** görmelisin (yabancılar göremiyor demek).

(CNanoKit-dev zaten var ve gizli — ona bir şey yapma.)

---

## BÖLÜM 3 — Bulut asistanı'a kasaların anahtarını ver (asistanın GitHub uygulaması) 🟢
Neden: "GitHub: Connected" yalnız hesabın tanındığını gösterir. Gizli bir kasayı bulut asistanı ancak **asistanın GitHub uygulaması** o kasaya kuruluysa açabilir (resmi belge: üreticinin belge sitesi, "on the web" sayfası → "GitHub authentication options").
1. **GitHub → Settings → Applications → Installed GitHub Apps → asistan uygulaması** adresini aç.
2. Sağda **Install** (ilk kez) ya da **Configure** (daha önce kurulduysa) düğmesine bas.
3. "Where do you want to install asistan?" sorarsa → **onderk** hesabını seç.
4. **Repository access** bölümünde:
   - ● **Only select repositories** seç (⚠ "All repositories" SEÇME — gerek yok).
   - **Select repositories** açılır listesinden **Tarim-dev** ve **CNanoKit-dev**'i ekle. (İstersen herkese açık **CNanoKit**'i de ekleyebilirsin; şart değil.)
5. Altta **Install** ya da **Save** düğmesine bas. GitHub şifre/onay isterse ver.
✔ Sayfada "Selected repositories: Tarim-dev, CNanoKit-dev" yazar.

---

## BÖLÜM 4 — Kasaların kopyasını bilgisayarına getir (GitHub Desktop) 🟢
GitHub Desktop: kasa ile bilgisayarın arasında düğmeyle çalışan ücretsiz program (GitHub'ın kendi programı).
1. Kurulu değilse: **https://desktop.github.com** → Download for Windows → kur → aç → **Sign in to GitHub.com** → tarayıcıda **Authorize** → onderk hesabın bağlanır.
2. Menü **File → Clone repository…** → **GitHub.com** sekmesi → listeden **onderk/Tarim-dev** seç.
3. **Local path** kutusuna: `C:\Tarim\Tarim-dev` yaz → **Clone**.
4. Tekrar **File → Clone repository…** → **onderk/CNanoKit-dev** → Local path: `C:\CNanoKit\CNanoKit-dev` → **Clone**.
✔ C:\Tarim\Tarim-dev\README.md ve C:\CNanoKit\CNanoKit-dev\CNanoKit_Gelistirme_OZEL_arsiv_03102026_2010.zip artık bilgisayarında.
Bundan sonra **kasanın bilgisayarındaki kopyası bu iki klasör**: C:\Tarim\Tarim-dev ve C:\CNanoKit\CNanoKit-dev.

---

## BÖLÜM 5 — İlk dosyaları kasaya koy 🤖 + 🟢
### 5a — Dosyaları klasöre ben kopyalarım 🤖
Bana "BÖLÜM 4 bitti" yaz. Ben C:\Tarim ve C:\CNanoKit için erişim isteyeceğim (ekranında bir onay penceresi çıkar → **İzin ver**). Sonra KOPYALARIM (C:\Tarim'daki asıllar yerinde kalır, hiçbir şey silinmez/taşınmaz):

**C:\Tarim\Tarim-dev\ içine:**
| Ne | Nereden |
|---|---|
| CLAUDE.md | C:\Tarim\Transfer_04102026_1955\Tarim_depo_koku_04102026_2015\CLAUDE.md |
| .gitignore | C:\Tarim\Transfer_04102026_1955\Tarim_depo_koku_04102026_2015\.gitignore |
| Tarim_TRANSFER_KUTUK_04102026_1955.md | C:\Tarim\Transfer_04102026_1955\ |
| Kutuk\ | C:\Tarim\Kutuk\ |
| firmware\, karar_mekanizmasi\, kicad\ | C:\Tarim\ |
| asistan_kaynaklar\ (öğrenim notları, şemalar, simülasyon, testler, datasheet'ler, DWIN) | C:\Tarim\asistan_kaynaklar\ |
| RSP-750-SPEC.pdf, XL4016-Datasheet.pdf, tarım_ilacı_proje_önder.rtf.docx | C:\Tarim\ |
| ⚠ KONMAZ | .anahtarlar\ (API anahtarları), CNanoKit klasörleri, araclar\kicad-mcp-pro_* (başkasının kodu), 67 MB .rtf.doc (GitHub'ın 100 MB sınırının altında ama gereksiz büyük — .docx yeterli; istersen ekleriz) |

**C:\CNanoKit\CNanoKit-dev\ içine:**
| Ne | Nereden |
|---|---|
| CLAUDE.md, .gitignore | C:\Tarim\Transfer_04102026_1955\CNanoKit_depo_koku_04102026_2015\ |
| CNanoKit_TRANSFER_KUTUK_04102026_1955.md | C:\Tarim\Transfer_04102026_1955\ |
| Kutuk\ (CNanoKit kütüğü) | yeni açacağım |
| kaynak\ = arşivin AÇILMIŞ hâli (457 dosya) | C:\Tarim\CNanoKit_Gelistirme_OZEL_03102026_1910\ |
| yayin\ = public depo kaynağı | C:\Tarim\CNanoKit_GitHub_YAYIN_03102026_1910\repo\ |

### 5b — Kasaya gönder (commit + push) 🟢 — ilk ve en önemli dersin
1. GitHub Desktop'u aç → sol üstte **Current repository** → **Tarim-dev** seç.
2. Solda "Changes" listesinde yeni dosyalar görünür (yüzlerce olabilir — normal).
3. Sol altta **Summary** kutusuna: `Ilk yukleme: transfer kutugu ve proje dosyalari` yaz.
4. **Commit to main** düğmesine bas. (Fotoğraf çekildi, kasaya henüz gitmedi.)
5. Üstte **Push origin** düğmesine bas. (Şimdi kasaya gitti.)
6. Aynısını **CNanoKit-dev** için yap.
✔ github.com/onderk/Tarim-dev sayfasını yenile → dosyalar orada.
⚠ Commit listesinde **.anahtarlar** ya da **api.env** görürsen DURMA tuşu: Commit'e basma, bana yaz.

---

## BÖLÜM 6 — İlk bulut oturumunu başlat 🟢
### "Project olarak açma" ne demek?
- asistan masaüstü uygulamasında **sol menüdeki "Projects"** (ör. Tarim) = sohbet projeleri. Bulut kredisi bunlarda GEÇMEZ.
- asistan aracı içinde de "project" adlı çoklu oturum özelliği var; o da kredi dışı (resmi destek sayfası: "Not eligible for Projects and Routines").
- **Doğru yol:** düz bir **Code** oturumu, ortamı **Cloud** seçerek.

### Adımlar
1. asistan masaüstü uygulamasında **Code** bölümüne geç (ekran görüntündeki "Code" penceresi) → **+ New**.
2. Oturum ayarlarında **Local** yerine **Cloud** seç.
3. **Repository** olarak `onderk/Tarim-dev` seç (CNanoKit için ayrı oturumda `onderk/CNanoKit-dev`).
4. İlk mesaj kutusuna şunu yapıştır:
   ```
   Merhaba. Önce depo kökündeki CLAUDE.md ve Tarim_TRANSFER_KUTUK_04102026_1955.md dosyalarının TAMAMINI, sonra Kutuk/ içindeki en son kütüğü oku. Bana Türkçe kısa bir "anladım" özeti ve sıradaki 3 adımı yaz. Kod yazma.
   ```
   (CNanoKit oturumunda dosya adı CNanoKit_TRANSFER_KUTUK_04102026_1955.md.)

### "İlk mesaj olarak transfer kütüğünü ekle" ne demekti?
Yeni asistan hiçbir şey hatırlamaz; geçmişi ona bir kere okutmak gerekir. Dosya kasada olduğu için **eklemene gerek yok** — yukarıdaki cümle onu kasadan okutur. Ayrıca CLAUDE.md'yi asistan aracı her oturum başında **kendiliğinden** okur (resmi davranış). İstersen dosyayı ataç (📎) ile de ekleyebilirsin; ikisi de olur.

✔ Ayarlar → Usage → "Cloud session credits" birkaç dakika sonra 250'den azalmaya başlar → kredi doğru yerde harcanıyor.

---

## BÖLÜM 7 — Günlük döngü (her çalışma günü) 🟢🤖
```
 1. Sen: bulut oturumunda isteğini yaz
 2. 🤖 asistan: çalışır → kendi dalına (asistan/...) commit + push yapar → PR açar → sana TÜRKÇE RAPOR yazar:
        ne değişti, hangi dosyalar (tam yol), PR bağlantısı, senin yapacağın adım
 3. Sen: PR'ı incele → onayla (Merge)
 4. Sen: GitHub Desktop → Fetch origin → Pull origin  → dosyalar bilgisayarında
 5. Sen: bilgisayarında derle/dene (Positron, kit) → sonucu bulut asistanı'a yaz
 6. Sen bilgisayarında bir dosya değiştirdiysen: GitHub Desktop → Commit to main → Push origin
```
### 7a — PR'ı incele ve birleştir (Merge) — adım adım
1. asistanın raporundaki PR bağlantısına tıkla (ya da github.com/onderk/Tarim-dev → üstte **Pull requests** sekmesi → en üstteki).
2. **Files changed** sekmesi: yeşil satırlar = eklenen, kırmızı = silinen. Göz at (her satırı anlaman gerekmez; dosya adları ve rapor uyuşuyor mu?).
3. **Conversation** sekmesine dön → aşağıda yeşil **Merge pull request** → **Confirm merge**.
4. (İsteğe bağlı) **Delete branch** düğmesi çıkar — dal silmek dosya silmek DEĞİLDİR; ana defter (main) güvende. Emin değilsen basma, kalsın.
✔ PR'ın üstünde mor **Merged** etiketi.
Alternatif: bulut oturumunun içindeki **diff** göstergesine (+42 −18 gibi) tıklayarak da değişiklikleri görebilir, satırlara yorum yazıp asistana gönderebilirsin.

### 7b — Bilgisayarına indir (Pull)
GitHub Desktop → **Current repository** doğru mu? → **Fetch origin** → düğme **Pull origin** olur → bas.
✔ Klasörde yeni/değişen dosyalar görünür.

### 7c — Senin değişikliğini kasaya gönder
GitHub Desktop → Summary'ye kısa not → **Commit to main** → **Push origin**. Sonraki bulut oturumu senin değişikliğini görür.

---

## BÖLÜM 8 — Neyi kim yapar? (özet tablo)
| İş | Kim | Nerede |
|---|---|---|
| Plan, belge, hesap betiği, kod taslağı, README, kütük | 🤖 Bulut asistanı | bulut + kasa |
| Kendi işini commit + push + PR + rapor | 🤖 Bulut asistanı | kasa |
| PR'ı onaylama (Merge) | 🟢 Sen | github.com |
| Kasadan bilgisayara indirme (Pull) | 🟢 Sen | GitHub Desktop |
| Derleme, kite yükleme, ölçüm, KiCad/LTspice ekranı, video, forum mesajı | 🟢 Sen (ya da masaüstü asistan) | bilgisayarın |
| Bilgisayardaki değişikliği kasaya gönderme | 🟢 Sen | GitHub Desktop |

## BÖLÜM 9 — Sık sorulan endişeler
- **"Kasa silinirse?"** Bilgisayarındaki kopya (C:\Tarim\Tarim-dev) duruyor; ayrıca C:\Tarim asılları hiç değişmedi.
- **"asistan yanlış bir şey yaparsa?"** Kendi dalında yapar; sen Merge demeden ana deftere girmez. Merge'den sonra bile her commit'e geri dönülebilir.
- **"Oturum kapanırsa?"** asistan her önemli adımda commit + push yapar (kural); kapanınca konuşma geri gelir, kasadaki iş kaybolmaz.
- **"Kredi bitince?"** 5 Kasım 2026 10:59'dan sonra ya da 250 $ bitince bulut oturumları normal plan kullanımından düşer; çalışmaya devam eder.
- ⚠ Bulut asistanı bilgisayarındaki Positron'u, KiCad'i, kiti GÖREMEZ — bu işler masaüstünde.

## Sıradaki adımın
BÖLÜM 1 → 2 → 3 → 4'ü yap, sonra bana **"BÖLÜM 4 bitti"** yaz; BÖLÜM 5a'yı ben yaparım.
