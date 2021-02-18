import 'package:calendar_importer/models/remoteEventModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventImporter{
  static void importEvent(RemoteEventModel event, String calendar){
    final _firestoreInstance = FirebaseFirestore.instance;
    _firestoreInstance.collection("events").add(event.toMap(calendar));
  }
}