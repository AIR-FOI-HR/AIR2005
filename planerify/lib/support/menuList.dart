import 'package:calendar/screens/calendarSelect.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:planerify/screens/notes.dart';
import 'package:planerify/screens/temperatureNotes.dart';

import '../models/menuOption.dart';

List<MenuOption> listOfCards = <MenuOption>[];

getInstance(int index) {
  return listOfCards[index];
}

InitializeList() {
  listOfCards.add(new MenuOption("notes".tr(), Icons.note, Notes()));
  listOfCards.add(new MenuOption(
      "calendar".tr(), Icons.calendar_today_outlined, Calendars()));
  listOfCards.add(new MenuOption(
      "temperatureNotes".tr(), Icons.coronavirus_outlined, Temperature()));
}
