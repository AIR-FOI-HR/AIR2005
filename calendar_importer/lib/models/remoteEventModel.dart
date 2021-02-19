import 'package:firebase_auth/firebase_auth.dart';

class RemoteEventModel {
  final String title;
  final String description;
  final DateTime eventDate;
  final String user;

  RemoteEventModel({this.title, this.description, this.eventDate, this.user});

  factory RemoteEventModel.fromJson(
      Map<String, dynamic> json, String calendar) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return RemoteEventModel(
        title: json['title'],
        description: json['description'],
        eventDate: DateTime.parse(json['eventDate']),
        user: calendar);
  }

  Map<String, dynamic> toMap(String calendar) {
    return {
      "title": title,
      "description": description,
      "eventDate": eventDate,
      "user_id": user,
    };
  }

  @override
  String toString() {
    return 'Event: {Title = $title, Description = $description, Date = $eventDate, User = $user}';
  }
}
