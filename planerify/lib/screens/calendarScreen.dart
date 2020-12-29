import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Table Calendar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomePage> {
  CalendarController _controller;
  Map<DateTime, List<String>> _events = {};
  List<EventData> _allEvents = [];

  EventData _eventForEditing;
  DateTime _selectedDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }

  void _showEventEditDialog(BuildContext context) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy. H:mm');

    String name = '', description = '';
    DateTime eventDate = DateTime.now();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Uređivanje događaja'),
              content: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: _eventForEditing.title,
                      decoration: InputDecoration(
                          filled: true,labelText: 'Naziv'),
                      onSaved: (newValue) {
                        // print('Spremam $newValue');
                        name = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: _eventForEditing.description,
                      decoration: InputDecoration(
                          filled: true,labelText: 'Opis'),
                      onSaved: (newValue) {
                        // print('Spremam $newValue');
                        description = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DateTimeField(
                      format: formatter,
                      initialValue: _eventForEditing.eventDate.toDate(),
                      decoration: InputDecoration(
                        filled: true,
                          labelText: 'Datum i vrijeme',),
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
                        eventDate = newDate;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Odustani')),
                FlatButton(
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();

                      setState(() {
                        FirebaseFirestore.instance
                            .collection('events')
                            .doc(_eventForEditing.reference.id)
                            .update({
                          "title": name,
                          "eventDate": Timestamp.fromDate(eventDate),
                          "description": description
                        });
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Spremi'))
              ],
              FlatButton(
                onPressed: (){
                  setState((){
                    FirebaseFirestore.instance
                    .collection('events')
                    .doc(_eventForEditing.reference.id)
                    .delete();
                  });
                  Navigator.pop(content);
                },
                child: Text('Obriši')
              )
            ));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planer"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            _events.clear();
            for (var doc in snapshot.data.docs) {
              var eventData = doc.data();
              Timestamp timestamp = eventData["eventDate"];

              var date = DateTime.fromMillisecondsSinceEpoch(
                  timestamp.millisecondsSinceEpoch);
              var date2 = DateTime(date.year, date.month, date.day);
              var name = eventData["title"];

              if (!_events.containsKey(date2)) {
                _events[date2] = [];
              }

              _events[date2] = [..._events[date2], name];
              _allEvents.add(EventData.fromSnapshot(doc));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TableCalendar(
                      locale: 'en_US',
                      events: _events,
                      calendarStyle: CalendarStyle(
                        todayColor: Colors.cyan,
                        selectedColor: Colors.redAccent.shade200,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white),
                      ),
                      headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonTextStyle: TextStyle(color: Colors.white),
                          formatButtonDecoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(20.0)),
                          formatButtonShowsNext: false),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (day, events, holidays) {
                        setState(() {
                          // _selectedEvents = events;
                          _selectedDay = day;
                        });
                      },
                      // builders: CalendarBuilders(
                      //
                      //   selectedDayBuilder: (context, date, events) {
                      //     print(events);
                      //     print(date);
                      //     return ListView.builder(itemBuilder: (context, index) => ListTile(title: Text(events[index]),),);
                      //   }
                      // ),
                      calendarController: _controller),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var currentEvent =
                          EventData.fromSnapshot(snapshot.data.docs[index]);
                      final DateFormat formatter = DateFormat('H:mm');

                      var date = currentEvent.eventDate.toDate();

                      if (date.day == _selectedDay.day &&
                          date.month == _selectedDay.month &&
                          date.year == _selectedDay.year)
                        return ListTile(
                          title: Text(currentEvent.title),
                          subtitle: Text(formatter
                              .format(currentEvent.eventDate.toDate())),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _eventForEditing = currentEvent;
                              });
                              _showEventEditDialog(context);
                            },
                          ),
                        );

                      return Container();
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
