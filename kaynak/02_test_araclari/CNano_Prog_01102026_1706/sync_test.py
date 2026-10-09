import serial, time, sys
for dtr in (True, False):
    s = serial.Serial()
    s.port = 'COM8'; s.baudrate = 115200; s.timeout = 0.02
    s.dtr = dtr; s.rts = False
    s.open()
    time.sleep(0.3)
    s.reset_input_buffer()
    got = b''
    t0 = time.time()
    while time.time() - t0 < 2.0:
        s.write(b'U')
        got += s.read(16)
        if b'B' in got: break
    print('DTR=%s received: %r' % (dtr, got[:60]))
    if b'B' in got:
        # ask INFO: frame 'I' + addr(3) + len(0) + CRC16-CCITT-FALSE over frame
        def crc(data, c=0xFFFF):
            for b in data:
                c ^= b << 8
                for _ in range(8):
                    c = ((c << 1) ^ 0x1021) & 0xFFFF if c & 0x8000 else (c << 1) & 0xFFFF
            return c
        f = b'I\x00\x00\x00\x00'; c = crc(f); f += bytes([c >> 8, c & 0xFF])
        s.reset_input_buffer(); s.write(f); time.sleep(0.3)
        r = s.read(200); print('INFO reply:', r.hex(' '))
    s.close()
    time.sleep(0.3)
