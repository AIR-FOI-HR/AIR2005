import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planerify/models/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


TextEditingController nazivController = TextEditingController();
TextEditingController sadrzajController = TextEditingController();

class AddNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    nazivController.clear();
    sadrzajController.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body:
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewNote(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),

    );
  }
}

class EditNote extends StatelessWidget {
  static const routeName = '/editNote';
  @override
  Widget build(BuildContext context) {
    Note editingNote = ModalRoute.of(context).settings.arguments;
    nazivController.text = editingNote.nazivBiljeske;
    sadrzajController.text = editingNote.sadrzajBiljeske;
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body:
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewNote(context);
        },
        child: Icon(Icons.add),
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
