# private bench test: continuous commands + stop
import serial, time
s = serial.Serial(); s.port = 'COM8'; s.baudrate = 115200; s.timeout = 0.05; s.dtr = True
s.open(); time.sleep(0.3); t0 = time.time()
def rd(sec):
    end = time.time() + sec; buf = b''
    while time.time() < end: buf += s.read(512)
    lines = [l for l in buf.decode('latin-1').splitlines() if l.strip()]
    for l in lines: print('%7.3f  < %s' % (time.time() - t0, l))
def send(b, label):
    print('%7.3f  > %s  %s' % (time.time() - t0, label, b.hex(' ').upper())); s.write(b)
rd(0.4)
send(b'help\r\n', 'help'); rd(0.6)
send(b'okmn\r\n', 'okmn'); rd(2.5)
send(b'stop\r\n', 'stop'); rd(0.5)
send(bytes([0x53]), 'HEX 53'); rd(2.2)
send(b'stop\r\n', 'stop'); rd(0.5)
send(b'come\r\n', 'come'); rd(1.3)
send(b'okmn\r\n', 'okmn (come yerine)'); rd(0.6)
send(b'stop\r\n', 'stop'); rd(0.5)
s.close()
