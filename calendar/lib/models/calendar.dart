import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar {
  final String id;
  String nazivKalendara;
  String korisnik_id;
  final DocumentReference reference;

  Calendar.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Naziv'] != null, map['Sadržaj'] != null),
        id = reference.id,
        nazivKalendara = map['Naziv'],
        korisnik_id = map['user_id'];

  Calendar.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$nazivKalendara>";
}
