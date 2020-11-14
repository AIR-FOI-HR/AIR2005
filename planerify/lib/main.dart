import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 90),
            child: AppBar(
              flexibleSpace: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text("Planerify",
                            style: TextStyle(color: Colors.white,
                                fontSize: 26)),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Bilješke",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 16))))
                      ])),
            )),
        body: _buildBody(),
        )
    );
  }
}

Widget _buildBody(){
  return Center(
    child: Text('Unesite bilješku')
  );
}