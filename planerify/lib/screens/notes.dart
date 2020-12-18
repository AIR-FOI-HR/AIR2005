import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/note.dart';
import 'file:///C:/Users/Patrik/Documents/GitHub/AIR2005/planerify/lib/screens/addNote.dart';
import 'file:///C:/Users/Patrik/Documents/GitHub/AIR2005/planerify/lib/screens/editNote.dart';

class Notes extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
        routes: {
          EditNote.routeName: (context) => EditNote()
        },
        title: 'Bilješke',
        home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Bilješke')
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addNoteNavigator();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
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
              onTap: () => Navigator.pushNamed(context, EditNote.routeName, arguments: note)
          )
      ),
    );
  }

  _addNoteNavigator()
  {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddNote())
    );
  }
}







