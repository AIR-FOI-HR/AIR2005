import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planerify/models/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/support/styles.dart';


TextEditingController nazivController = TextEditingController();
TextEditingController sadrzajController = TextEditingController();

class AddNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    nazivController.clear();
    sadrzajController.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj bilješku"),
      ),
      /*body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Naziv'
          ),
            controller: nazivController,
        ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Sadržaj bilješke'
            ),
             controller: sadrzajController,
        ),

        ],
      ),*/
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewNote(context);
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.lightBlue,
      ),

    );
  }
}


addNewNote(BuildContext context) {
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
      controller: nazivController,
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
      controller: sadrzajController,
      style: kNoteTextLargeLight,
      decoration: const InputDecoration.collapsed(hintText: 'Sadržaj'),
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
    ),
  ],
);





