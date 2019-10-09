from datetime import datetime
import os
import time
import picamera
import firebase_uploader

def take_picture(upload_info):
  start = time.time()
  now = datetime.now()
  ts = int(now.timestamp())
  filename = f'{ts}.jpg'
  with picamera.PiCamera() as picam:
    picam.resolution = (1280, 720)
    picam.start_preview()
    time.sleep(0.5)
    picam.capture(filename)
    picam.stop_preview()
    picam.close()
  print(f'Fotografia capturada en {time.time()-start} segundos\n')
  upload_info['filename'] = filename
  upload_info['timestamp'] = ts
  firebase_uploader.upload_file(upload_info)

if __name__ == "__main__":
    upload_info = {}
    user_file = open("user", "r")
    name_file = open("name", "r")
    upload_info['uid'] = user_file.read()
    upload_info['deviceId'] = name_file.read()
    user_file.close()
    name_file.close()

    while True:
      if os.path.exists('./take_picture'):
        take_picture(upload_info)
        os.remove('./take_picture')
      else:
        time.sleep(0.1)
