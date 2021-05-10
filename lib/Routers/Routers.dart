import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'RouterHandler.dart';

class Routes {
  //根路径
  static String root = '/';
  static String articleDetail = '/articleDetail';
  static String favoritePage = '/favoritePage';

  //配置路由对象，所有的路由都在这里面
  static void configureRoutes(FluroRouter router) {
    //路由页面
    router.define(articleDetail, handler: articleDetailHandler);
    router.define(favoritePage, handler: favoritePageHandler);

    //无路由页面
    router.notFoundHandler = Handler(
      handlerFunc: (
        BuildContext? context,
        Map<String, List<String>> params,
      ) {
        return Container(
          child: Center(
            child: Text("没有找到"),
          ),
        );
      },
    );
  }
}
