//implementation based on https://github.com/lohanidamodar/flutter_calendar
//and https://pub.dev/packages/flutter_datetime_picker

import 'package:calendar/models/event.dart';
import 'package:calendar/res/eventFirestoreService.dart';
import 'package:calendar/support/widgetView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_localization/easy_localization.dart';

class AddEventPage extends StatefulWidget {
  static const routeName = '/addEvent';

  final EventModel note;

  const AddEventPage({Key key, this.note}) : super(key: key);

  @override
  _AddEventPageController createState() => _AddEventPageController();
}

class _AddEventPageController extends State<AddEventPage> {
  @override
  Widget build(BuildContext context) => _AddEventPageView(this);

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var _user;
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(text:  widget.note != null ? widget.note.description : "");
    _eventDate = DateTime.now();
    processing = false;
    _user = _firebaseAuth.currentUser.uid;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void handleDatePicker() async{
    DateTime pickedDateTime = await DatePicker.showDateTimePicker(context,
    showTitleActions: true,
    minTime: DateTime(_eventDate.year-5),
    maxTime: DateTime(_eventDate.year+5),
    currentTime: DateTime.now(),
    locale: LocaleType.en);
    if(pickedDateTime != null) {
      setState(() {
        _eventDate = pickedDateTime;
       }
      );
    }
  }

  void handleButtonPressed() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        processing = true;
      });
      if(widget.note != null) {
        await updateEvent();
      }
      else {
        try {
          await createEvent();
          Navigator.pop(context);
        }
         on Exception{
               Alert(context: context, title: "", desc: "Could not create event.").show();
        }
        finally{
          setState(() {
            processing = false;
          });
        }
      }
    }
  }

  Future createEvent() async {
    Map<String,dynamic> newEvent = {
      "title": _title.text,
      "description": _description.text,
      "eventDate": _eventDate,
      "user_id": _user
    };
    await eventDBS.create(newEvent);
  }

  Future updateEvent() async {
     await eventDBS.updateData(widget.note.id,{
      "title": _title.text,
      "description": _description.text,
      "event_date": widget.note.eventDate,
       "user_id": _user
    });
  }
}

class _AddEventPageView extends WidgetView<AddEventPage, _AddEventPageController> {
  _AddEventPageView(_AddEventPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? "editNote".tr() : "addNote".tr()),
      ),
      key: state._key,
      body: Form(
        key: state._formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              _buildTitleBox(context),
              _buildContentBox(context),
              const SizedBox(height: 10.0),
              _buildDateChooser(context),
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

  Widget _buildTitleBox(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: state._title,
        validator: (value) =>
        (value.isEmpty) ? "enterName".tr() : null,
        style: state.style,
        decoration: InputDecoration(
            labelText: "eventName".tr(),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildContentBox(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: state._description,
        minLines: 3,
        maxLines: 5,
        validator: (value) =>
        (value.isEmpty) ? "enterEventDescription".tr() : null,
        style: state.style,
        decoration: InputDecoration(
            labelText: "eventDescription".tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildDateChooser(BuildContext context)
  {
    return ListTile(
      title: Text("date".tr() + "(YYYY-MM-DD)"),
      subtitle: Text("${state._eventDate.year} - ${state._eventDate.month} - ${state._eventDate.day} ${state._eventDate.hour}: ${state._eventDate.minute}"),
      onTap:() {
        state.handleDatePicker();
      },
    );
  }

  Widget _buildSaveButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        child: RaisedButton(
          onPressed: () {state.handleButtonPressed();},
          child: Text(
            "save".tr()
          ),
        ),
      ),
    );
  }
}


