import 'package:flutter/material.dart';

import 'package:monitor_app/device_settings.dart';
import 'register_screen.dart';
import 'register_device_screen.dart';
import 'my_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        primaryColor: Colors.indigo,
        accentColor: Colors.cyanAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
      routes: {
        RegisterScreen.routeName: (context) => RegisterScreen(),
        RegisterDeviceScreen.routeName: (context) => RegisterDeviceScreen(),
        DeviceSettings.routeName: (context) => DeviceSettings(),
        MyHomePage.routeName: (context) => MyHomePage(),
      },
    );
  } 
}
