import serial

def main():
    ser = serial.Serial('COM7', 9600)
    while True:
        bytes_to_read = ser.inWaiting()
        data = ser.read(bytes_to_read)
        print(data)

if __name__ == '__main__':
    main()
