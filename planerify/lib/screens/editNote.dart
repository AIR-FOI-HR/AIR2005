import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/note.dart';
import 'package:planerify/support/constants.dart';
import 'package:planerify/support/styles.dart';
import 'package:planerify/support/widgetView.dart';

TextEditingController nazivController = TextEditingController();
TextEditingController sadrzajController = TextEditingController();

class EditNote extends StatefulWidget {
  static const routeName = '/editNote';
  @override
  final Note editingNote;

  EditNote({Key key, @required this.editingNote}) : super(key: key);

  _EditNoteController createState() => _EditNoteController(editingNote);
}

class _EditNoteController extends State<EditNote> {
  Note editingNote;

  _EditNoteController(this.editingNote);

  @override
  Widget build(BuildContext context) => _EditNoteView(this);

  TextEditingController nazivController = TextEditingController();
  TextEditingController sadrzajController = TextEditingController();
  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var _user;

  @override
  void initState() {
    super.initState();
    print("editingNote");
    if (editingNote != null) {
      nazivController.text = editingNote.nazivBiljeske;
      sadrzajController.text = editingNote.sadrzajBiljeske;
    } else {
      nazivController.clear();
      sadrzajController.clear();
    }
    _user = _firebaseAuth.currentUser.uid;
  }

  void choiceAction(String choice) {
    if (choice == Constants.Delete) {
      final firestoreInstance = FirebaseFirestore.instance;
      firestoreInstance
          .collection("notes")
          .doc(editingNote.id)
          .delete()
          .then((_) {
        print("success!");
      });
      Navigator.pop(context);
    }
  }

  void handleButtonPressed() {
    if (editingNote != null) {
      _firestoreInstance.collection("notes").doc(editingNote.id).set({
        "Sadržaj": sadrzajController.text,
        "Naziv": nazivController.text,
        "user_id": _user
      }, SetOptions(merge: true));
    } else {
      _firestoreInstance.collection("notes").add({
        "Naziv": nazivController.text,
        "Sadržaj": sadrzajController.text,
        "user_id": _user,
      }).then((value) {});
    }
    Navigator.pop(context);
  }
}

class _EditNoteView extends WidgetView<EditNote, _EditNoteController> {
  _EditNoteView(_EditNoteController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: state.editingNote == null
            ? Text("addNote").tr()
            : Text("editNote").tr(),
        actions: <Widget>[_buildPopupMenu(context)],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          state.handleButtonPressed();
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    if (state.editingNote != null) {
      return PopupMenuButton<String>(
        onSelected: state.choiceAction,
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
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
            controller: state.nazivController,
            style: kNoteTitleLight,
            decoration: new InputDecoration(
              hintText: 'name'.tr(),
              border: InputBorder.none,
              counter: const SizedBox(),
            ),
            maxLines: null,
            maxLength: 1024,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: state.sadrzajController,
            style: kNoteTextLargeLight,
            decoration: new InputDecoration.collapsed(hintText: 'title'.tr()),
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      );
}
