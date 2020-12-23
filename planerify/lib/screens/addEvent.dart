//implementation based on https://github.com/lohanidamodar/flutter_calendar
//and https://pub.dev/packages/flutter_datetime_picker

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:planerify/models/event.dart';
import 'package:planerify/res/eventFirestoreService.dart';
import 'package:planerify/support/widgetView.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddEventPage extends StatefulWidget {

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
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(text:  widget.note != null ? widget.note.description : "");
    _eventDate = DateTime.now();
    processing = false;
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
      "eventDate": _eventDate};
    await eventDBS.create(newEvent);
  }

  Future updateEvent() async {
     await eventDBS.updateData(widget.note.id,{
      "title": _title.text,
      "description": _description.text,
      "event_date": widget.note.eventDate
    });
  }
}

class _AddEventPageView extends WidgetView<AddEventPage, _AddEventPageController> {
  _AddEventPageView(_AddEventPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? "Izmjeni bilješku" : "Dodaj bilješku"),
        backgroundColor: Colors.cyan,
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
        (value.isEmpty) ? "Unesite naziv" : null,
        style: state.style,
        decoration: InputDecoration(
            labelText: "Naziv događaja",
            filled: true,
            fillColor: Colors.white,
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
        (value.isEmpty) ? "Unesite opis događaja" : null,
        style: state.style,
        decoration: InputDecoration(
            labelText: "Opis događaja",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildDateChooser(BuildContext context)
  {
    return ListTile(
      title: Text("Datum (YYYY-MM-DD)"),
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
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.cyan,
        child: MaterialButton(
          //logika
          onPressed: () {state.handleButtonPressed();},
          child: Text(
            "Spremi",
            style: state.style.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


