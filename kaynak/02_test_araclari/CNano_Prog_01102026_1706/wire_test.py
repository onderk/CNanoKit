import serial, time
s = serial.Serial(); s.port = 'COM8'; s.baudrate = 115200; s.timeout = 0.1; s.dtr = True
s.open(); time.sleep(0.3); s.reset_input_buffer()
s.write(b'?'); time.sleep(0.4); print(s.read(500).decode('latin-1'))
s.write(b'w'); t = time.time()
while time.time() - t < 0.4: s.write(b'\x00' * 64); time.sleep(0.004)
time.sleep(0.4); print(s.read(500).decode('latin-1'))
s.write(b'w'); time.sleep(0.5); print('idle (no data):', s.read(500).decode('latin-1'))
s.close()
