import RPi.GPIO as GPIO

import time
import picamera

def setup_input_pin(pin, callback):
  GPIO.setmode(GPIO.BCM)
  GPIO.setup(pin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
  GPIO.add_event_detect(pin, GPIO.BOTH)
  GPIO.add_event_callback(pin, callback)

def take_picture():
  with picamera.PiCamera() as picam:
    picam.resolution = (2592, 1944)
    picam.start_preview()
    time.sleep(3)
    picam.capture('pic.jpg', resize=(1024, 768))
    picam.stop_preview()
    picam.close()