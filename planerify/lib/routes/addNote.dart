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
        title: Text("Nova bilješka"),
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
