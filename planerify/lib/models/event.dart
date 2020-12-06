
import 'package:cloud_firestore/cloud_firestore.dart';

class EventData {
  String title;
  Timestamp eventDate;
  String description;

  final DocumentReference reference;



  EventData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null, map['eventDate'] != null),
        title = map['title'],
        eventDate = map['eventDate'],
        description = map['description'];

  EventData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() {
    return 'Event $title @ ${eventDate.toDate()}';
  }
}
