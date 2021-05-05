import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tiny_tiny_rss_client/Object/database.dart';
import 'package:provider/provider.dart';

import 'Components/FeedItem.dart';
import 'Components/Loading.dart';

import '../Object/database.dart';
import '../Tool/Tool.dart';

class UnreadPage extends StatefulWidget {
  UnreadPage({Key key}) : super(key: key);

  @override
  _UnreadPageState createState() => _UnreadPageState();
}

class _UnreadPageState extends State<UnreadPage> {
  List<ArticlesInFeed> articlesInFeeds = [];
  bool isLoadComplete = false;
  @override
  void initState() {
    super.initState();
    // 初始化未读文章
    AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
    database.getArticlesInFeeds(isRead: 0).then((value) {
      setState(() {
        this.articlesInFeeds = value;
      });
      this.isLoadComplete = true;
    });
  }

  // 接收子组件回调，更新未读列表
  void onChanged(List<ArticlesInFeed> value) {
    setState(() {
      this.articlesInFeeds = value;
    });
  }

  // 文章列表构造
  Widget _getArticleList(int index) {
    // 生成 Feed 流
    return FeedItem(
      feedId: this.articlesInFeeds[index].id,
      feedIcon: this.articlesInFeeds[index].feedIcon,
      feedTitle: this.articlesInFeeds[index].feedTitle,
      feedArticles: this.articlesInFeeds[index].feedArticles,
      articlesInfeeds: this.articlesInFeeds,
      callBack: (value) => onChanged(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase database = Provider.of<AppDatabase>(context, listen: false);

    Future<void> _doRefresh() async {
      List<ArticlesInFeed> articlesInFeeds =
          await database.getArticlesInFeeds(isRead: 0);
      setState(() {
        this.articlesInFeeds = articlesInFeeds;
      });
    }

    // 先判断是否 Loading 完成，没有的话继续展示 Loading 效果
    return this.isLoadComplete
        ? LiquidPullToRefresh(
            onRefresh: _doRefresh,
            springAnimationDurationInMilliseconds: 250,
            height: 80,
            color: Tool().colorFromHex("#f5712c"),
            showChildOpacityTransition: false,
            child: this.articlesInFeeds.length > 0
                ? ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: this.articlesInFeeds.length,
                    itemBuilder: (context, index) {
                      return this._getArticleList(index);
                    },
                  )
                : ListView(
                    children: [
                      Text(
                        "没有新文章",
                      )
                          .bold()
                          .fontSize(20)
                          .textColor(
                            Tool().colorFromHex("#f5712c"),
                          )
                          .center()
                          .padding(top: 300)
                    ],
                  ),
          )
        : Loading();
  }
}
