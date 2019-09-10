import 'package:flutter/material.dart';
import 'package:monitor_app/device_settings.dart';
import 'device_screen.dart';
import 'register_screen.dart';
import 'message_screen.dart';
import 'register_device_screen.dart';

void main() => runApp(MyApp());

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
      home: MyHomePage(),
      routes: {
        RegisterScreen.routeName: (context) => RegisterScreen(),
        RegisterDeviceScreen.routeName: (context) => RegisterDeviceScreen(),
        DeviceSettings.routeName: (context) => DeviceSettings(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedSection = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _titles = <String>['Mensajes', 'Dispositivos'];

  List<Widget> _sections = <Widget>[
    MessageScreen(),
    DeviceScreen(),
  ];

    void _onSectionSelected(int index) {
    setState(() {
      _selectedSection = index;
    });
  }

  List<Widget> _getSectionActions(int sectionId) {
    if (sectionId == 0) {
      return <Widget>[
        IconButton(
          onPressed: () {},
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.all(10),
          child: Text(
            _titles.elementAt(_selectedSection),
            style: TextStyle(
              fontSize: 28,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        actions: _getSectionActions(_selectedSection),
      ),
      body: _sections.elementAt(_selectedSection),
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
