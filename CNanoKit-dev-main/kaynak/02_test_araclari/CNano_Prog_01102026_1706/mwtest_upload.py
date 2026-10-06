# PRIVATE bench test client for JonW's mwboot protocol (not FREELOADER, not for distribution).
# Purpose: prove the P56Q71_MWBOOT bootloader writes an app correctly on a real PIC18F56Q71
# through the Curiosity Nano CDC port, which needs DTR asserted (FREELOADER 1.1 releases DTR).
import serial, time, sys
PORT, HEX = sys.argv[1], sys.argv[2]
SLOT, BOOT, PAGE = 0xFCF8, 0xFD00, 256

def crc16(data, c=0xFFFF):
    for b in data:
        c ^= b << 8
        for _ in range(8):
            c = ((c << 1) ^ 0x1021) & 0xFFFF if c & 0x8000 else (c << 1) & 0xFFFF
    return c

def load(p):
    m = {}; base = 0
    for ln in open(p):
        ln = ln.strip()
        if not ln.startswith(':'): continue
        b = bytes.fromhex(ln[1:]); n = b[0]; a = (b[1] << 8) | b[2]; t = b[3]
        if t == 0:
            for i in range(n): m[base + a + i] = b[4 + i]
        elif t == 4: base = ((b[4] << 8) | b[5]) << 16
    return m

def frame(cmd, addr, data=b'', ln=None):
    if ln is None: ln = len(data) & 0xFF
    f = bytes([ord(cmd), (addr >> 16) & 0xFF, (addr >> 8) & 0xFF, addr & 0xFF, ln]) + data
    c = crc16(f); return f + bytes([c >> 8, c & 0xFF])

m = load(HEX)
flash = {a: v for a, v in m.items() if a < 0x200000}
ee = {a: v for a, v in m.items() if 0x380000 <= a < 0x380100}
assert max(flash) < SLOT, 'app too big'
first8 = bytes(flash.get(i, 0xFF) for i in range(8))
img = dict(flash)
for i in range(8): img[SLOT + i] = first8[i]
img[0], img[1], img[2], img[3] = 0x80, 0xEF, 0x7E, 0xF0      # GOTO 0xFD00 (device forces it too)
pages = sorted({a & ~(PAGE - 1) for a in img})
slotpage = SLOT & ~(PAGE - 1)
order = [p for p in pages if p != slotpage] + [slotpage]

s = serial.Serial(); s.port = PORT; s.baudrate = 115200; s.timeout = 0.5; s.dtr = True; s.rts = False
s.open(); time.sleep(0.3); s.reset_input_buffer()
t0 = time.time(); got = b''
s.timeout = 0.02
while time.time() - t0 < 10 and b'B' not in got:
    s.write(b'U'); got += s.read(8)
print('sync:', got[-8:]); assert b'B' in got
time.sleep(0.05); s.reset_input_buffer(); s.timeout = 2
for p in order:
    data = bytes(img.get(p + i, 0xFF) for i in range(PAGE))
    s.write(frame('W', p, data, 0)); r = s.read(1)
    print('W page 0x%05X -> %r' % (p, r)); assert r == b'K'
if ee:
    lo = min(ee); hi = max(ee)
    data = bytes(ee.get(a, 0xFF) for a in range(lo, hi + 1))
    s.write(frame('W', lo, data)); r = s.read(1)
    print('W eeprom 0x%06X len %d -> %r' % (lo, len(data), r)); assert r == b'K'
s.write(frame('X', 0)); r = s.read(1); print('X ->', r)
s.close()
print('UPLOAD OK in %.2f s' % (time.time() - t0))
