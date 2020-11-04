

import 'package:cloud_firestore/cloud_firestore.dart';

class Note{
  final String id;
  String nazivBiljeske;
  String sadrzajBiljeske;
  final DocumentReference reference;

  Note.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Naziv'] != null,
        map['Sadržaj'] != null),
        id= reference.id,
        nazivBiljeske = map['Naziv'],
        sadrzajBiljeske = map['Sadržaj'];

  Note.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$nazivBiljeske>";
}