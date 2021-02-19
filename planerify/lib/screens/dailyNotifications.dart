import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:planerify/support/constants.dart';

class AddNotification extends StatefulWidget {
  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State {
  TextEditingController textEditingController = TextEditingController();
  FlutterLocalNotificationsPlugin fltrNotification;
  String _selectedParam;
  String task;
  int val;

  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('logo');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future _showNotification() async {
    //print(textEditingController.text);
    var time1 = textEditingController.text.split(":");
    var time = Time(int.parse(time1[0]), int.parse(time1[1]));
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Planerify", "This is my channel",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    await fltrNotification.showDailyAtTime(0, "Planerify",
        "Unesi tjelesnu temperaturu", time, generalNotificationDetails);
  }

  Future notificationSelected(String payload) async {
    /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { return EditTemperature();}
        )); */
  }

  Future<void> cancelNotification() async {
    await fltrNotification.cancel(0);
  }

  final format = DateFormat("HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodavanje obavijesti'),
        actions: <Widget>[_buildPopupMenu(context)],
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              DateTimeField(
                controller: textEditingController,
                format: DateFormat('HH:mm'),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.convert(time);
                },
                decoration: InputDecoration(
                  labelText: 'Vrijeme',
                  border: InputBorder.none,
                ),
              ),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: _showNotification,
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text('Dodaj obavijest'),
                  )),
            ],
          )),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Delete) {
      cancelNotification();
    }
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return Constants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: ListTile(title: Text(choice)),
          );
        }).toList();
      },
    );
  }
}
