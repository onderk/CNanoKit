/* CNanoProtonPlugin.exe - Proton IDE plugin for CNanoProg.
   Proton IDE's own "Program" button does not start an external programmer on
   Windows 11 test PCs, so this plugin (Proton IDE > Plugin menu) does the job:
     1. connects to the IDE through its plugin manager (mcPluginMgr.dll)
     2. asks for the current page (file, hex file, device)
     3. compiles first if the page is modified or the hex is missing/older
     4. starts CNanoProg.exe (same folder) in its own window
   Argument "monitor" starts the serial monitor window (CNanoMonitor.exe) instead.
   No argument (double-clicked in Explorer): shows how to use it and exits.
   Plugin API: Proton IDE Plugin Manager help (PluginMgr.chm, cPluginInterface.pas).
   Freeware licence (LICENSE.txt).  okmn 2026.  Build: i686-w64-mingw32-gcc -O2 -s -mwindows */
#include <windows.h>
#include <stdio.h>
#include <string.h>

typedef struct {                 /* cPluginTypes.pas TPageInfo */
    char DisplayName[64];
    char Filename[256];
    char FilenameMCI[256];
    char FilenameASM[256];
    char FilenameHEX[256];
    BOOL Modified;
    char Device[16];
    UINT DeviceCore;
    UINT OSC;
    BOOL VersionEnabled;
    BYTE VersionMajor, VersionMinor, VersionRelease, VersionBuild;
    UINT PageSize;
    UINT PageSizeRTF;
} PAGEINFO;

typedef BOOL (WINAPI *fConnect)(HWND);
typedef BOOL (WINAPI *fDisconnect)(void);
typedef void (WINAPI *fGetPage)(LPSTR, UINT);
typedef BOOL (WINAPI *fGetPageInfo)(LPSTR, PAGEINFO *);
typedef BOOL (WINAPI *fExecuteCompile)(void);
typedef void (WINAPI *fSetForegroundWindow)(void);

static int tr = 0;   /* 1 = Turkish UI */

static void msg(const char *en, const char *trk, UINT icon)
{
    MessageBoxA(NULL, tr ? trk : en, "CNanoProg - Proton IDE", MB_OK | icon | MB_TOPMOST);
}

static BOOL older(const char *a, const char *b)       /* file a older than file b ? */
{
    WIN32_FILE_ATTRIBUTE_DATA fa, fb;
    if (!GetFileAttributesExA(a, GetFileExInfoStandard, &fa)) return TRUE;   /* a missing */
    if (!GetFileAttributesExA(b, GetFileExInfoStandard, &fb)) return FALSE;
    return CompareFileTime(&fa.ftLastWriteTime, &fb.ftLastWriteTime) < 0;
}

static LRESULT CALLBACK WndProc(HWND h, UINT m, WPARAM w, LPARAM l) { return DefWindowProcA(h, m, w, l); }

int WINAPI WinMain(HINSTANCE hi, HINSTANCE hp, LPSTR cmdline, int show)
{
    HMODULE dll;
    fConnect Connect; fDisconnect Disconnect; fGetPage GetPage; fGetPageInfo GetPageInfo;
    fExecuteCompile ExecuteCompile; fSetForegroundWindow SetFg;
    WNDCLASSA wc; HWND hwnd;
    char page[256], exe[MAX_PATH], dir[MAX_PATH], cmd[2048], *p;
    PAGEINFO info;
    int monitor = (cmdline && strstr(cmdline, "monitor") != NULL);
    /* Proton IDE always passes the button's parameter text ("program" / "monitor");
       an empty command line means the .exe was double-clicked in Explorer. */
    int program = 0;
    if (cmdline) { const char *c = cmdline; while (*c == ' ' || *c == '\t') c++; program = (*c != 0); }
    STARTUPINFOA si; PROCESS_INFORMATION pi;

    tr = (PRIMARYLANGID(GetUserDefaultUILanguage()) == LANG_TURKISH);
    if (cmdline && strstr(cmdline, "lang=en")) tr = 0;
    if (cmdline && strstr(cmdline, "lang=tr")) tr = 1;

    /* Double-clicked in Explorer (no "program"/"monitor" argument): this is not a stand-alone
       program, so explain how it is used instead of trying to talk to Proton IDE. */
    if (!monitor && !program) {
        msg("This is the Proton IDE plugin of CNanoKit - it does not run on its own.\n\n"
            "Use it inside Proton IDE:\n"
            "  1. Open Proton IDE and your .bas file (Device = ... must match the kit).\n"
            "  2. Press the toolbar button \"Program (CNanoProg)\" - it compiles if needed and programs the kit.\n"
            "  3. \"Monitor (CNanoMonitor)\" opens the serial monitor.\n"
            "The buttons are also in the Plugin menu, group \"Curiosity Nano\".\n"
            "No buttons? Close Proton IDE and run CNanoProg_Setup.bat once.",
            "Bu, CNanoKit'in Proton IDE eklentisidir - tek basina calismaz.\n\n"
            "Proton IDE icinde kullanilir:\n"
            "  1. Proton IDE'yi ve .bas dosyanizi acin (Device = ... kit ile ayni olmali).\n"
            "  2. Arac cubugundaki \"Program (CNanoProg)\" dugmesine basin - gerekirse derler, sonra kiti programlar.\n"
            "  3. \"Monitor (CNanoMonitor)\" seri monitoru acar.\n"
            "Dugmeler Plugin menusunde, \"Curiosity Nano\" grubunda da vardir.\n"
            "Dugme yoksa: Proton IDE'yi kapatin ve CNanoProg_Setup.bat'i bir kez calistirin.",
            MB_ICONINFORMATION);
        return 0;
    }

    GetModuleFileNameA(NULL, dir, MAX_PATH);
    p = strrchr(dir, '\\'); if (p) p[1] = 0;
    snprintf(exe, sizeof exe, "%sCNanoProg.exe", dir);
    if (GetFileAttributesA(exe) == INVALID_FILE_ATTRIBUTES) {
        msg("CNanoProg.exe must be in the same folder as this plugin.",
            "CNanoProg.exe bu eklentiyle ayni klasorde olmali.", MB_ICONERROR);
        return 1;
    }

    if (monitor) {
        snprintf(cmd, sizeof cmd, "\"%sCNanoMonitor.exe\"%s", dir, tr ? " -Lang tr" : " -Lang en");
    } else {
        dll = LoadLibraryA("mcPluginMgr.dll");
        if (!dll) { msg("mcPluginMgr.dll not found - is Proton IDE installed?",
                        "mcPluginMgr.dll bulunamadi - Proton IDE kurulu mu?", MB_ICONERROR); return 1; }
        Connect = (fConnect)GetProcAddress(dll, "Connect");
        Disconnect = (fDisconnect)GetProcAddress(dll, "Disconnect");
        GetPage = (fGetPage)GetProcAddress(dll, "GetPage");
        GetPageInfo = (fGetPageInfo)GetProcAddress(dll, "GetPageInfo");
        ExecuteCompile = (fExecuteCompile)GetProcAddress(dll, "ExecuteCompile");
        SetFg = (fSetForegroundWindow)GetProcAddress(dll, "SetForegroundWindow");
        if (!Connect || !GetPage || !GetPageInfo || !ExecuteCompile) {
            msg("Unexpected mcPluginMgr.dll version.", "Beklenmeyen mcPluginMgr.dll surumu.", MB_ICONERROR); return 1; }

        ZeroMemory(&wc, sizeof wc);
        wc.lpfnWndProc = WndProc; wc.hInstance = hi; wc.lpszClassName = "CNanoProtonPluginWnd";
        RegisterClassA(&wc);
        hwnd = CreateWindowA(wc.lpszClassName, "CNanoProg", 0, 0, 0, 0, 0, NULL, NULL, hi, NULL);
        if (!Connect(hwnd)) { msg("Cannot reach Proton IDE.\nIs Proton IDE open? Press the \"Program (CNanoProg)\" button inside Proton IDE (toolbar or Plugin menu).",
                                  "Proton IDE'ye ulasilamadi.\nProton IDE acik mi? Proton IDE icindeki \"Program (CNanoProg)\" dugmesine basin (arac cubugu veya Plugin menusu).", MB_ICONWARNING); return 1; }

        page[0] = 0; GetPage(page, sizeof page);
        ZeroMemory(&info, sizeof info);
        if (page[0] == 0 || !GetPageInfo(page, &info)) {
            Disconnect(); msg("No open source file in Proton IDE.", "Proton IDE'de acik kaynak dosya yok.", MB_ICONWARNING); return 1; }

        if (info.Modified || info.FilenameHEX[0] == 0 || older(info.FilenameHEX, info.Filename)) {
            if (!ExecuteCompile()) {
                if (SetFg) SetFg();
                Disconnect(); msg("Compile failed - see the Proton IDE Results window.",
                                  "Derleme basarisiz - Proton IDE Results penceresine bakin.", MB_ICONWARNING); return 1; }
            ZeroMemory(&info, sizeof info); GetPageInfo(page, &info);
        }
        if (info.FilenameHEX[0] == 0) { Disconnect(); msg("No hex file - compile first.", "Hex dosyasi yok - once derleyin.", MB_ICONWARNING); return 1; }
        snprintf(cmd, sizeof cmd, "\"%s\" \"%s\" %s%s", exe, info.FilenameHEX, info.Device, tr ? " -Lang tr" : " -Lang en");
        Disconnect();
    }

    ZeroMemory(&si, sizeof si); si.cb = sizeof si;
    if (!CreateProcessA(NULL, cmd, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, dir, &si, &pi)) {
        msg("Cannot start CNanoProg.exe.", "CNanoProg.exe baslatilamadi.", MB_ICONERROR); return 1; }
    CloseHandle(pi.hThread); CloseHandle(pi.hProcess);
    return 0;
}
