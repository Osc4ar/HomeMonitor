import serial, sys, binascii

commands = ['']

def to_hex(data):
    hexdata = data.hex()
    formatted = ''
    i = 0
    for b in hexdata:
        if i % 2 == 0:
            formatted += str(b)
        else:
            formatted += str(b) + ' '
        i += 1
    return formatted

def main():
    ser = serial.Serial('/dev/ttyUSB0', 38400)
    img = open('./image.jpeg', 'wb')
    text = open('./text.txt', 'w')
    img_started = False
    while True:
        bytes_to_read = ser.inWaiting()
        data = ser.read(bytes_to_read)
        if data:
            hexdata = to_hex(data)
            print(hexdata)
            if 'ff d8' in hexdata:
                img_started = True
                begin = hexdata.index('ff d8')
                filedata = hexdata[begin:].replace(' ', '')
                img.write(binascii.a2b_hex(filedata))
                text.write(filedata)
            if img_started:
                if 'ff d9' in hexdata:
                    end = hexdata.index('ff d9')
                    filedata = hexdata[:end+5].replace(' ', '')
                    img.write(binascii.a2b_hex(filedata))
                    text.write(filedata)
                    img.close()
                    text.close()
                    sys.exit([1])
                else:
                    filedata = hexdata.replace(' ', '')
                    text.write(filedata)
                    img.write(binascii.a2b_hex(filedata))

if __name__ == '__main__':
    main()
