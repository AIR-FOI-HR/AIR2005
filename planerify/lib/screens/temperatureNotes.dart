import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planerify/models/temperature.dart';
import 'package:planerify/support/widgetView.dart';
import 'editTemperature.dart';
import 'package:easy_localization/easy_localization.dart';

class Temperature extends StatefulWidget {
  @override
  _TemperatureController createState() => _TemperatureController();
}

class _TemperatureController extends State<Temperature> {
  @override
  Widget build(BuildContext context) => _TemperatureView(this);
}

class _TemperatureView extends WidgetView<Temperature, _TemperatureController> {
  _TemperatureView(_TemperatureController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('temperatureNotes').tr()
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addTemperatureNavigator(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var user = _firebaseAuth.currentUser.uid;
    //database
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('temperature').where("user_id", isEqualTo: user).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if(snapshot.isNotEmpty)
    {
      return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      );
    }
    else
    {
      return Center(
          child: Text("addTemperatureNote").tr()
      );
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final temperature = Temperatures.fromSnapshot(data);
    return Padding(
        key: ValueKey(temperature.id),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              leading: Icon(Icons.thermostat_rounded),
                title: Text('${temperature.sadrzajBiljeske} °C'),
                subtitle: temperature.datum == null ? Text('dateNotEntered').tr() : Text('${DateFormat("d.M.y. HH:mm").format(temperature.datum)}'),
                onTap: () => _addTemperatureNavigator(context, temperature))
        )
    );
  }

  _addTemperatureNavigator(BuildContext context, [Temperatures temperatures])
  {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditTemperature(editingTemperature: temperatures))
    );
  }
}