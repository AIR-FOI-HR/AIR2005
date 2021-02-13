//implementation was taken from project found on https://github.com/lohanidamodar/flutter_calendar

import 'package:firebase_helpers/firebase_helpers.dart';
import '../models/event.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",fromDS: (id,data) => EventModel.fromDS(id, data), toMap:(event) => event.toMap());
