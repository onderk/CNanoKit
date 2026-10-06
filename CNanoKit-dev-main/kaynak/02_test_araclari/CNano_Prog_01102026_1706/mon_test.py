import serial, time, sys
s = serial.Serial(); s.port = sys.argv[1]; s.baudrate = 115200; s.timeout = 0.2; s.dtr = True
s.open(); t0 = time.time(); buf = b''
while time.time() - t0 < float(sys.argv[2]): buf += s.read(256)
s.close(); print(buf.decode('latin-1'))
