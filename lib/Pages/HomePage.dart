import 'package:flutter/material.dart';
import '../TestMap.dart';
import 'Components/ArticleItem.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var unreadArticleList = new List();
  List<Widget> _getData() {
    unreadArticleMap["data"].forEach((k, v) => unreadArticleList.add(v));
    return unreadArticleList.map((value) {
      return ArticleItem(
          title: value['title'],
          feedIcon:
              "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
          feedTitle: value['feed_title'],
          articleDescrition: value['description'],
          flavorImage: value['flavor_image'],
          publishTime: value["time"]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this._getData(),
    );
  }
}
