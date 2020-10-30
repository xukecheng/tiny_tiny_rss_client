import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("TinyTinyRss")),
      body: HomePage(),
    ));
  }
}
