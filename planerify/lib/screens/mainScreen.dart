import 'package:flutter/material.dart';
import 'package:planerify/models/menuOption.dart';
import 'package:planerify/support/menuList.dart';

import 'notes.dart';




class IconButtonApp extends StatelessWidget {
  static const String _title = 'Planerify';

  @override
  Widget build(BuildContext context) {
    listOfCards.clear();
    InitializeList();
    return MaterialApp(
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(title: const Text(_title)),
        body: ListView.builder(
            itemCount: listOfCards.length,
            itemBuilder: _itemBuilder,
          ) 
          /*Center(
          child: MyStatefulWidget(),
        ),
      ),*/
    ));
  }
}

Widget _itemBuilder(BuildContext context, int index) {
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



