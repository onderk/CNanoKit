import serial, time
s = serial.Serial(); s.port = 'COM8'; s.baudrate = 115200; s.timeout = 0.2; s.dtr = True
s.open(); time.sleep(0.3); s.reset_input_buffer()
s.write(b'Q71'); time.sleep(0.6)
print(s.read(400).decode('latin-1')); s.close()
