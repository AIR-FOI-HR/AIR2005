import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planerify/login.dart';
import 'package:planerify/register.dart';
import 'package:planerify/screens/mainScreen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
  home: LoginPage()));
}


