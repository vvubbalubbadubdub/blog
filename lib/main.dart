import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "blog",
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey,
          elevation: 10,
          title: Text(
            "not ortalaması",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(width: 200, height: 200, color: Colors.pink),
      ),
    );
  }
}
