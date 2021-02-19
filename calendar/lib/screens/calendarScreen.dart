//implementation was based on project found on https://github.com/lohanidamodar/flutter_calendar

import 'dart:io';

import 'package:calendar/models/calendar.dart';
import 'package:calendar/models/event.dart';
import 'package:calendar/screens/viewEvent.dart';
import 'package:calendar/support/widgetView.dart';
import 'package:calendar_importer/screens/importList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'addEvent.dart';

class CalendarView extends StatefulWidget {
  final String kalendarId;

  CalendarView({Key key, @required this.kalendarId}) : super(key: key);

  static const routeName = '/calendarScreen';

  @override
  _CalendarController createState() => _CalendarController(kalendarId);
}

class _CalendarController extends State<CalendarView> {
  final String calendarId;

  _CalendarController(this.calendarId);

  @override
  Widget build(BuildContext context) {
    print(calendarId);
    return _CalendarView(this, calendarId);
  }

  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime _selectedDate;
  EventModel _eventForEditing;
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  DateTime _eventDate;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var _user;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
    _selectedDate = DateTime.now();
    _name = "";
    _description = "";
    _eventDate = DateTime.now();
    _user = _firebaseAuth.currentUser.uid;
  }

  //funkcija za grupiranje događaja po datumu
  //Ulaz: Lista svih događaja
  //Izlaz: Mapa čiji je ključ određeni datum, a vrijednost je lista događaja vezana za taj datum
  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      //Dodat provjeru ako je idUsera na eventu jednak idKalendara
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      print(event);
      data[date].add(event);
    });
    return data;
  }

  void handleSavedButton() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      FirebaseFirestore.instance
          .collection('events')
          .doc(_eventForEditing.id)
          .update({
        "title": _name,
        "eventDate": Timestamp.fromDate(_eventDate),
        "description": _description
      });
    });
  }

  void handleDaySelected(List<dynamic> events, DateTime day) {
    setState(() {
      _selectedEvents = events;
      _selectedDate = day;
    });
  }

  void handleEventSelected(event) {
    setState(() {
      _eventForEditing = event;
      print(_eventForEditing.title);
    });
  }

  void handleDeleteButton() {
    setState(() {
      FirebaseFirestore.instance
          .collection('events')
          .doc(_eventForEditing.id)
          .delete();
    });
  }

  void handlePopupMenuChoice() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImportList(
                  calendarId: calendarId,
                )));
  }
}

class _CalendarView extends WidgetView<Calendar, _CalendarController> {
  final String calendarId;

  _CalendarView(_CalendarController state, this.calendarId) : super(state);

  Future<File> writeData(String data) async {
    final dir = await DownloadsPathProvider.downloadsDirectory;
    final file = File('${dir.path}/kalendar_dogadjaji.txt');

    if (await file.exists()) {
      await file.delete();
      await file.create();
    } else {
      file.create();
    }

    return file.writeAsString(data);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var user = _firebaseAuth.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("planner").tr(),
        actionsIconTheme:
            IconThemeData(size: 30.0, color: Colors.white, opacity: 10.0),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('calendar')
                  .doc(calendarId)
                  .delete();
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.transit_enterexit),
            onPressed: () {
              state.handlePopupMenuChoice();
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("events")
                .where("user_id", isEqualTo: state.calendarId)
                .snapshots(),
            builder: (context, snapshot) {
              //if (!snapshot.hasData)
              // return LinearProgressIndicator();
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  var allData = [];

                  for (var doc in snapshot.data.docs) {
                    EventModel data = EventModel.fromMap(doc.data());
                    DateTime date = data.eventDate;
                    allData.add(
                        '${date.day.toString().padLeft(2, ' ')}.${date.month.toString().padLeft(2, ' ')}.${date.year}. ${data.title}\n${data.description}\n');
                  }

                  var dataToSave = allData.join('\n');

                  writeData(dataToSave);

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Podaci spremljeni!')));
                },
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("events")
            .where("user_id", isEqualTo: state.calendarId)
            .snapshots(),
        builder: _buildContent,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red.shade400,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEventPage(
                        calendarId: calendarId,
                      )));
          _buildEventList(context);
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      List<EventModel> allEvents = [];
      snapshot.data.docs.forEach((element) =>
          allEvents.add(EventModel.fromDS(element.id, element.data())));
      if (allEvents.isNotEmpty) {
        state._events = state._groupEvents(allEvents);
      } else {
        state._events = {};
        state._selectedEvents = [];
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTableCalendar(context),
        Expanded(child: _buildEventList(context)),
      ],
    );
  }

  Widget _buildEventList(BuildContext context) {
    return ListView(
      children: state._selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.title),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12, // space between two icons
                    children: <Widget>[
                      Text(
                          '${TimeOfDay.fromDateTime(event.eventDate).format(context)} '),
                      IconButton(
                        icon: new Icon(Icons.edit),
                        onPressed: () {
                          state.handleEventSelected(event);
                          _showEventEditDialog(context);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                                  event: event,
                                )));
                  },
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTableCalendar(BuildContext context) {
    return TableCalendar(
        locale: context.locale.languageCode,
        calendarController: state._calendarController,
        events: state._events,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onDaySelected: (day, events, holidays) {
          state.handleDaySelected(events, day);
        });
  }

  void _showEventEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('editEvent').tr(),
              content: Form(
                key: state._formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleBox(context),
                    SizedBox(height: 10),
                    _buildDescriptionBox(context),
                    SizedBox(height: 10),
                    _buildDateTimePicker(context),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('cancel').tr()),
                FlatButton(
                    onPressed: () {
                      state.handleSavedButton();
                      Navigator.pop(context);
                    },
                    child: Text('save').tr()),
                FlatButton(
                    onPressed: () {
                      state.handleDeleteButton();

                      Navigator.pop(context);
                    },
                    child: Text("delete").tr())
              ],
            ));
  }

  Widget _buildTitleBox(BuildContext context) {
    print('titleBox start');
    return TextFormField(
      initialValue: state._eventForEditing.title,
      decoration: InputDecoration(filled: true, labelText: 'name'.tr()),
      onSaved: (newValue) {
        state._name = newValue;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'enterText'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionBox(BuildContext context) {
    return TextFormField(
      initialValue: state._eventForEditing.description,
      decoration: InputDecoration(filled: true, labelText: 'description'.tr()),
      onSaved: (newValue) {
        state._description = newValue;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'enterText'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return DateTimeField(
      format: DateFormat('dd.MM.yyyy. H:mm'),
      initialValue: state._eventForEditing.eventDate,
      decoration: InputDecoration(
        filled: true,
        labelText: 'dateAndTime',
      ),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 3650)),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
              currentValue ?? DateTime.now(),
            ),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
      onSaved: (newDate) {
        print('Spremam $newDate');
        state._eventDate = newDate;
      },
    );
  }
}
