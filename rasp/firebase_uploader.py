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

def upload_file(upload_info):
  filename = upload_info['filename']
  uid = upload_info['uid']
  firebase = initialize()
  storage = firebase.storage()
  myfile = open(filename, "rb")
  bytesm  = myfile.read()
  fbupload = storage.child("/" + uid + '/' + myfile.name).put(bytesm)
  upload_info['url'] = storage.child("/" + uid + '/' + myfile.name).get_url(fbupload['downloadTokens'])
  upload(firebase, upload_info)

def upload(firebase, upload_info):
  uid = upload_info['uid']
  db = firebase.database()
  data = {
    "deviceId" : upload_info['deviceId'],
    "photoURL": upload_info['url'],
    "timestamp" : upload_info['timestamp'],
  }
  results = db.child("messages/" + uid).push(data)
  print(f'Informacion subida con ID: {results}')
