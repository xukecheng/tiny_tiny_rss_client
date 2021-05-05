import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import 'Tool/Tool.dart';
import 'utils/config.dart';
import 'Routers/Application.dart';
import 'Routers/Routers.dart';
import 'Pages/UnreadPage.dart';
import 'Object/database.dart';

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

    return Provider(
        create: (_) => AppDatabase(),
        child: MaterialApp(
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
              bottomNavigationBar: BottomNavigartor()),
        ));
  }
}

class BottomNavigartor extends StatefulWidget {
  BottomNavigartor({Key key}) : super(key: key);

  @override
  _BottomNavigartorState createState() => _BottomNavigartorState();
}

class _BottomNavigartorState extends State<BottomNavigartor> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: _currentIndex,
      showElevation: true, // use this to remove appBar's elevation
      onItemSelected: (index) => setState(
        () {
          _currentIndex = index;
          // _pageController.animateToPage(index,
          //     duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
      items: [
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
          activeColor: Colors.red,
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title: Text('收藏'),
            activeColor: Colors.purpleAccent),
        BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text('搜索'),
            activeColor: Colors.pink),
        BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.blue),
      ],
    );
  }
}
