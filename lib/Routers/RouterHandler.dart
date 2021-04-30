import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../Pages/ArticleDetail.dart';

Handler articleDetailHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  int id = int.parse(params["articleId"][0]);
  return ArticleDetail(id: id);
});
