# Forum taslağı — CNanoProg paylaşımı (protoncompiler.com) — 01102026_1900

Bu metni **sen gönderirsin**; ben göndermem. Zip dosyasını mesaja ek olarak koy: `CNanoProg_v0.3_01102026_1900.zip`.

Hangi bölüme:

- Ayrı bir konu açacaksan: "Positron8 / tools" benzeri bir bölüm.
- Ya da JonW'nin FREELOADER konusuna kısa bir not olarak.

Gönderme sırası önerim:

1. Önce FREELOADER gerçek kart testini bitirelim.
2. Sonra tek mesajda hem JonW'ye test sonucunu hem bu aracı paylaşalım.

---

## ENGLISH (to post)

**Title:** CNanoProg - program a Curiosity Nano board from Positron Studio / VS Code (free)

Hello all,

I made a small free tool that lets Positron Studio and the VS Code Positron extension program a Microchip Curiosity Nano board directly, with no MPLAB X or IPE window.

- Tested on the PIC18F56Q71 Curiosity Nano (nEDBG), Windows 11.
- Positron Studio "Compile and Program" (F10) erases, writes and verifies flash, config and EEPROM in about 2-4 seconds.
- Before writing, it checks that the PIC on the kit is the PIC the program was compiled for, and it checks the hex records.
- It uses Microchip's own pymcuprog (free, open source). If that is not installed, it falls back to the kit's drag-and-drop drive.
- `-Mode monitor` is a simple two-way serial terminal on the kit's virtual COM port. Print from your program over UART2 (RB4/RB5 on this kit) and read it on the PC. It is not a real debugger, but it is handy.
- A one-time setup installs pymcuprog, downloads the device pack from packs.download.microchip.com and adds the programmer to Positron Studio and VS Code.

Positron Studio setting (Tools > Configure Programmers):
Executable `CNanoProg.exe`, Parameters `$long-hex-filename$ $target-device$`
Do not type quotes around the parameters; Positron Studio adds them itself. Quotes typed in this box gave me a "Programmers record error" at the next start.

Proton IDE: on my PC its Program button does not start any programmer, not even MicroCode Loader, so I could not support it.

MIT licence. Source of the small launcher is included. Feedback and tests on other Curiosity Nano boards are very welcome.

Thanks to Les for Positron and to JonW for FREELOADER.

okmn

---

## TÜRKÇE (anlaman için, gönderilmeyecek)

**Başlık:** CNanoProg — Curiosity Nano kartını Positron Studio / VS Code'dan programlama (ücretsiz)

Herkese merhaba,

Ücretsiz küçük bir araç yaptım. Positron Studio ve VS Code Positron eklentisi, Microchip Curiosity Nano kartını MPLAB X veya IPE penceresi açmadan doğrudan programlayabiliyor.

- PIC18F56Q71 Curiosity Nano (nEDBG) ve Windows 11 üzerinde test ettim.
- Positron Studio'da "Compile and Program" (F10), flash, config ve EEPROM'u yaklaşık 2–4 saniyede siler, yazar ve doğrular.
- Yazmadan önce kartın üstündeki PIC'in, programın derlendiği PIC ile aynı olduğunu kontrol eder. Hex kayıtlarını da kontrol eder.
- Microchip'in kendi aracı pymcuprog'u kullanır (ücretsiz, açık kaynak). O kurulu değilse, kartın sürükle-bırak sürücüsüne geçer.
- `-Mode monitor`, kartın sanal COM portu üzerinde basit, iki yönlü bir seri terminaldir. Programından UART2 ile yazdır (bu kartta RB4/RB5), bilgisayarda oku. Gerçek bir debugger değil ama işe yarar.
- Tek seferlik kurulum şunları yapar: pymcuprog'u kurar, cihaz paketini packs.download.microchip.com'dan indirir, programlayıcıyı Positron Studio ve VS Code'a ekler.

Positron Studio ayarı (Tools > Configure Programmers):
Program `CNanoProg.exe`, Parametreler `$long-hex-filename$ $target-device$`
Parametrelerin etrafına tırnak yazma; Positron Studio tırnakları kendisi ekler. Bu kutuya tırnak yazınca bir sonraki açılışta "Programmers record error" hatası aldım.

Proton IDE: benim bilgisayarımda Program düğmesi hiçbir programlayıcıyı başlatmıyor, MicroCode Loader'ı bile. Bu yüzden Proton IDE'yi destekleyemedim.

MIT lisansı. Küçük başlatıcının kaynak kodu da pakette. Görüşlerinizi ve başka Curiosity Nano kartlarındaki test sonuçlarınızı memnuniyetle beklerim.

Positron için Les'e, FREELOADER için JonW'ye teşekkürler.

okmn
