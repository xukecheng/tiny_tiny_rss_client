import 'package:flutter/material.dart';
import 'Components/ArticleItem.dart';
import '../Object/Article.dart';
import 'Components/Loading.dart';
import 'package:frefresh/frefresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List unreadArticleList = new List();
  FRefreshController controller = FRefreshController();

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
        articleId: unreadArticleList[index]['id'],
        articleTitle: unreadArticleList[index]['title'],
        feedIcon:
            "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
        feedTitle: unreadArticleList[index]['feed_title'],
        articleDesciption: unreadArticleList[index]["description"],
        flavorImage: unreadArticleList[index]['flavor_image'],
        publishTime: unreadArticleList[index]["time"],
        articleContent: unreadArticleList[index]["content"]);
  }

  Future<void> _doRefresh() async {
    await Article().getUnread().then((res) {
      setState(() {
        this.unreadArticleList = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return unreadArticleList.length > 0
        ? RefreshIndicator(
            onRefresh: this._doRefresh,
            color: Colors.black87,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: unreadArticleList.length,
                itemBuilder: (context, index) {
                  return this._getArticleList(index);
                }))
        : Loading();
  }
}
