// Adapted from http://www.codeplayon.com/2020/02/simple-flutter-login-screen-ui-example/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planerify/screens/mainScreen.dart';
import 'package:easy_localization/easy_localization.dart';



class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('login').tr(),
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
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: Text('login').tr(),
                      onPressed: ()  {
                        String email =nameController.text;
                        String pass =passwordController.text;
                         _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass)
                            .then((user) => {
                           Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => IconButtonApp())
                           )
                        })
                       ;
                      },
                    )),
              ],
            )));
  }
}