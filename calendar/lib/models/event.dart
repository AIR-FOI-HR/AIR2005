//implementation was taken from project found on https://github.com/lohanidamodar/flutter_calendar
import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;

  EventModel({this.id,this.title, this.description, this.eventDate});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
        eventDate: data['eventDate']?.toDate()
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['eventDate']?.toDate(),
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "eventDate":eventDate,
      "id":id,
    };
  }
}