import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:planerify/login.dart';
import 'file:///C:/Users/Patrik/Documents/GitHub/AIR2005/planerify/lib/screens/addNote.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Patrik/Documents/GitHub/AIR2005/planerify/lib/screens/editNote.dart';
import 'package:planerify/screens/mainScreen.dart';
import 'package:planerify/screens/notes.dart';

import 'models/note.dart';

//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(Notes());
  runApp(IconButtonApp());
}



//void main() => runApp(IconButtonApp());