import 'package:cloud_firestore/cloud_firestore.dart';

class Temperatures {
  final String id;
  String sadrzajBiljeske;
  DateTime datum;
  final DocumentReference reference;

  Temperatures.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['sadrzaj'] != null),
        id = reference.id,
        datum = map['datum'] == null ? null : DateTime.parse(map['datum']),
        sadrzajBiljeske = map['sadrzaj'];

  Temperatures.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$sadrzajBiljeske>";
}
