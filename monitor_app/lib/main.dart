import 'package:flutter/material.dart';
import 'device_screen.dart';
import 'register_screen.dart';
import 'message_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Monitor',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: {
        RegisterScreen.routeName: (context) => RegisterScreen(),
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

  List<String> _titles = <String>['Mensajes', 'Dispositivos', 'Cuenta'];

  List<Widget> _sections = <Widget>[
    MessageScreen(),
    DeviceScreen(),
    Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Cuenta',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
    ),
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
        )
      ];
    } else if (sectionId == 1) {
      return <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add_circle),
        )
      ];
    }
    return <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Cuenta'),
          ),
        ],
        currentIndex: _selectedSection,
        onTap: _onSectionSelected,
      ),
    );
  }
}
