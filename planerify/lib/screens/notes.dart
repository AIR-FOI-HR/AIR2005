import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/note.dart';
import 'file:///C:/Users/Patrik/Documents/GitHub/AIR2005/planerify/lib/screens/editNote.dart';
import 'package:planerify/support/widgetView.dart';



class Notes extends StatefulWidget {
  @override
  _NotesController createState() => _NotesController();
}

class _NotesController extends State<Notes> {
  @override
  Widget build(BuildContext context) => _NotesView(this);
}

class _NotesView extends WidgetView<Notes, _NotesController> {
  _NotesView(_NotesController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Bilješke')
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addNoteNavigator(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {

    //database
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('note-01').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if(snapshot.isNotEmpty)
    {
      return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      );
    }
    else
    {
      return Center(
          child: Text("Unesi bilješku")
      );
    }
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final note = Note.fromSnapshot(data);
    return Padding(
        key: ValueKey(note.id),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
                title: Text(note.nazivBiljeske),
                onTap: () => _addNoteNavigator(context, note))
        )
    );
  }

  _addNoteNavigator(BuildContext context, [Note note])
  {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditNote(editingNote: note))
    );
  }
}






