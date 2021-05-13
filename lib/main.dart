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
import 'Pages/FavoritePage.dart';
import 'Data/database.dart';
import 'Model/ArticleModel.dart';
import 'Model/BottomNavyModel.dart';

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
  final List<Widget> _pages = [
    UnreadPage(),
    FavoritePage(),
  ];

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final router = FluroRouter();
    //给routers.dart里面的传递FluroRouter传递router实例对象
    Routes.configureRoutes(router);
    //给Application的router赋值router实例对象
    Application.router = router;

    return MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (_) => constructDb()),
        ChangeNotifierProvider<BottomNavyModel>(
            create: (_) => BottomNavyModel()),
      ],
      child: ChangeNotifierProvider(
        create: (context) {
          final db = Provider.of<AppDatabase>(context, listen: false);
          return ArticleModel(db);
        },
        child: MaterialApp(
          theme: new ThemeData(
            primaryColor: Colors.white,
          ),
          //generator生成的意思，生成路由的回调函数，当导航的命名路由的时候，会使用这个来生成路由
          onGenerateRoute: Application.router.generator,
          home: Scaffold(
              // appBar: AppBar(
              //   title: Text(
              //     "TinyTinyRSS",
              //     style: TextStyle(
              //       color: Tool().colorFromHex("#f5712c"),
              //     ),
              //   ),
              // ),
              body: Selector<BottomNavyModel, int>(
                selector: (context, provider) => provider.currentIndex,
                builder: (context, index, child) {
                  return PageView(
                    controller: this._pageController,
                    children: this._pages,
                  );
                },
              ),
              backgroundColor: Colors.white,
              bottomNavigationBar: Selector<BottomNavyModel, int>(
                  selector: (context, provider) => provider.currentIndex,
                  builder: (context, data, child) {
                    print("build BottomNavyBar");
                    return BottomNavyBar(
                      selectedIndex: data,
                      onItemSelected: (int index) {
                        data = index > 1 ? 1 : index;
                        this._pageController.jumpToPage(data);
                      },
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
                  })),
        ),
      ),
    );
  }
}

class BottomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavyModel>(context);
    return BottomNavyBar(
      selectedIndex: provider.currentIndex,
      onItemSelected: (int index) =>
          provider.currentIndex = index > 1 ? 1 : index,
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
