//implementation based on https://github.com/lohanidamodar/flutter_calendar
//and https://pub.dev/packages/flutter_datetime_picker

import 'package:calendar/support/widgetView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddCalendar extends StatefulWidget {
  static const routeName = '/addEvent';

  @override
  _AddCalendarController createState() => _AddCalendarController();
}

class _AddCalendarController extends State<AddCalendar> {
  @override
  Widget build(BuildContext context) => _AddCalendarView(this);

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var _user;
  bool processing;

  final _firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: "");
    processing = false;
    _user = _firebaseAuth.currentUser.uid;
  }

  void handleButtonPressed() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        processing = true;
      });

      try {
        await createCalendar();
        Navigator.pop(context);
      } on Exception {
        Alert(context: context, title: "", desc: "Could not create event.")
            .show();
      } finally {
        setState(() {
          processing = false;
        });
      }
    }
  }

  Future createCalendar() async {
    _firestoreInstance.collection("calendar").add({
      "Naziv": _title.text,
      "user_id": _user,
    });
  }
}

class _AddCalendarView extends WidgetView<AddCalendar, _AddCalendarController> {
  _AddCalendarView(_AddCalendarController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj kalendar"),
      ),
      key: state._key,
      body: Form(
        key: state._formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              _buildTitleBox(context),
              const SizedBox(height: 10.0),
              state.processing
                  ? Center(child: CircularProgressIndicator())
                  : _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: state._title,
        validator: (value) => (value.isEmpty) ? "Unesite naziv" : null,
        style: state.style,
        decoration: InputDecoration(
            labelText: "Naziv kalendara",
            filled: true
      ),
    ));
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Material(
        child: RaisedButton(
          onPressed: () {
            state.handleButtonPressed();
          },
          child: Text(
            "Spremi"
          ),
        ),
      ),
    );
  }
}
