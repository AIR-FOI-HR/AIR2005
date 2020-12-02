import 'package:flutter/cupertino.dart';

class MenuOption {
  String Name;
  IconData MenuIcon;
  Object Route;

  MenuOption(String name, IconData menuIcon, Object route) {
    this.Name = name;
    this.MenuIcon = menuIcon;
    this.Route = route;
  }
}