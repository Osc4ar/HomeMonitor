import 'package:flutter/material.dart';
import 'device_settings.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class DeviceScreen extends StatefulWidget {
  final FirebaseApp firebaseApp;
  final String uid;

  DeviceScreen({this.firebaseApp, this.uid});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<Device> devices = List();
  Device device;
  DatabaseReference deviceRef;

  @override
  void initState() {
    super.initState();
    device = Device("", "");
    final FirebaseDatabase database = FirebaseDatabase(app: widget.firebaseApp);
    print('devices/${widget.uid}');
    deviceRef = database.reference().child('devices/${widget.uid}');
    deviceRef.onChildAdded.listen(_onEntryAdded);
    deviceRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      devices.insert(0, Device.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = devices.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      devices[devices.indexOf(old)] = Device.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FirebaseAnimatedList(
        query: deviceRef,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          print('device: $index');
          return Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            height: MediaQuery.of(context).size.height/10,
            child: RaisedButton.icon(
              icon: Icon(Icons.developer_board),
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
              onPressed: (){
                Navigator.pushNamed(context, DeviceSettings.routeName);
              },
              color: Colors.cyan[800],
              label: Text(
              devices[index].key,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            )
          );
        },
      ),
    );
  }
}

class Device {
  String key;
  String phone;

  Device(this.key, this.phone);

  Device.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      phone = snapshot.value['phone'];
}