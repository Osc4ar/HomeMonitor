import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<String> devices = [
    'Mensaje 1',
    'Mensaje 2',
    'Mensaje 3',
    'Mensaje 4',
    'Mensaje 5'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView.separated(
        padding: EdgeInsets.all(10.0),
        itemCount: devices.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Card(
              child: InkWell(
                onTap: () {
                  print('Card $index tapped.');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        child: Image.network('https://placeimg.com/640/480/any',
                            height: 150, fit: BoxFit.fill),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Dispositivo ${index+1}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '10:35 AM',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.black,
        ),
      ),
    );
  }
}
