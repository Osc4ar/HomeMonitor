from gpiozero import MotionSensor, Button
from signal import pause
import camera_serial

def motion_callback():
  print('Movimiento detectado')
  camera_serial.main()

def hall_callback():
  print('Efecto hall detectado')
  camera_serial.main()

if __name__ == '__main__':
  pir = MotionSensor(4)
  pir.when_motion = motion_callback
  hall = Button(17)
  hall.when_pressed = hall_callback
  pause()
