import 'package:flutter/material.dart';
import 'package:planerify/screens/calendarScreen.dart';
import 'package:planerify/screens/notes.dart';

import '../models/menuOption.dart';

List<MenuOption> listOfCards = <MenuOption>[];


getInstance(int index) {
  return listOfCards[index];
}

InitializeList()
{

  listOfCards.add(new MenuOption("Bilješke", Icons.note, Notes()));
  listOfCards.add(new MenuOption("Kalendar", Icons.calendar_today_outlined, CalendarScreen()));
}

