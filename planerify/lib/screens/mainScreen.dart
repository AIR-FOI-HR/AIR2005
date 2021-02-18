import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planerify/models/menuOption.dart';
import 'package:planerify/support/menuList.dart';
import 'package:planerify/support/globals.dart' as globals;
import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'notes.dart';
import 'package:theme_provider/theme_provider.dart';


class IconButtonApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    listOfCards.clear();
    InitializeList();
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
            title: Text("Planerify"),
      ),

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
  print(_firebaseAuth.currentUser.email);
  print(_firebaseAuth.currentUser.uid);
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



