import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/note.dart';
import 'package:planerify/support/Constants.dart';
import 'package:planerify/support/styles.dart';

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
        title: Text("Izmjeni bilješku"),
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
      decoration: const InputDecoration.collapsed(hintText: 'Naslov'),
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
    ),
  ],
);


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