import 'package:flutter/material.dart';
import 'Tool/Tool.dart';
import 'Pages/HomePage.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.5;
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.blueGrey[500],
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("TinyTinyRss")),
        body: HomePage(),
        backgroundColor: Tool().colorFromHex("#efefef"),
      ),
    );
  }
}
