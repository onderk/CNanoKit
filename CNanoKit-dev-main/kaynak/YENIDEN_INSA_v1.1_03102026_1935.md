# CNanoKit v1.1 — bugünkü hâli yeniden inşa etme (03.10.2026)

## Bu arşivde olanlar (yeterli mi? → EVET, aşağıdaki dış araçlarla)
- Program kaynakları: `01_...\CNanoProg.ps1`, `CNanoMonitor.ps1`, `CNanoProg_Setup.ps1`, `CNanoProg_Setup.bat`
- Başlatıcı ve Proton eklentisi kaynakları: `01_...\src\CNanoProg.c`, `src\CNanoProtonPlugin.c` (derleme komutları dosyaların başında)
- Belgeler, örnekler, lisans: `01_...\docs`, `examples`, `LICENSE.txt`, `README.md`
- Yayınlanan paket: `CNanoKit_v1.1_03102026_1845.zip` → C:\Tarim\paylasim_01102026_1900\ (ve GitHub yayın klasörü)

## Dış araçlar (arşivde YOK, internetten aynı sürüm alınır)
| Araç | Sürüm | Ne için |
|---|---|---|
| MinGW-w64 (i686-w64-mingw32-gcc) | GCC 13-win32 | 3 .exe'yi derlemek |
| Windows PowerShell | 5.1 | .ps1 çalıştırmak |
| Python 64-bit | 3.14.7 | pymcuprog |
| Microchip pymcuprog | 3.19.4.61 | kit programlama |
| Microchip PIC18F-Q_DFP | 1.31.492 | cihaz betikleri |
| Positron8 / Positron Studio / Proton IDE / VS Code + atomix.positron | 4.0.6.4 / 2.1.0.4 / 2.0.3.3 / 1.140 + 2.9.0 | IDE testleri |

## Derleme (exe)
```
i686-w64-mingw32-gcc -O2 -s -o CNanoProg.exe CNanoProg.c
i686-w64-mingw32-gcc -O2 -s -mwindows -DGUI -DSCRIPT=\"CNanoMonitor.ps1\" -o CNanoMonitor.exe CNanoProg.c
CNanoProtonPlugin.exe: komut src\CNanoProtonPlugin.c başlığında
```
Not: aynı derleyici sürümü bile bayt-bayt aynı .exe vermeyebilir (zaman damgası); işlev aynıdır.

## v1.1 dosyalarının SHA256 değerleri (doğrulama için)
```
e229c34739184f36a01eb175f8493edf45a6b09c291e27d56321e6400b51e868  CNanoProg.exe
32cad694bbfebe485d00a13f8e428b38ba3c7fba46f2791dd8f8bd0b7acd39e3  CNanoMonitor.exe
6511c27d35a41af788f2d830c941106ccb46f17e78652e781afba76449d58aa3  CNanoProtonPlugin.exe
c7f2f6e3686546232e59e8d66140674384c88e195af2f9136aef4dbcb7fe6eb0  CNanoProg.ps1
dccacd00f2c9bad3edfa5954e615683989ae172dc7ea6b5685630ee0026f4fbf  CNanoMonitor.ps1
13f3527bb443201800f22aae4b4ec1d473488f0a180d242331b12ae217bedccd  CNanoProg_Setup.ps1
6d5ee38c9b92d910be398a144427326945ffabdee506092e1f8bafce404a1c08  CNanoProg_Setup.bat
57eba20d95bc89a39c188e44fc422e620cf9e546d42088179636626c4c8f9187  examples/CNANO_HELLO_56Q71.bas
a2029634ae65b4cf7f1e8e40aac55ce2666fbe17020938ecef63869ac1e6e702  examples/CNANO_HELLO_56Q71_NOLED.bas
b6dbbce793f6e5ec3080465a47f8fdddecac5c0163f5b959e5c413b78a5983cf  examples/CNANO_KOMUT_56Q71.bas
4390535acf00ade3ca93be29d929f05bbbcec1c3a684d6ff1a1e27cd8ff8dbca  CNanoKit_v1.1_03102026_1845.zip
```

## Eksik kalan (dürüstçe)
- MinGW ve Python kurulum dosyaları arşivde değil (internetten).
- Bulut çalışma alanındaki geçici kopyalar arşivde değil; gerek yok — buradaki dosyalar en güncel hâl.
