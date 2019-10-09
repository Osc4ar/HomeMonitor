from datetime import datetime
import os
import time
import picamera
import firebase_uploader

def take_picture():
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
  firebase_uploader.upload_file(filename, ts)

if __name__ == "__main__":
    while True:
        if os.path.exists('./take_picture'):
            take_picture()
            os.remove('./take_picture')            
        else:
            time.sleep(0.1)
