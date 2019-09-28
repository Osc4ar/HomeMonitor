import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MessageScreen extends StatefulWidget {
  final FirebaseApp firebaseApp;
  final String uid;

  MessageScreen({this.firebaseApp, this.uid});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Message> messages = List();
  Message message;
  DatabaseReference messageRef;

  @override
  void initState() {
    super.initState();
    message = Message("", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase(app: widget.firebaseApp);
    print('messages/${widget.uid}');
    messageRef = database.reference().child('messages/${widget.uid}');
    messageRef.onChildAdded.listen(_onEntryAdded);
    messageRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      messages.insert(0, Message.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = messages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      messages[messages.indexOf(old)] = Message.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FirebaseAnimatedList(
        query: messageRef,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          print('message: $index');
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
                        child: Image.network(messages[index].url,
                            height: 200, fit: BoxFit.fill),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              messages[index].deviceId,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              messages[index].date,
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
      ),
    );
  }
}

class Message {
  String key;
  String deviceId;
  String url;
  String date;

  Message(this.key, this.deviceId, this.date, this.url);

  Message.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      deviceId = snapshot.value["deviceId"],
      date = DateFormat('HH:mm d/MM').format(DateTime.fromMillisecondsSinceEpoch(snapshot.value["timestamp"]*1000)),
      url = snapshot.value["photoURL"];
}
