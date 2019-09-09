import 'package:flutter/material.dart';
import 'device_settings.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<String> devices = [
    'Dispositivo 1',
    'Dispositivo 2',
    'Dispositivo 3',
    'Dispositivo 4',
    'Dispositivo 5'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView.separated(
        padding: EdgeInsets.all(10.0),
        itemCount: devices.length,
        itemBuilder: (BuildContext context, int index) {
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
              devices[index],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            )
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.black,
        ),
      ),
    );
  }
}
