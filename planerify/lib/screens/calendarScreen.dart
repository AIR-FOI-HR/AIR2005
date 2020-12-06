//implementation was based on project found on https://github.com/lohanidamodar/flutter_calendar

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/event.dart';
import 'package:planerify/screens/view_event.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_event.dart';


//Izrada ekrana kalendara kao Stateless Widgeta
//Kao home mu se zadaje Stateful Widget CalendarPage
//Definira se ruta add_event koja vodi do ekrana za dodavanje novog događaja
class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planerify Calendar',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: CalendarPage(title: 'Planerify Calendar'),
      routes: {
        "add_event": (_) => AddEventPage(),
      }
      ,
    );
  }
}

//CalendarPage sadrži stanje koje se zove CreateState kojime se izrađuje cijeli kalendar
class CalendarPage extends StatefulWidget {
  CalendarPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _CalendarPageState createState() => _CalendarPageState();
}
//_CalendarPageState je stanje CalendarPage klase
//na početku se inicijaliziraju kontroler za kalendar, te mapa događaja koji se prikazuju te lista odabranih događaja
class _CalendarPageState extends State<CalendarPage> {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planer"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("events").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<EventModel> allEvents = [];
            snapshot.data.docs.forEach((element) => allEvents.add(EventModel.fromDS(element.id,element.data())));
            if(allEvents.isNotEmpty){
              _events = _groupEvents(allEvents);
            }
            else {
              _events = {};
              _selectedEvents = [];
            }
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTableCalendar(),
                Expanded(child: _buildEventList()),
              ],

          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'add_event'),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
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
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
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
        setState(() {
          _selectedEvents = events;
        });
      },
    );
  }
}


