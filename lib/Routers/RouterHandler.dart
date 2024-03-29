import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../Pages/ArticleDetailPage.dart';
import '../Pages/FavoritePage.dart';

Handler articleDetailHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, dynamic> params,
) {
  int id = int.parse(params["articleId"][0]);
  return ArticleDetailPage(id);
});

Handler favoritePageHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, dynamic> params,
) {
  return FavoritePage();
});
