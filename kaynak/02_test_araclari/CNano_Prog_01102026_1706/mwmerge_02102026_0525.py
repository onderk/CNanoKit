# okmn private helper - NOT for distribution.
# Builds "bootloader + app" in one hex for the PIC18F56Q71 kit, the same image
# that was read back after a real mwboot upload (log/EXPECTED_UART_MERGED.hex):
#   - flash = bootloader image, app placed on top (app must stay below 0xFCF8)
#   - app bytes 0..7 are copied to 0xFCF8..0xFCFF (the bootloader jumps there)
#   - bytes 0..3 keep the bootloader's GOTO, bytes 4..7 keep the app's own
#   - config = bootloader's; EEPROM (0x380000) = app's
# usage: python mwmerge_02102026_0525.py app.hex boot.hex out.hex
import sys
BOOT_TOP = 0xFCF8
def load(fn):
    mem, base = {}, 0
    for ln in open(fn):
        ln = ln.strip()
        if not ln.startswith(':'): continue
        d = bytes.fromhex(ln[1:]); n, a, t = d[0], (d[1] << 8) | d[2], d[3]
        if (sum(d) & 0xFF) != 0: raise SystemExit('checksum error in ' + fn)
        if t == 0:
            for i in range(n): mem[base + a + i] = d[4 + i]
        elif t == 4: base = ((d[4] << 8) | d[5]) << 16
        elif t == 1: break
    return mem
def save(mem, fn):
    out, cur = [], None
    addrs = sorted(mem); i = 0
    while i < len(addrs):
        a = addrs[i]; up = a >> 16
        if up != cur:
            r = bytes([2, 0, 0, 4, up >> 8, up & 0xFF]); out.append(r); cur = up
        blk = [mem[a]]; j = i + 1
        while j < len(addrs) and addrs[j] == a + len(blk) and len(blk) < 16 and (addrs[j] >> 16) == up and ((addrs[j] & 0xF) != 0 or len(blk) == 0):
            blk.append(mem[addrs[j]]); j += 1
        out.append(bytes([len(blk), (a >> 8) & 0xFF, a & 0xFF, 0]) + bytes(blk)); i = j
    with open(fn, 'w', newline='\r\n') as f:
        for r in out: f.write(':' + (r + bytes([(-sum(r)) & 0xFF])).hex().upper() + '\n')
        f.write(':00000001FF\n')
def merge(app, boot):
    m = dict(boot)
    for a, v in app.items():
        if a < 0x300000:
            if a >= BOOT_TOP: raise SystemExit('app too big: 0x%06X is inside the bootloader' % a)
            if a < 8: m[BOOT_TOP + a] = v
            if a >= 4: m[a] = v
        elif 0x380000 <= a < 0x380100:
            m[a] = v
        elif 0x300000 <= a < 0x300100 and boot.get(a) is not None and boot[a] != v:
            print('note: app config 0x%06X differs, bootloader value kept' % a)
    return m
if __name__ == '__main__':
    if len(sys.argv) != 4: raise SystemExit(__doc__ or 'usage: app.hex boot.hex out.hex')
    m = merge(load(sys.argv[1]), load(sys.argv[2])); save(m, sys.argv[3])
    print('merged ->', sys.argv[3], len(m), 'bytes')
