# okmn PRIVATE bench test for JonW's mwboot "R" (read) command - NOT for distribution.
# Spec used: JonW's MWBOOT_PIC.html, "Commands" table:
#   R addr 00  ->  K + 256 data bytes + CRC(2)   (LEN must be 0, flash address even;
#   reply CRC-16/CCITT-FALSE starts at 0xFFFF and covers K + data; anything may be read)
# Earlier failure (reentry_test.py) used LEN = 8 -> the device correctly answered "L".
#
# usage: python mwtest_read_02102026_1235.py COM8 app.hex boot.hex
# Kit: both wires fitted (RC6->RB4, RB5->RC7), app already uploaded through the bootloader.
import serial, sys, time, glob, os, subprocess, threading, binascii
PORT, APP, BOOT = sys.argv[1], sys.argv[2], sys.argv[3]
SLOT, FLASH, PAGE = 0xFCF8, 0x10000, 256
here = os.path.dirname(os.path.abspath(__file__))
stamp = time.strftime('%d%m%Y_%H%M')
logf = open(os.path.join(here, 'log', 'R_test_%s.txt' % stamp), 'w')
def say(*a):
    t = ' '.join(str(x) for x in a); print(t); logf.write(t + '\n'); logf.flush()
def crc(b, c=0xFFFF): return binascii.crc_hqx(b, c)
def load(fn):
    m, base = {}, 0
    for ln in open(fn):
        ln = ln.strip()
        if not ln.startswith(':'): continue
        d = bytes.fromhex(ln[1:]); n, a, t = d[0], (d[1] << 8) | d[2], d[3]
        if t == 0:
            for i in range(n): m[base + a + i] = d[4 + i]
        elif t == 4: base = ((d[4] << 8) | d[5]) << 16
    return m
def frame(cmd, addr, ln=0, data=b''):
    f = bytes([ord(cmd), (addr >> 16) & 0xFF, (addr >> 8) & 0xFF, addr & 0xFF, ln & 0xFF]) + data
    c = crc(f); return f + bytes([c >> 8, c & 0xFF])
# ---- expected memory = what the bootloader must hold after the upload
app, boot = load(APP), load(BOOT)
exp = {a: v for a, v in boot.items() if a < FLASH}
for a, v in app.items():
    if a < 8: exp[SLOT + a] = v
    if 4 <= a < FLASH: exp[a] = v
for a, v in zip(range(4), (0x80, 0xEF, 0x7E, 0xF0)): exp[a] = v     # vector forced by the device
eep = {a: v for a, v in app.items() if 0x380000 <= a < 0x380100}
cfg = {a: v for a, v in boot.items() if 0x300000 <= a < 0x300100}
# ---- pymcuprog (kit debugger) for reset and independent read-back
packs = sorted(glob.glob(os.path.expanduser(r'~\.mchp_packs\Microchip\PIC18F-Q_DFP\*\scripts\pic18f56q71')))
PM = ['pymcuprog', '-t', 'nedbg', '-d', 'pic18f56q71', '-p', packs[-1]] if packs else None
def pm(*args):
    r = subprocess.run([PM[0]] + list(args) + PM[1:], capture_output=True, text=True)
    return r.returncode, r.stdout + r.stderr
fails = 0
def check(name, ok, info=''):
    global fails
    if not ok: fails += 1
    say(('PASS ' if ok else 'FAIL ') + name + ('  ' + info if info else ''))
say('=== mwboot R test', time.strftime('%d.%m.%Y %H:%M:%S'), 'port', PORT)
say('app', APP); say('boot', BOOT)
# ---- 1) enter the bootloader: U every 20 ms while the debugger resets the PIC (sync window 100 ms)
s = serial.Serial(); s.port = PORT; s.baudrate = 115200; s.timeout = 0.02; s.dtr = True; s.rts = False
s.open(); time.sleep(0.3); s.reset_input_buffer()
got, stop = bytearray(), threading.Event()
def spam():
    while not stop.is_set():
        s.write(b'U'); time.sleep(0.02)
th = threading.Thread(target=spam); th.start()
if PM: pm('reset')
t0 = time.time()
while time.time() - t0 < 5 and b'B' not in got: got += s.read(64)
stop.set(); th.join(); time.sleep(0.1); s.reset_input_buffer()
check('1 sync after reset (U -> B)', b'B' in got)
if b'B' not in got: say('STOP: no sync - check both wires and that the monitor is closed'); sys.exit(1)
s.timeout = 2
def rx(n):
    b = s.read(n)
    return b
def rd(addr):
    s.write(frame('R', addr)); r = rx(1 + 256 + 2)
    if len(r) != 259 or r[0:1] != b'K': return None, r[:1]
    if crc(r) != 0: return None, b'crc'      # zero trick over K + data + CRC
    return r[1:257], b'K'
# ---- 2) INFO
s.write(frame('I', 0)); r = rx(31)
ok = len(r) == 31 and r[0:1] == b'K' and r[1:4] == b'MWB' and crc(r) == 0
check('2 I info (K, "MWB", CRC)', ok, r.hex(' ') if r else '')
if ok:
    check('2b feature bit0 = R supported', bool(r[6] & 1), 'features 0x%02X' % r[6])
    check('2c DEVID 0x7760', r[28] | (r[29] << 8) == 0x7760, 'devid 0x%04X' % (r[28] | (r[29] << 8)))
# ---- 3) whole flash, 256 pages, compared byte by byte (bootloader area included)
t1 = time.time(); bad = []; dump = {}
for p in range(0, FLASH, PAGE):
    d, st = rd(p)
    if d is None: bad.append('0x%05X:%s' % (p, st)); continue
    for i in range(PAGE):
        dump[p + i] = d[i]
        if d[i] != exp.get(p + i, 0xFF): bad.append('0x%05X' % (p + i)); break
check('3 R whole flash 64 KB == expected image', not bad, ('%.1f s' % (time.time() - t1)) + ('  first diffs ' + ' '.join(bad[:8]) if bad else ''))
# ---- 4) EEPROM and config (byte-wide areas)
d, st = rd(0x380000)
check('4 R EEPROM 0x380000 first bytes == app EDATA', d is not None and all(d[a - 0x380000] == v for a, v in eep.items()),
      (d[:16].hex(' ') if d else str(st)))
d, st = rd(0x300000)
say('INFO R config 0x300000: ' + (d[:16].hex(' ') if d else str(st)) + '   (hex file: ' + ' '.join('%02x' % cfg[a] for a in sorted(cfg)) + ')')
# ---- 5) the device must refuse bad frames
s.write(frame('R', 0x000001)); check('5a odd flash address -> L', rx(1) == b'L')
s.write(frame('R', 0x000000, 1)); r = rx(1); check('5b LEN 1 -> L (no data sent)', r == b'L', repr(r))
f = bytearray(frame('R', 0)); f[-1] ^= 0xFF; s.write(f); check('5c damaged CRC -> C', rx(1) == b'C')
s.write(frame('Z', 0)); check('5d unknown command -> ?', rx(1) == b'?')
d, st = rd(0x0100); check('5e R still works after the refusals', d is not None)
# ---- 6) leave the bootloader, the app must start
s.write(frame('X', 0)); check('6 X -> K (app starts: RD0 fast blink)', rx(1) == b'K')
s.close()
# ---- 7) independent cross-check with the kit debugger
if PM:
    out = os.path.join(here, 'log', 'R_test_debugger_%s.hex' % stamp)
    rc, txt = pm('read', '-m', 'flash', '-o', '0', '-b', str(FLASH), '-f', out)
    if rc == 0 and os.path.exists(out):
        dbg = load(out)
        diff = [a for a in range(FLASH) if dbg.get(a, 0xFF) != dump.get(a, -1)]
        check('7 bootloader R data == debugger read-back', not diff, ('first diff 0x%05X' % diff[0]) if diff else '')
    else:
        say('SKIP 7 debugger read failed: ' + txt.strip().splitlines()[-1] if txt.strip() else 'SKIP 7')
    pm('reset')
say('=== RESULT:', 'ALL PASS' if fails == 0 else '%d FAIL' % fails)
logf.close(); sys.exit(1 if fails else 0)
