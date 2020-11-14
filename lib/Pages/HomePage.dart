import 'package:flutter/material.dart';
import 'Components/ArticleItem.dart';
import '../Object/Article.dart';
import 'Components/Loading.dart';
import '../Tool/Tool.dart';
import './ArticleDetail.dart';

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
    TinyTinyRss().getArticle().then((res) {
      setState(() {
        this.unreadArticleList = res;
      });
    });
  }

  _getArticleList(index) {
    return ArticleItem(
        articleId: unreadArticleList[index].id,
        articleTitle: unreadArticleList[index].title,
        feedIcon:
            "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
        feedTitle: "test",
        articleDesciption: unreadArticleList[index].description,
        flavorImage: unreadArticleList[index].flavorImage,
        publishTime:
            Tool().timestampToDate(unreadArticleList[index].publishTime),
        htmlContent: unreadArticleList[index].htmlContent);
  }

  Future<void> _doRefresh() async {
    await TinyTinyRss().getArticle().then((res) {
      setState(() {
        this.unreadArticleList = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 当文章列表长度大于 0 时，结束加载
    return unreadArticleList.length > 0
        ? RefreshIndicator(
            onRefresh: this._doRefresh,
            color: Colors.black87,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: unreadArticleList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        // 设置文章为已读
                        setState(() {
                          TinyTinyRss().markRead(unreadArticleList[index].id);
                          unreadArticleList[index].isRead = 1;
                        });
                        // 点击跳转详情页
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            //传值
                            builder: (context) => ArticleDetail(
                                articleTitle: unreadArticleList[index].title,
                                flavorImage:
                                    unreadArticleList[index].flavorImage,
                                articleContent:
                                    unreadArticleList[index].htmlContent),
                          ),
                        );
                      },
                      child: Container(
                        color: unreadArticleList[index].isRead == 1
                            ? Colors.grey[100]
                            : Colors.white,
                        child: this._getArticleList(index),
                      ));
                }))
        : Loading();
  }
}
