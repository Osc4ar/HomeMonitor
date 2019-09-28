import pyrebase

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

def upload_file(filename, ts):
  uid = '0IGpb0vjhbNhZLewS3yseIbP4gc2'
  firebase = initialize()
  storage = firebase.storage()
  myfile = open(filename, "rb")
  bytesm  = myfile.read()
  fbupload = storage.child("/" + uid + '/' + myfile.name).put(bytesm)
  url_image = storage.child("/" + uid + '/' + myfile.name).get_url(fbupload['downloadTokens'])
  upload_data(firebase, url_image, ts)

def upload_data(firebase, url_image, ts):
  uid = '0IGpb0vjhbNhZLewS3yseIbP4gc2'
  db = firebase.database()
  data = {
    "deviceId" : 'Casa',
    "photoURL": url_image,
    "timestamp" : ts,
  }
  results = db.child("messages/" + uid).push(data)
  print(results)
