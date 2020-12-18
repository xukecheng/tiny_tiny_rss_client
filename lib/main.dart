import 'package:flutter/material.dart';
import 'Tool/Tool.dart';
import 'Pages/HomePage.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'utils/config.dart';

void main() async {
  Config.env = Env.PROD;
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "TinyTinyRSS",
            style: TextStyle(
              color: Tool().colorFromHex("#f5712c"),
            ),
          ),
        ),
        body: HomePage(),
        backgroundColor: Tool().colorFromHex("#f5f5f5"),
      ),
    );
  }
}
