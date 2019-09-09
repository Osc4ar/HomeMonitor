import 'package:flutter/material.dart';

class DeviceSettings extends StatefulWidget {
  static const routeName = '/deviceSettings';
  @override
  _DeviceSettingsState createState() => _DeviceSettingsState();
}

class _DeviceSettingsState extends State<DeviceSettings> {
  //final _formKey = GlobalKey<FormState>();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool enablemovementEvent = true;
  bool enableDoorEvent = true;

  Future<Null> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    TimeOfDay time = isStart ? _startTime : _endTime;
    if (picked != null && picked != time) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Configuración',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Notificarme',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'De ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FlatButton(
                          color: Colors.indigo,
                          onPressed: () => _selectTime(context, true),
                          child: Text(
                            '${_startTime.format(context)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Text(
                          ' a ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FlatButton(
                          color: Colors.indigo,
                          onPressed: () => _selectTime(context, false),
                          child: Text(
                            '${_endTime.format(context)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Enviar notificación cuando',
                      style: TextStyle(fontSize: 24),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: enableDoorEvent,
                          activeColor: Colors.indigo,
                          onChanged: (bool value) {
                            setState(() {
                              enableDoorEvent = value;
                            });
                          },
                        ),
                        Text(
                          ' se detecte movimiento',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: enablemovementEvent,
                          activeColor: Colors.indigo,
                          onChanged: (bool value) {
                            setState(() {
                              enablemovementEvent = value;
                            });
                          },
                        ),
                        Text(
                          ' se abre la puerta',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.width / 7,
                      margin: EdgeInsets.all(10.0),
                      child: RaisedButton.icon(
                        icon: Icon(Icons.save),
                        color: Colors.cyan,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () {},
                        label: Text(
                          'Guardar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.width / 7,
                      child: RaisedButton.icon(
                        icon: Icon(Icons.cancel),
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () {},
                        label: Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
