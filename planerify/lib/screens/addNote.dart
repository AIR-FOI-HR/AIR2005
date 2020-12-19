import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:planerify/models/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/support/styles.dart';
import 'package:planerify/support/widgetView.dart';





class AddNote extends StatefulWidget {
  @override
  _AddNoteController createState() => _AddNoteController();
}

class _AddNoteController extends State<AddNote> {

  @override
  Widget build(BuildContext context) => _AddNoteView(this);

  TextEditingController nazivController= TextEditingController();
  TextEditingController sadrzajController = TextEditingController();

  @override
  void initState(){
    nazivController.clear();
    sadrzajController.clear();
    super.initState();
  }
  void handleAddPressed(){
    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("note-01").add(
        {
          "Naziv": nazivController.text,
          "Sadržaj": sadrzajController.text
        }).then((value){
      print(value.id);
    });
    Navigator.pop(context);
    nazivController.clear();
    sadrzajController.clear();
  }
}

class _AddNoteView extends WidgetView<AddNote, _AddNoteController> {
  _AddNoteView(_AddNoteController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj bilješku"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          state.handleAddPressed();
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.lightBlue,
      ),

    );
  }

  Widget _buildBody(BuildContext context){
   return DefaultTextStyle(
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
  }

  Widget _buildNoteDetail() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      TextField(
        controller: state.nazivController,
        style: kNoteTitleLight,
        decoration: const InputDecoration(
          hintText: 'Naziv',
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
        decoration: const InputDecoration.collapsed(hintText: 'Sadržaj'),
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
      ),
    ],
  );
}



