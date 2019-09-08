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
                  color: Colors.grey[900],
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.network('https://placeimg.com/640/480/any',
                            height: 150,
                            fit: BoxFit.fill),
                      ),
                      Text(devices[index]),
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
