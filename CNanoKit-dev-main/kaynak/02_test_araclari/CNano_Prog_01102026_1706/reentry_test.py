import serial, time, subprocess, threading, os
PK = os.path.expandvars(r'%USERPROFILE%\.mchp_packs\Microchip\PIC18F-Q_DFP\1.31.492\scripts\pic18f56q71')
s = serial.Serial(); s.port = 'COM8'; s.baudrate = 115200; s.timeout = 0.02; s.dtr = True
s.open(); time.sleep(0.3)
pre = s.read(200); print('before reset (app running):', pre[-40:])
th = threading.Thread(target=lambda: subprocess.run(['pymcuprog','reset','-t','nedbg','-d','pic18f56q71','-p',PK], capture_output=True))
th.start(); got = b''; t0 = time.time()
while time.time() - t0 < 12 and b'B' not in got:
    s.write(b'U'); got += s.read(8)
th.join()
print('after reset sync:', b'B' in got, '%.1f s' % (time.time() - t0))
def crc16(d, c=0xFFFF):
    for b in d:
        c ^= b << 8
        for _ in range(8): c = ((c << 1) ^ 0x1021) & 0xFFFF if c & 0x8000 else (c << 1) & 0xFFFF
    return c
def fr(cmd, a, ln=0):
    f = bytes([ord(cmd), (a>>16)&255, (a>>8)&255, a&255, ln]); c = crc16(f); return f + bytes([c>>8, c&255])
time.sleep(0.05); s.reset_input_buffer(); s.timeout = 1
s.write(fr('I', 0)); r = s.read(31); print('I ->', r[:1], 'devid %02x%02x' % (r[28], r[27]) if len(r) == 31 else r, 'crc ok' if len(r)==31 and crc16(r)==0 else 'crc?')
s.write(fr('R', 0x380000, 8)); r = s.read(1+8+2); print('R eeprom ->', r)
s.write(fr('X', 0)); print('X ->', s.read(1))
time.sleep(1.5); print('app again:', s.read(100))
s.close()
