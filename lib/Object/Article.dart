import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

const articleBox = 'articles';

class Article {
  Box<List> article;
  getUnread() async {
    await Hive.initFlutter();
    await Hive.openBox<List>(articleBox);
    article = Hive.box(articleBox);
    BaseOptions options = BaseOptions(baseUrl: "http://192.168.2.214:8888");
    Dio dio = Dio(options);
    try {
      Response response = await dio.get("/get_unreads");
      await article.put('unreadArticleList', response.data["data"]);
      return article.get('unreadArticleList');
    } catch (e) {
      if (article.get('unreadArticleList').isNotEmpty) {
        return article.get('unreadArticleList');
      }
    }
  }
}
