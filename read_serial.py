import serial
import time

def main():
    ser = serial.Serial('/dev/ttyUSB0', 9600)
    for i in range(20):
        ser.write(b'Hola\n')
        time.sleep(1)
        ser.write(b'Mundo\n')
        time.sleep(1)

if __name__ == '__main__':
    main()
