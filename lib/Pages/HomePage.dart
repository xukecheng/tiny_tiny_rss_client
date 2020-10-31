import 'package:flutter/material.dart';
import 'Components/ArticleItem.dart';
import 'Article.dart';

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
      });
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: unreadArticleList.length, //- 要生成的条数
        itemBuilder: (context, index) {
          return this._getArticleList(index);
        });
  }
}
