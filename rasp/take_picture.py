from datetime import datetime
import time
import picamera
import firebase_uploader

def take_picture():
  now = datetime.now()
  ts = int(now.timestamp)
  filename = f'{ts}.jpg'
  with picamera.PiCamera() as picam:
    picam.resolution = (1280, 720)
    picam.start_preview()
    time.sleep(3)
    picam.capture(filename)
    picam.stop_preview()
    picam.close()
  firebase_uploader.upload_file(filename, ts)

if __name__ == "__main__":
  take_picture()