import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/login.dart';
import 'package:planerify/screens/mainScreen.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

import 'services/MyManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('hr')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp())
      );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      manager: MyManager(),
      builder: (ThemeMode themeMode) {
        return
      MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
                  themeMode: themeMode,
                  darkTheme: ThemeData(
                    brightness: Brightness.dark,
                  ),
                  theme: ThemeData(
                    brightness: Brightness.light,
                  ),
                  home:  FirebaseAuth.instance.currentUser == null ? LoginPage() : IconButtonApp()
              );

      },
    );
  }
}

