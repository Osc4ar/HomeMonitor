import pyrebase
from datetime import datetime

"""
-| users
  -| userId
-| devices
  -| userId
    -| deviceId
-| messages
  -| userId
    -| messageId
"""

class User:
  def __init__(self, phone, mail):
    self.phone = phone
    self.mail = mail


class Device:
  def __init__(self, name, phone):
    self.name = name
    self.phone = phone

class Message:
  def __init__(self, deviceId, timestamp, photoURL):
    self.deviceId = deviceId
    self.timestamp = timestamp
    self.photoURL = photoURL


def initialize():
  config = {
    "apiKey": "AIzaSyBcG1FA4LKArx8AXe60dZRY7gXCjaH1k24",
    "authDomain": "apptt-2957a.firebaseapp.com",
    "databaseURL": "https://apptt-2957a.firebaseio.com",
    "projectId": "apptt-2957a",
    "storageBucket": "apptt-2957a.appspot.com",
    "messagingSenderId": "421220765302",
  }
  firebase = pyrebase.initialize_app(config)
  return firebase

def upload_file(filename):
  firebase = initialize()
  storage = firebase.storage()
  myfile = open(filename,"rb")
  bytesm  = myfile.read()
  fbupload = storage.child("/-Lpl3ZzOp-J5YDaHBHvx/"+myfile.name).put(bytesm)
  return storage.child("/"+myfile.name).get_url(fbupload['downloadTokens'])

def upload_data(firebase):
  db = firebase.database()
  now = datetime.datetime.now()
  fecha = str(now.day)+"/"+ str(now.month)+"/"+str(now.year)
  desc = "prueba TT1"
  data = {
    "URL": "'https://firebasestorage.googleapis.com/v0/b/apptt-2957a.appspot.com/o/D%3A%5CPictures%5Cinit.png?alt=media&token=4679f1ea-33bb-4f36-97ab-7663f8ba6580'",
    "Fecha" : fecha,
    "Descripcion" : desc,
  }
  results = db.child("TT/Fotos").push(data)
  print(results)

if __name__ == "__main__":
  upload_data('image.jpg')
