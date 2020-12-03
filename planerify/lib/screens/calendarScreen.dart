import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


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
  @override
  void initState() {
    // TODO: implement initState
      super.initState();
      _controller = CalendarController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planer"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              TableCalendar(
                locale: 'en_US',
                calendarStyle: CalendarStyle(
                  todayColor: Colors.cyan,
                  selectedColor: Colors.redAccent.shade200,
                  todayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white
                  ),
                ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonTextStyle: TextStyle(
                      color: Colors.white
                    ),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    formatButtonShowsNext: false
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (day, events, holidays){
                    print(day.toIso8601String());
                  },
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) =>
                        Container(
                          alignment: Alignment.center,
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              shape: BoxShape.circle
                            ),
                            child:Text(date.day.toString(),
                              style: TextStyle(
                                color: Colors.white
                              ),))
                  ),
                  calendarController: _controller)
          ],
        ),
      ),
    );
  }
}

