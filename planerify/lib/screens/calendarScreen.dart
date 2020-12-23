//implementation was based on project found on https://github.com/lohanidamodar/flutter_calendar

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/event.dart';
import 'package:planerify/screens/viewEvent.dart';
import 'package:planerify/support/widgetView.dart';
import 'package:table_calendar/table_calendar.dart';

import 'addEvent.dart';


class Calendar extends StatefulWidget {
  @override
  _CalendarController createState() => _CalendarController();
}

class _CalendarController extends State<Calendar> {
  @override
  Widget build(BuildContext context) => _CalendarView(this);

  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;


  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  //funkcija za grupiranje događaja po datumu
  //Ulaz: Lista svih događaja
  //Izlaz: Mapa čiji je ključ određeni datum, a vrijednost je lista događaja vezana za taj datum
  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day,12);
      if(data[date] == null)
        data[date] = [];
      print(event);
      data[date].add(event);
    });
    return data;
  }
}

class _CalendarView extends WidgetView<Calendar, _CalendarController> {
  _CalendarView(_CalendarController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planerify Calendar',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: _calendarPage(context),
    );
  }

  Widget _calendarPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planer"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("events").snapshots(),
          builder:_buildContent,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEventPage()));
        },
      ),
    );
  }


  Widget _buildContent(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
  {
      if(snapshot.hasData){
        List<EventModel> allEvents = [];
        snapshot.data.docs.forEach((element) => allEvents.add(EventModel.fromDS(element.id,element.data())));
        if(allEvents.isNotEmpty){
          state._events = state._groupEvents(allEvents);
        }
        else {
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
          trailing: Text('${TimeOfDay.fromDateTime(event.eventDate).format(context)} '),
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
      calendarController: state._calendarController,
      events: state._events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.red[400],
        todayColor: Colors.red[200],
        markersColor: Colors.black87,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonShowsNext: false,
        formatButtonTextStyle:
        TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: (day, events, holidays){
        // ignore: invalid_use_of_protected_member
        state.setState(() {
          state._selectedEvents = events;
        });
      },
    );
  }
}






