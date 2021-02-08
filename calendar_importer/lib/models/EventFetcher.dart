import 'dart:convert';
import 'package:calendar_importer/models/eventImporter.dart';
import 'package:calendar_importer/models/remoteEventModel.dart';
import 'package:http/http.dart' as http;


class EventFetcher
{
  EventFetcher(user);

  void fetchEvents(String url) async {
    final response =
    await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final json = jsonDecode(response.body);
      if (json != null) {
        json.forEach((element) {
          final event = RemoteEventModel.fromJson(element);
          EventImporter.importEvent(event);
          print(event);
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load events.');
    }
  }
}

