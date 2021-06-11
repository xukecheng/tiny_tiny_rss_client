import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:tiny_tiny_rss_client/Tool/Tool.dart';

import 'dart:io';

import 'utils/config.dart';

import 'Pages/UnreadPage.dart';
import 'Pages/FavoritePage.dart';
import 'Pages/SearchPage.dart';
import 'Pages/SettingPage.dart';

import 'Routers/Application.dart';
import 'Routers/Routers.dart';
import 'Data/database.dart';
import 'Model/UnreadArticleModel.dart';
import 'Model/BottomNavyModel.dart';

void main() async {
  Config.env = Env.PROD;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Widget> _pages = [
    UnreadPage(),
    FavoritePage(),
    SearchPage(),
    SettingPage()
  ];

  final PageController _pageController = PageController(initialPage: 0);

  List<BottomNavigationBarItem> get getBottomTabbarItemList => [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Unread',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
        )
      ];

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
          return UnreadArticleModel(db);
        },
        child: MaterialApp(
          theme: new ThemeData(
            primaryColor: Colors.white,
          ),
          //generator生成的意思，生成路由的回调函数，当导航的命名路由的时候，会使用这个来生成路由
          onGenerateRoute: Application.router.generator,
          home: Selector<BottomNavyModel, BottomNavyModel>(
            selector: (context, provider) => provider,
            builder: (context, provider, child) {
              return Scaffold(
                body: PageView(
                  controller: this._pageController,
                  children: this._pages,
                  onPageChanged: (int index) {
                    provider.currentIndex = index;
                  },
                ),
                backgroundColor: Colors.white,
                bottomNavigationBar: Selector<BottomNavyModel, int>(
                  selector: (context, provider) => provider.currentIndex,
                  builder: (context, index, child) {
                    return BottomNavigationBar(
                      onTap: (int selectedIndex) {
                        provider.currentIndex = selectedIndex;
                        this._pageController.jumpToPage(selectedIndex);
                      },
                      currentIndex: index,
                      backgroundColor: Tool().colorFromHex("#225555"),
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Tool().colorFromHex("#c6d3d3"),
                      type: BottomNavigationBarType.fixed,
                      items: this.getBottomTabbarItemList,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
