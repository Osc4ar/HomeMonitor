import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Monitor',
      theme: ThemeData(
<<<<<<< HEAD
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        primaryColor: Colors.black,
        accentColor: Colors.white,
=======
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        primaryColor: Colors.white,
        accentColor: Colors.black,
>>>>>>> fc5827c8115732eebe2b7243c35c04e749adbbf9
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Home Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

<<<<<<< HEAD
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Tab> deviceTabs = <Tab>[
    Tab(
      text: 'Oficina',
    ),
    Tab(
      text: 'Casa',
    ),
  ];

  String dropdownValue = 'One';

  TabController _tabController;

=======
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  List<Tab> deviceTabs = <Tab>[
    Tab(text: 'Oficina',),
    Tab(text: 'Casa',),
  ];

  TabController _tabController;

>>>>>>> fc5827c8115732eebe2b7243c35c04e749adbbf9
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: deviceTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
<<<<<<< HEAD
      ),
      body: Center(
        child: Text(
          'Content',
          style: TextStyle(fontSize: 36),
        ),
      ),
=======
        bottom: TabBar(
          controller: _tabController,
          tabs: deviceTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: deviceTabs.map((Tab tab) {
          final String label = tab.text.toLowerCase();
          return Center(
            child: Text(
              'This is the $label tab',
              style: TextStyle(fontSize: 36),
            ),
          );
        }).toList(),
      ),
>>>>>>> fc5827c8115732eebe2b7243c35c04e749adbbf9
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.black,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    'email@gmail.com',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '2 dispositivos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Dispositivos'),
              leading: Icon(Icons.devices),
              onTap: () {},
            ),
            ListTile(
              title: Text('Añadir dispostivo'),
              leading: Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
              title: Text('Cerrar sesión'),
              leading: Icon(Icons.cloud_off),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Tomar fotografía',
        child: Icon(Icons.camera_alt),
<<<<<<< HEAD
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.black,
          height: 55,
          child: DropdownButtonHideUnderline(
            child: Row(
          children: <Widget>[
            Container(
              width: 340,
              margin: EdgeInsets.all(10),
              child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['One', 'Two', 'Three', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
          ),
        ),
      ),
=======
      ), // This trailing comma makes auto-formatting nicer for build methods.
>>>>>>> fc5827c8115732eebe2b7243c35c04e749adbbf9
    );
  }
}
