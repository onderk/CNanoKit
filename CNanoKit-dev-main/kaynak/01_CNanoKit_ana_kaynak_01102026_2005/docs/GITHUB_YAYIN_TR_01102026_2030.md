# GitHub'da ilk yayın — adım adım (Türkçe)

Bu kılavuz CNanoKit'i GitHub'da **kendiniz** yayınlamanız için yazıldı. Git komutu bilmeniz gerekmez; her şey tarayıcıdan yapılır. Toplam süre yaklaşık 30–45 dakikadır.

Bu kılavuz **web sayfası** yolunu anlatır, çünkü en kolayı budur. İleride isterseniz **GitHub Desktop** programına geçebilirsiniz (bölüm 9).

> **Zamanlama kararı (01.10.2026):** GitHub ve forum yayını, Jon Walker ve Les'in görüşü/onayı alındıktan **sonra** yapılacak. İlk yayında **`src\` klasörü (C kaynakları) konmaz**; kaynak, geliştirmek isteyen biri ciddi olarak isterse ayrıca paylaşılır.

---

## 0. Yayından önce kontrol listesi (5 dakika)

- [ ] Yayınlayacağınız klasör, size verilen **temiz paket** olmalı: `CNanoKit_v0.5_…zip` içinden çıkan klasör.
- [ ] İçinde **`src\` klasörü YOK** (kaynak talep üzerine).
- [ ] İçinde **`log\` klasörü ve `settings.ini` YOK**. Bunlar sizin PC'nize özeldir; port numarası ve kayıtlar içerir.
- [ ] İçinde **Jon Walker'ın dosyaları YOK**: FREELOADER.exe, `P56Q71_*.hex`, `.bas` ve `.py` dosyaları. Onun lisansı kaynak dağıtımına izin vermiyor.
- [ ] Dosyalarda gerçek adınız, e-postanız ya da şirket/proje adınız geçmiyor. Kontrol için klasörde Windows Arama'ya adınızı yazın; sonuç çıkmamalı.
- [ ] `README.md` dosyası klasörün **en üstünde**. GitHub ön sayfası budur.

---

## 1. GitHub hesabı (bir kez)

1. **https://github.com/signup** adresine gidin.
2. E-posta, parola ve **kullanıcı adı** girin. Kullanıcı adı herkese görünür; öneri: **okmn**. Alınmışsa `okmn-pic` ya da `okmn-dev` gibi bir ad seçin.
3. E-postanıza gelen kodu girin. Ücretsiz plan (**Free**) yeterli.
4. **İki adımlı doğrulama (2FA):** GitHub bunu yeni hesaplarda zorunlu tutuyor.
   - Settings → **Password and authentication** → *Enable two-factor authentication*.
   - Telefonunuza bir doğrulayıcı uygulama kurun: Microsoft Authenticator ya da Google Authenticator.
   - **Kurtarma kodlarını (recovery codes) indirip güvenli bir yere saklayın.** Telefonu kaybederseniz hesaba bunlarla girersiniz.
5. **Gizlilik:**
   - Settings → **Emails** → **"Keep my email addresses private"** kutusunu işaretleyin.
   - Settings → **Public profile**: *Name* alanını boş bırakın ya da `okmn` yazın. Fotoğraf koymak zorunlu değil.

---

## 2. Yeni depo (repository) açın

1. Sağ üstteki **+** → **New repository**.
2. Alanları doldurun:
   - **Repository name:** `CNanoKit`
   - **Description:** `Program and monitor the PIC18F56Q71 Curiosity Nano from Positron Studio, Proton IDE or VS Code - no MPLAB X needed (TR/EN)`
   - **Public** seçili olsun. Herkes görebilir; değiştirmeyi yalnız siz yapabilirsiniz.
   - **Add a README file:** işaretlemeyin; bizim README'miz var.
   - **Add .gitignore:** None.
   - **Choose a license:** None. Lisans dosyamız (`LICENSE.txt`) zaten pakette var.
3. **Create repository** düğmesine basın.

---

## 3. Dosyaları yükleyin

1. Açılan boş depo sayfasında **"uploading an existing file"** bağlantısına tıklayın.
2. Paket klasörünü açın (örneğin `C:\CNanoKit_yayin`). **İçindeki her şeyi** seçin (Ctrl+A) ve tarayıcıdaki kutuya **sürükleyip bırakın**.
   - Klasörler (`docs`, `examples`, `src`) de sürüklenebilir; Chrome ve Edge bunu destekler.
   - Sınır: tek seferde en çok 100 dosya, dosya başına en çok 25 MB. Paketimiz bunun çok altında.
3. Aşağıdaki **Commit changes** bölümünde:
   - Üst kutu: `CNanoKit 0.5 ilk yayin / first release`
   - "Commit directly to the main branch" seçili kalsın.
4. **Commit changes** düğmesine basın. Yükleme birkaç saniye sürer.
5. **Kontrol:**
   - Depo ana sayfasında dosyalar listelenmeli.
   - Altta README Türkçe ve İngilizce görünmeli.
   - Sağ tarafta lisans **"MIT license"** olarak görünmeli. GitHub bunu `LICENSE.txt`'den tanır.

---

## 4. Konu etiketleri (bulunabilirlik)

1. Depo ana sayfasında sağdaki **About** yanındaki dişli simgesine tıklayın.
2. **Topics** kutusuna şunları yazın: `pic18`, `positron`, `proton-ide`, `curiosity-nano`, `microchip`, `pic18f56q71`, `pymcuprog`, `serial-monitor`.
3. **Save changes**.

---

## 5. Sürüm (Release) yayınlayın — kullanıcıların indireceği zip

1. Depo sayfasında sağdaki **Releases** → **Create a new release** (ya da *Draft a new release*).
2. **Choose a tag** → `v0.5` yazın → **Create new tag: v0.5 on publish**.
3. **Release title:** `CNanoKit 0.5`
4. **Açıklama kutusu** (kopyalayıp yapıştırın):

   ```
   TR: PIC18F56Q71 Curiosity Nano kitini Positron Studio (F10), Proton IDE (eklenti dugmeleri)
   veya VS Code (Ctrl+Alt+M) ile programlayin; CNano Monitor ile USB uzerinden konusun.
   MPLAB X gerekmez. Kurulum: zip'i indirin, docs\KURULUM_TR_...md dosyasini okuyun.

   EN: Program the PIC18F56Q71 Curiosity Nano from Positron Studio (F10), Proton IDE
   (plugin buttons) or VS Code (Ctrl+Alt+M); talk to it over USB with CNano Monitor.
   No MPLAB X needed. Setup: download the zip, read docs\INSTALL_EN_...md.

   Tested: Windows 11 Pro, Positron8 4.0.6.4, Python 3.14.7, pymcuprog 3.19.4.61.
   ```
5. **"Attach binaries by dropping them here"** kutusuna paket zip'ini sürükleyin: `CNanoKit_v0.5_….zip`.
6. **Set as the latest release** işaretli kalsın → **Publish release**.
7. **Kontrol:**
   - Releases sayfasında zip'iniz görünmeli. GitHub ayrıca "Source code (zip)" dosyasını kendisi ekler; bu normaldir.
   - Zip'i kendiniz indirin ve başka bir klasöre açın. Kurulum kılavuzunun 3. adımını bir kez deneyin.

---

## 6. Paylaşım

- Depo adresi: `https://github.com/<kullanıcı-adınız>/CNanoKit`
- Foruma yazarken bu adresi ve **Releases** sayfasını verin. Forum mesajı taslakları ayrıca hazırlandı (TR ve EN).

---

## 7. Sonraki sürümler (güncelleme)

1. Yeni dosyaları depo sayfasında **Add file → Upload files** ile aynı yerlere sürükleyin. Aynı adlı dosyalar üzerine yazılır.
2. Commit mesajına neyin değiştiğini yazın: örneğin `0.5: SW0 duzeltmesi`.
3. Yeni bir Release açın: tag `v0.5`, yeni zip.
4. Silinecek eski bir dosya varsa: dosyaya tıklayın → sağ üstte **…** → **Delete file** → Commit.
   - Bu silme GitHub'daki deponuzdadır, PC'nizde değil. Eski hâli geçmişte (History) kalır.

---

## 8. Kullanıcılardan geri bildirim

- **Issues** sekmesi, hata bildirimi içindir; varsayılan olarak açıktır. Yeni bir Issue gelirse GitHub e-posta gönderir.
- İsterseniz Settings → General → Features altından **Discussions**'ı açabilirsiniz (soru-cevap için).

---

## 9. (İleride) GitHub Desktop ile çalışmak

- **https://desktop.github.com** adresinden kurun → hesabınızla giriş yapın → **File → Clone repository** → `CNanoKit`.
- PC'nizde bir klasör oluşur. Dosyaları orada değiştirin. GitHub Desktop değişiklikleri listeler. Alta bir mesaj yazın → **Commit to main** → **Push origin**.
- Web yükleme ile aynı işi yapar, sadece büyük güncellemelerde daha rahattır.

---

## 10. Güvenlik notları

- Parolanızı ve kurtarma kodlarınızı kimseyle paylaşmayın. GitHub hiçbir zaman e-postayla parola istemez.
- Depoya **asla** parola, API anahtarı ya da kişisel belge koymayın. Yanlışlıkla koyarsanız silmek yetmez, çünkü geçmişte kalır: o parolayı değiştirin.
- Başkasının programını (ör. FREELOADER) depoya koymayın. Bağlantı verin.

---

Terimler: *repository / depo* = proje klasörünün GitHub'daki hâli · *commit* = kaydedilmiş bir değişiklik · *release* = indirilebilir bir sürüm · *tag* = sürüm etiketi (v0.5) · *issue* = hata/istek kaydı.
