import 'package:cloud_firestore/cloud_firestore.dart';
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


  TextEditingController nazivController= TextEditingController();
  TextEditingController sadrzajController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("editingNote");
    if(editingNote!=null)
    {
      nazivController.text = editingNote.nazivBiljeske;
      sadrzajController.text = editingNote.sadrzajBiljeske;

    }
    else
    {
      nazivController.clear();
      sadrzajController.clear();
    }
    print(nazivController.text);

  }

  void choiceAction(String choice)
  {
    if(choice == Constants.Delete){
      final firestoreInstance = FirebaseFirestore.instance;
      firestoreInstance.collection("note-01").doc(editingNote.id).delete().then((_) {
        print("success!");
      });
      Navigator.pop(context);
    }
  }

  //logika
  void handleButtonPressed() {
    if(editingNote != null) {
      final firestoreInstance = FirebaseFirestore.instance;
      firestoreInstance.collection("note-01").doc(editingNote.id).set(
          {
            "Sadržaj" : sadrzajController.text,
            "Naziv" : nazivController.text,
          },SetOptions(merge: true)).then((_){
        print("success!");
      });

    }
    else{
      final firestoreInstance = FirebaseFirestore.instance;
      firestoreInstance.collection("note-01").add(
          {
            "Naziv": nazivController.text,
            "Sadržaj": sadrzajController.text
          }).then((value){
        print(value.id);
      });
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
        title: state.editingNote == null ? Text("Dodaj bilješku") : Text("Izmjeni bilješku"),
        actions: <Widget> [
          _buildPopupMenu(context)
        ],
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

  Widget _buildPopupMenu(BuildContext context){
    if(state.editingNote != null){
      return
        PopupMenuButton<String>(
          onSelected: state.choiceAction,
          itemBuilder: (BuildContext context){
            return Constants.choices.map((String choice){
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
        decoration: const InputDecoration.collapsed(hintText: 'Naslov'),
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
      ),
    ],
  );

}

