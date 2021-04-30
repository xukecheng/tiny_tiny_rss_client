import 'package:flutter/material.dart';
import 'Tool/Tool.dart';
import 'Pages/UnreadPage.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'utils/config.dart';
import 'package:fluro/fluro.dart';
import 'Routers/Application.dart';
import 'Routers/Routers.dart';

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
    final router = FluroRouter();
    //给routers.dart里面的传递FluroRouter传递router实例对象
    Routes.configureRoutes(router);
    //给Application的router赋值router实例对象
    Application.router = router;

    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      //generator生成的意思，生成路由的回调函数，当导航的命名路由的时候，会使用这个来生成路由
      onGenerateRoute: Application.router.generator,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "TinyTinyRSS",
            style: TextStyle(
              color: Tool().colorFromHex("#f5712c"),
            ),
          ),
        ),
        body: UnreadPage(),
        backgroundColor: Tool().colorFromHex("#f5f5f5"),
      ),
    );
  }
}
