// Adapted from http://www.codeplayon.com/2020/02/simple-flutter-login-screen-ui-example/
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/login.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<SettingsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var theme = ThemeModeHandler.of(context).themeMode;
    var locale = context.locale.languageCode;
    print(locale);
    return Scaffold(
        appBar: AppBar(
          title: Text('settings').tr(),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: new DropdownButton<String>(
                      value: theme == ThemeMode.dark ? "Dark" : "Light",
                      items: <String>['Light', 'Dark'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value, style: TextStyle()),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        var newTheme = newValue == "Dark"
                            ? ThemeMode.dark
                            : ThemeMode.light;
                        ThemeModeHandler.of(context).saveThemeMode(newTheme);

                        setState(() {
                          theme = newTheme;
                        });
                      },
                    )),
                Container(
                    padding: EdgeInsets.all(10),
                    child: new DropdownButton<String>(
                      value: locale == "en" ? "English" : "Croatian",
                      items:
                          <String>['English', 'Croatian'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        var newLocale = newValue == "English" ? "en" : "hr";
                        context.locale = Locale(newLocale);

                        setState(() {
                          locale = newLocale;
                        });
                      },
                    )),
                Visibility(
                    child: Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: RaisedButton(
                            child: Text('logout').tr(),
                            onPressed: () async {
                              await _firebaseAuth.signOut();

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false);
                            })),
                    visible: FirebaseAuth.instance.currentUser == null
                        ? false
                        : true)
              ],
            )));
  }
}
