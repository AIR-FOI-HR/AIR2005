import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
      MaterialApp(
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: LoginPage(),
    )
  );
}


