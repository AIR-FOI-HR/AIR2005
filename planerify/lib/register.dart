// Adapted from https://github.com/kevinjnguyen/flutter-firebase-registration-ui

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:planerify/screens/mainScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final emailTextEditController = new TextEditingController();
  final passwordTextEditController = new TextEditingController();
  final confirmPasswordTextEditController = new TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      'register'.tr(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      '$_errorMessage',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                      controller: emailTextEditController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email'.tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.length < 8) {
                          return 'Password must be longer than 8 characters.';
                        }
                        return null;
                      },
                      autofocus: false,
                      obscureText: true,
                      controller: passwordTextEditController,
                      textInputAction: TextInputAction.next,
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocus);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password'.tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: confirmPasswordTextEditController,
                      focusNode: _confirmPasswordFocus,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (passwordTextEditController.text.length > 8 &&
                            passwordTextEditController.text != value) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'confirmPassword'.tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      onPressed: () {

                        if (_formKey.currentState.validate()) {
                          _firebaseAuth
                              .createUserWithEmailAndPassword(
                              email: emailTextEditController.text,
                              password: passwordTextEditController.text)
                              .then((userInfoValue) {
                             //Navigator.of(context).pushNamed(HomePage.tag);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => IconButtonApp())
                            );
                          })
                              .catchError((onError) {
                            processError(onError);
                          });
                        }
                      },
                      padding: EdgeInsets.all(12),

                      child: Text('register'.tr()),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.zero,
                      child: FlatButton(
                        child: Text(
                          'goToLogin'.tr()
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))
                ],
              ))),
    );
  }
}