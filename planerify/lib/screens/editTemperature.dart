import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:planerify/models/temperature.dart';
import 'package:planerify/support/constants.dart';
import 'package:planerify/support/styles.dart';
import 'package:planerify/support/widgetView.dart';

TextEditingController sadrzajController = TextEditingController();

class EditTemperature extends StatefulWidget {
  static const routeName = '/editTemperature';
  @override
  final Temperatures editingTemperature;

  EditTemperature({Key key, @required this.editingTemperature})
      : super(key: key);

  _EditTemperatureController createState() =>
      _EditTemperatureController(editingTemperature);
}

class _EditTemperatureController extends State<EditTemperature> {
  Temperatures editingTemperature;

  _EditTemperatureController(this.editingTemperature);

  @override
  Widget build(BuildContext context) => _EditTemperatureView(this);

  TextEditingController sadrzajController = TextEditingController();
  TextEditingController datumController = TextEditingController();
  DateTime currentDateTime;
  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var _user;

  @override
  void initState() {
    super.initState();
    print("editingTemperature");
    if (editingTemperature != null) {
      sadrzajController.text = editingTemperature.sadrzajBiljeske;
      datumController.text = DateFormat('dd.MM.yyyy. H:mm').format(editingTemperature.datum ?? DateTime.now());
    } else {
      sadrzajController.clear();
      datumController.clear();
    }
    _user = _firebaseAuth.currentUser.uid;
  }

  void choiceAction(String choice) {
    if (choice == Constants.Delete) {
      final firestoreInstance = FirebaseFirestore.instance;
      firestoreInstance
          .collection("temperature-01")
          .doc(editingTemperature.id)
          .delete()
          .then((_) {
        print("success!");
      });
      Navigator.pop(context);
    }
  }

  //logika
  void handleButtonPressed() {
    DateTime parsedDate = datumController.text.isEmpty
        ? DateTime.now()
        : (DateFormat('dd.MM.yyyy. H:mm').parse(datumController.text) ??
            DateTime.now());

    if (editingTemperature != null) {
      _firestoreInstance
          .collection("temperature")
          .doc(editingTemperature.id)
          .set({
        "sadrzaj": sadrzajController.text,
        "user_id": _user,
        "datum": parsedDate.toIso8601String(),
      }, SetOptions(merge: true));
    } else {
      _firestoreInstance.collection("temperature").add({
        "sadrzaj": sadrzajController.text,
        "user_id": _user,
        "datum": parsedDate.toIso8601String(),
      }).then((value) {});
    }
    Navigator.pop(context);
  }
}

class _EditTemperatureView
    extends WidgetView<EditTemperature, _EditTemperatureController> {
  _EditTemperatureView(_EditTemperatureController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: state.editingTemperature == null
            ? Text("Dodaj bilješku")
            : Text("Izmjeni bilješku"),
        actions: <Widget>[_buildPopupMenu(context)],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          state.handleButtonPressed();
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    if (state.editingTemperature != null) {
      return PopupMenuButton<String>(
        onSelected: state.choiceAction,
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: ListTile(title: Text(choice)),
            );
          }).toList();
        },
      );
    }
    return IconButton(icon: new Icon(Icons.more_vert), onPressed: null);
  }

  Widget _buildBody(BuildContext context) => DefaultTextStyle(
        style: kNoteTextLargeLight,
        child: WillPopScope(
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: _buildNoteDetail(),
            ),
          ),
        ),
      );

  Widget _buildNoteDetail() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: state.sadrzajController,
            style: kNoteTitleLight,
            decoration: const InputDecoration(
              hintText: 'npr. 36,4',
              labelText: 'Temperatura',
              border: InputBorder.none,
              counter: const SizedBox(),
            ),
            maxLines: null,
            maxLength: 1024,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 14),
          DateTimeField(
            format: DateFormat('dd.MM.yyyy. H:mm'),
            style: kNoteTitleLight,
            initialValue: state.datumController.text.isEmpty ? DateTime.now() : DateFormat('dd.MM.yyyy. H:mm')
                    .parse(state.datumController.text) ??
                DateTime.now(),
            decoration: InputDecoration(
              labelText: 'Datum i vrijeme',
              border: InputBorder.none,
            ),
            controller: state.datumController,
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
          ),
        ],
      );
}
