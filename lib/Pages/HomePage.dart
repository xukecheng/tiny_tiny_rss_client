import 'package:flutter/material.dart';
import 'Components/ArticleItem.dart';
import 'package:dio/dio.dart';
import 'package:frefresh/frefresh.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Article.dart';
// const favoritesBox = 'favorite_books';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List unreadArticleList = new List();

  @override
  void initState() {
    super.initState();
    Article().getUnread().then((res) {
      setState(() {
        this.unreadArticleList = res;
        print(123);
      });
    });
  }

  void saveUnreadArticle() async {
    BaseOptions options = BaseOptions(baseUrl: "http://192.168.2.167:8888");
    Dio dio = Dio(options);
    try {
      Response response = await dio.get("/get_unreads");
      setState(() {
        // article.put('unreadArticleList', response.data["data"]);
      });
    } catch (e) {
      print(e);
    }
  }

  _getArticleList(index) {
    return ArticleItem(
        title: unreadArticleList[index]['title'],
        feedIcon:
            "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
        feedTitle: unreadArticleList[index]['feed_title'],
        articleDesciption: unreadArticleList[index]["description"],
        flavorImage: unreadArticleList[index]['flavor_image'],
        publishTime: unreadArticleList[index]["time"],
        articleContent: unreadArticleList[index]["content"]);

    // return unreadArticleList.map<Widget>((value) {
    //   return ArticleItem(
    //       title: value['title'],
    //       feedIcon:
    //           "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
    //       feedTitle: value['feed_title'],
    //       articleDesciption: value["description"],
    //       flavorImage: value['flavor_image'],
    //       publishTime: value["time"],
    //       articleContent: value["content"]);
    // }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: unreadArticleList.length, //- 要生成的条数
        itemBuilder: (context, index) {
          return this._getArticleList(index);
        });

    //   children: this._getArticleList(),
    // );
  }
}
