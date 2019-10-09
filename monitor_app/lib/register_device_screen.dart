import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class RegisterDeviceScreen extends StatefulWidget {
  static const routeName = '/registerDevice';
  @override
  _RegisterDeviceScreenState createState() => _RegisterDeviceScreenState();
}

class _RegisterDeviceScreenState extends State<RegisterDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  String phoneNo;
  String deviceName;
  String uid = '0IGpb0vjhbNhZLewS3yseIbP4gc2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Agregar dispositivo',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Nombre de dispositivo',
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        this.deviceName = value;
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Teléfono en el dipositivo',
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        phoneNo = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.width / 7,
                      child: RaisedButton.icon(
                        icon: Icon(Icons.add_circle),
                        color: Colors.cyan,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            SmsSender sender = SmsSender();
                            String address = '+525530444231';
                            SmsMessage message =
                                SmsMessage(address, 'Data:INIT:$deviceName&$uid&');
                            message.onStateChanged.listen((state) {
                              if (state == SmsMessageState.Sent) {
                                print("SMS is sent!");
                              } else if (state == SmsMessageState.Delivered) {
                                print("SMS is delivered!");
                              }
                            });
                            sender.sendSms(message);
                          }
                        },
                        label: Text(
                          'Agregar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
