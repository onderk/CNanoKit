# private bench test for CNANO_KOMUT_56Q71 - sends the same bytes CNano Monitor sends
import serial, time, sys
s = serial.Serial(); s.port = 'COM8'; s.baudrate = 115200; s.timeout = 0.05; s.dtr = True
s.open(); time.sleep(0.3)
t0 = time.time()
def rd(sec):
    end = time.time() + sec; buf = b''
    while time.time() < end:
        buf += s.read(512)
    for line in buf.decode('latin-1').splitlines():
        if line.strip(): print('%7.3f  < %s' % (time.time() - t0, line))
def send(b, label):
    print('%7.3f  > %s  %s' % (time.time() - t0, label, b.hex(' ').upper())); s.write(b)
rd(0.5)
send(b'help\r\n', 'help (Metin CR+LF)'); rd(0.6)
send(b'okmn\r\n', 'okmn (Metin CR+LF)'); rd(2.8)
send(bytes([0x53]), 'HEX 53'); rd(2.8)
send(b'come\r\n', 'come (Metin CR+LF)'); rd(5.6)
send(b'OKMN', 'OKMN (Metin, satir sonu Yok)'); rd(0.5)
send(b'come\r\n', 'come'); rd(1.2)
send(b'stop\r\n', 'stop (come yarida kesilir)'); rd(0.6)
send(b'xyz\r\n', 'xyz (bilinmeyen)'); rd(0.6)
s.close()
