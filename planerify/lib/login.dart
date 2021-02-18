// Adapted from http://www.codeplayon.com/2020/02/simple-flutter-login-screen-ui-example/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planerify/register.dart';
import 'package:planerify/screens/mainScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:planerify/screens/settings.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';


class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController errorController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('login').tr(),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage())
                    );
                  },
                  child: Icon(
                    Icons.settings_applications_sharp,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'email'.tr(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'password'.tr(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(errorController.text),
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      child: Text('login').tr(),
                      onPressed: ()  async {
                        errorController.text = "";
                        setState(() {});

                        String email = nameController.text;
                        String pass = passwordController.text;

                        try {
                          var user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => IconButtonApp()),
                                  (Route<dynamic> route) => false
                          );

                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print("abc");
                            errorController.text = "loginFailedUserNotFound".tr();
                            setState(() {});
                          } else if (e.code == 'wrong-password') {
                            errorController.text = "loginFailedWrongPassword".tr();
                            setState(() {});
                          } else if (e.code == 'invalid-email') {
                            errorController.text = "invalidEmail".tr();
                            setState(() {});
                          }
                          else {
                            errorController.text = "unknownLoginError".tr();
                            setState(() {});
                          }
                        }
                      },
                    )),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      child: Text('register').tr(),
                      onPressed: ()  {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage())
                          );


                      },
                    )),
              ],
            )));
  }
}