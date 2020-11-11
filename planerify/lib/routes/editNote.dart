import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/note.dart';
import 'package:planerify/support/Constants.dart';


TextEditingController nazivController = TextEditingController();
TextEditingController sadrzajController = TextEditingController();


class EditNote extends StatelessWidget {
  static const routeName = '/editNote';
  @override
  Widget build(BuildContext context) {
    Note editingNote = ModalRoute.of(context).settings.arguments;
    nazivController.text = editingNote.nazivBiljeske;
    sadrzajController.text = editingNote.sadrzajBiljeske;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
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
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),

    );
  }
}

void choiceAction(String choice)
{
  print("Working");
}