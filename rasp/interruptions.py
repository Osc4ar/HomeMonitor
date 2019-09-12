from gpiozero import MotionSensor, Button
from signal import pause

def motion_callback():
  print('Movimiento detectado')

def hall_callback():
  print('Efecto hall detectado')

pir = MotionSensor(4)
pir.when_motion = motion_callback

hall = Button(17)
hall.when_pressed = hall_callback

pause()
