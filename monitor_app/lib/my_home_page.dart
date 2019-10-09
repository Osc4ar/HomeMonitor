import 'package:flutter/material.dart';
import 'device_screen.dart';
import 'message_screen.dart';
import 'register_device_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sms/sms.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  String uid;

  MyHomePage({Key key, this.uid}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedSection = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseApp _firebaseApp;

  List<String> _titles = <String>['Mensajes', 'Dispositivos'];

  void _onSectionSelected(int index) {
    setState(() {
      _selectedSection = index;
    });
  }

  Widget _getSelectedSection(int index) {
    switch (index) {
      case 0:
        return MessageScreen(
          firebaseApp: _firebaseApp,
          uid: widget.uid,
        );
        break;
      case 1:
        return DeviceScreen(
          firebaseApp: _firebaseApp,
          uid: widget.uid,
        );
        break;
      default:
        return MessageScreen(
          firebaseApp: _firebaseApp,
          uid: widget.uid,
        );
        break;
    }
  }

  List<Widget> _getSectionActions(int sectionId) {
    if (sectionId == 0) {
      return <Widget>[
        IconButton(
          onPressed: () {
            SmsSender sender = SmsSender();
            String address = '+525530444231';
            SmsMessage message = SmsMessage(address, 'Data:PHOTO');
            message.onStateChanged.listen((state) {
              if (state == SmsMessageState.Sent) {
                print("SMS is sent!");
              } else if (state == SmsMessageState.Delivered) {
                print("SMS is delivered!");
              }
            });
            sender.sendSms(message);
          },
          icon: Icon(Icons.camera_alt),
        ),
      ];
    } else if (sectionId == 1) {
      return <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, RegisterDeviceScreen.routeName);
          },
          icon: Icon(Icons.add_circle),
        )
      ];
    }
    return <Widget>[];
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  Future<void> initFirebase() async {
    _firebaseApp = await FirebaseApp.configure(
      name: 'AppTT',
      options: const FirebaseOptions(
        googleAppID: '1:421220765302:android:2db72c7eaa7fb828',
        apiKey: 'AIzaSyBcG1FA4LKArx8AXe60dZRY7gXCjaH1k24',
        databaseURL: 'https://apptt-2957a.firebaseio.com/',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.all(10),
          child: Text(
            _titles.elementAt(_selectedSection),
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        actions: _getSectionActions(_selectedSection),
      ),
      body: _getSelectedSection(_selectedSection),
      floatingActionButton: Visibility(
        visible: _selectedSection == 0,
        child: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            scaffoldKey.currentState.showBottomSheet((context) => Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Fecha'),
                    ],
                  ),
                ));
          },
          backgroundColor: Colors.white,
          tooltip: 'Capturar fotografía',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Mensajes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            title: Text('Dispositivos'),
          ),
        ],
        currentIndex: _selectedSection,
        onTap: _onSectionSelected,
      ),
    );
  }
}
