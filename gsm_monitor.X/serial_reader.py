import serial, time, sys, binascii, datetime
import images

def create_packet(bytes):
    packet = bytearray()
    for byte in bytes:
        packet.append(byte)
    return packet

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

def to_list(hexdata):
    data_list = hexdata.split(' ')
    return data_list

def command_get_jpg(beginH, beginL):
    return create_packet([0x56, 0x00, 0x32, 0x0C, 0x00, 0x0A, 0x00, 0x00, beginH, beginL, 0x00, 0x00, 0x10, 0x00, 0x00, 0x0A])
    
def main():
    ser = serial.Serial('/dev/ttyUSB0', 38400)
    time.sleep(5)
    ser.write(create_packet([0x56, 0x00, 0x26, 0x00]))
    time.sleep(3)
    beginH = 0
    beginL = 0
    i = 0
    filename = 'image.jpeg'
    while True:
        bytes_to_read = ser.inWaiting()
        data = ser.read(bytes_to_read)
        if data:
            print(to_hex(data))
            if i == 0:
                print('\tTake picture')
                ser.write(create_packet([0x56, 0x00, 0x36, 0x01, 0x00]))
                time.sleep(3)
            elif i == 1:
                print('\tPicture size')
                ser.write(create_packet([0x56, 0x00, 0x34, 0x01, 0x00]))
                time.sleep(3)
            elif i >= 2:
                hexdata = to_hex(data)
                if i == 2:
                    dim = hexdata.split(' ')[-3:-1]
                    sz = int(dim[0] + dim[1], 16)
                    print(f'\tTamaño imagen: {sz}')
                # Verificando imagen
                elif i == 3:
                    filename = str(datetime.datetime.now()).replace(' ', '_') + '.jpeg'
                    img = open(filename, 'wb')
                    text = open('./text.txt', 'w')
                    begin = hexdata.index('ff d8')
                    filedata = hexdata[begin:].replace(' ', '')
                    img.write(binascii.a2b_hex(filedata))
                    text.write(filedata)
                elif i >= 4:
                    if 'ff d9' in hexdata:
                        state = 0
                        end = hexdata.index('ff d9')
                        filedata = hexdata[:end+5].replace(' ', '')
                        img.write(binascii.a2b_hex(filedata))
                        text.write(filedata)
                        img.close()
                        images.upload_file(filename)
                        sys.exit([1])
                    else:
                        filedata = hexdata.replace(' ', '')
                        text.write(filedata)
                        img.write(binascii.a2b_hex(filedata))
                # Solicitando mas datos
                begin = 0x1000*(i-2)
                if begin != 0:
                    beginH = int(hex(begin)[:4], 16)
                    beginL = int(hex(begin)[4:], 16)
                    print(f'\tbegin: [{hex(beginH)}, {hex(beginL)}]')
                    ser.write(command_get_jpg(beginH, beginL))
                else:
                    ser.write(command_get_jpg(0x00, 0x00))
                time.sleep(3)
            i += 1

if __name__ == '__main__':
    main()
