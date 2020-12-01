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
  bool isLoadComplete = false;

  @override
  void initState() {
    super.initState();
    // 初始化未读文章
    TinyTinyRss().getArticle(isUnread: true).then((res) {
      setState(() {
        this.unreadArticleList = res;
        this.isLoadComplete = true;
      });
    });
  }

  Future<void> _doRefresh() async {
    await TinyTinyRss().getArticle(isUnread: true).then((res) {
      setState(() {
        this.isLoadComplete = false;
        this.unreadArticleList = res;
        this.isLoadComplete = true;
      });
    });
  }

  // 文章构造
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

  @override
  Widget build(BuildContext context) {
    return this.isLoadComplete
        ? unreadArticleList.length > 0
            ? RefreshIndicator(
                // 下拉刷新
                onRefresh: this._doRefresh,
                color: Colors.black87,
                child: ListView.builder(
                  // 设置回弹效果
                  physics: new AlwaysScrollableScrollPhysics(),
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
                                articleContent:
                                    unreadArticleList[index].htmlContent),
                          ),
                        );
                      },
                      child: Container(
                        color: unreadArticleList[index].isRead == 1
                            // 已读文章变色
                            ? Colors.grey[100]
                            : Colors.white,
                        child: this._getArticleList(index),
                      ),
                    );
                  },
                ),
              )
            : RefreshIndicator(
                // 没有列表组件的下拉刷新
                onRefresh: this._doRefresh,
                color: Colors.black87,
                child: SingleChildScrollView(
                  // 高度不足时
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    // 撑满整个屏幕，保证居中效果
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        "没有新文章",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
        : Loading();
  }
}
