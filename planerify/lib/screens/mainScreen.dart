import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/menuOption.dart';
import 'package:planerify/screens/settings.dart';
import 'package:planerify/support/menuList.dart';

import 'notes.dart';




class IconButtonApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    listOfCards.clear();
    InitializeList();
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(title: Text("Planerify"),
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
        ],),
        body: ListView.builder(
            itemCount: listOfCards.length,
            itemBuilder: _itemBuilder,
          ) 
          /*Center(
          child: MyStatefulWidget(),
        ),
      ),*/
    );
  }
}

Widget _itemBuilder(BuildContext context, int index) {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MenuOption menuOption = getInstance(index);

  return  Card(
          child: InkWell(
          splashColor: Colors.black12,
          onTap: ()
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => menuOption.Route),
            );
          }
          ,
          child: Container(
            width: 300,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(menuOption.MenuIcon,size: 50,),
                Text("${menuOption.Name}")
              ],
            ),
          ),
        )
    );

}



