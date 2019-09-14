import pyrebase
import datetime

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
  fbupload = storage.child("/"+myfile.name).put(bytesm)
  img_url=storage.child("/"+myfile.name).get_url(fbupload['downloadTokens'])
  upload_data(firebase, img_url)

def upload_data(firebase, url_image):
  db = firebase.database()
  now = datetime.datetime.now()
  fecha = str(now.day)+"/"+ str(now.month)+"/"+str(now.year)
  desc = "prueba TT1"
  data = {
      "URL": url_image,
      "Fecha" : fecha,
      "Descripcion" : desc,
  }
  results = db.child("TT/Fotos").push(data)
  print(results)

if __name__ == "__main__":
    upload_file('image.jpg')
