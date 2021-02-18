import 'package:calendar/support/widgetView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/calendar.dart';
import 'addCalendar.dart';
import 'calendarScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class Calendars extends StatefulWidget {
  @override
  _CalendarController createState() => _CalendarController();
}

class _CalendarController extends State<Calendars> {
  @override
  Widget build(BuildContext context) => _NotesView(this);
}

class _NotesView extends WidgetView<Calendars, _CalendarController> {
  _NotesView(_CalendarController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendars').tr(),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCalendar()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var user = _firebaseAuth.currentUser.uid;
    //database
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('calendar').where(
          "user_id", isEqualTo: user).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItem(context, data))
            .toList(),
      );
    }
    else {
      return Center(
          child: Text("Nema kalendara, unesite novi kalendar")
      );
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final cal = Calendar.fromSnapshot(data);
    return Padding(
        key: ValueKey(cal.id),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(cal.nazivKalendara),
            onTap: () =>
            {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarView(kalendarId: cal.id,)
              ),
            ),



            },
          ),
        )

    );
  }
}






