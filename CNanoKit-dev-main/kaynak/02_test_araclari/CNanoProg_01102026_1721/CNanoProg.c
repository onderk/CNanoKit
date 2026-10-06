/* CNanoProg.exe - starts CNanoProg.ps1 (same folder) with Windows PowerShell.
   Exists because IDE programmer dialogs want an .exe.

   Arguments are passed through.  One fix-up: some IDEs store the programmer
   parameter string in a way that breaks on quotes, so the IDE line can be
       $long-hex-filename$ $target-device$          (no quotes)
   and a hex path with spaces still works: everything up to the last ".hex"
   is taken as the file name and handed to the script as -Hex "<path>".

   Free to use (MIT licence, see LICENSE.txt).  No warranty.  01 Oct 2026. */
#include <windows.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* the raw command line after argv[0], quotes kept exactly as the IDE sent them */
static const char *args_after_exe(const char *cl)
{
    if (*cl == '"') { cl++; while (*cl && *cl != '"') cl++; if (*cl) cl++; }
    else { while (*cl && *cl != ' ' && *cl != '\t') cl++; }
    while (*cl == ' ' || *cl == '\t') cl++;
    return cl;
}

/* index just past the last ".hex" that ends a word, or -1 */
static int end_of_hex_name(const char *s)
{
    int n = (int)strlen(s), i, best = -1;
    for (i = 0; i + 4 <= n; i++) {
        if (s[i] == '.' && tolower((unsigned char)s[i + 1]) == 'h' &&
            tolower((unsigned char)s[i + 2]) == 'e' && tolower((unsigned char)s[i + 3]) == 'x' &&
            (s[i + 4] == 0 || s[i + 4] == ' ' || s[i + 4] == '\t'))
            best = i + 4;
    }
    return best;
}

int main(void)
{
    char exe[MAX_PATH], ps1[MAX_PATH], *slash;
    static char cmd[32768], hex[8192];
    const char *raw;
    int e;
    STARTUPINFOA si; PROCESS_INFORMATION pi; DWORD rc = 1;

    GetModuleFileNameA(NULL, exe, MAX_PATH);
    strcpy(ps1, exe);
    slash = strrchr(ps1, '\\');
    if (slash) slash[1] = 0; else ps1[0] = 0;
    strcat(ps1, "CNanoProg.ps1");
    if (GetFileAttributesA(ps1) == INVALID_FILE_ATTRIBUTES) {
        fprintf(stderr, "CNanoProg: %s not found\n", ps1);
        return 1;
    }

    raw = args_after_exe(GetCommandLineA());
    {   /* trace: what the IDE really sent (log\launcher.log next to the exe) */
        char lp[MAX_PATH]; FILE *f; SYSTEMTIME st;
        strcpy(lp, ps1); slash = strrchr(lp, '\\'); if (slash) strcpy(slash + 1, "log\\launcher.log");
        f = fopen(lp, "a");
        if (f) { GetLocalTime(&st); fprintf(f, "%02d.%02d.%04d %02d:%02d:%02d  cwd-args: %s\n", st.wDay, st.wMonth, st.wYear, st.wHour, st.wMinute, st.wSecond, GetCommandLineA()); fclose(f); }
    }
    e = (*raw != '"' && *raw != '-') ? end_of_hex_name(raw) : -1;
    if (e > 0 && e < (int)sizeof hex) {
        memcpy(hex, raw, e); hex[e] = 0;
        _snprintf(cmd, sizeof cmd - 1,
                  "powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File \"%s\" -Hex \"%s\" %s",
                  ps1, hex, raw + e);
    } else {
        _snprintf(cmd, sizeof cmd - 1,
                  "powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File \"%s\" %s",
                  ps1, raw);
    }
    ZeroMemory(&si, sizeof si); si.cb = sizeof si;
    if (!CreateProcessA(NULL, cmd, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
        fprintf(stderr, "CNanoProg: cannot start PowerShell (error %lu)\n", GetLastError());
        return 1;
    }
    WaitForSingleObject(pi.hProcess, INFINITE);
    GetExitCodeProcess(pi.hProcess, &rc);
    CloseHandle(pi.hProcess); CloseHandle(pi.hThread);
    return (int)rc;
}
