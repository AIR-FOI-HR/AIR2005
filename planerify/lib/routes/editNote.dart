import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/note.dart';
import 'package:planerify/routes/addNote.dart';
import 'package:planerify/support/Constants.dart';

TextEditingController nazivController = TextEditingController();
TextEditingController sadrzajController = TextEditingController();

Note existingNote;
BuildContext currentContext;


class EditNote extends StatelessWidget {
  static const routeName = '/editNote';
  @override
  Widget build(BuildContext context) {
    Note editingNote = ModalRoute.of(context).settings.arguments;
    existingNote = editingNote;
    currentContext = context;
    nazivController.text = editingNote.nazivBiljeske;
    sadrzajController.text = editingNote.sadrzajBiljeske;
    return Scaffold(
      appBar: AppBar(
        title: Text("Uređivanje"),
        actions: <Widget>[
          PopupMenuButton<String>(
             onSelected: choiceAction,
            itemBuilder: (BuildContext context){
               return Constants.choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
               }).toList();
            },
          )
        ],
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                hintText: 'Naziv',
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                isDense: true,
            ),
            controller: nazivController,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Sadržaj bilješke',
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                isDense: true,

            ),
            controller: sadrzajController,
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onPressed();
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.lightBlue,
      ),

    );
  }
}

void choiceAction(String choice)
{
  if(choice == Constants.Delete){
    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("note-01").doc(existingNote.id).delete().then((_) {
      print("success!");
     });
    Navigator.pop(currentContext);
  }
}

void _onPressed() {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("note-01").doc(existingNote.id).set(
      {
        "Sadržaj" : sadrzajController.text,
        "Naziv" : nazivController.text,
      },SetOptions(merge: true)).then((_){
    print("success!");
  });
  Navigator.pop(currentContext);
}