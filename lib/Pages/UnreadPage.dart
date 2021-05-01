import 'package:flutter/material.dart';
import 'Components/FeedItem.dart';
import 'Components/Loading.dart';
import '../Object/TinyTinyRss.dart';
import '../Tool/Tool.dart';

class UnreadPage extends StatefulWidget {
  UnreadPage({Key key}) : super(key: key);

  @override
  _UnreadPageState createState() => _UnreadPageState();
}

class _UnreadPageState extends State<UnreadPage> {
  List<Map> unreadArticleList = [];
  bool isLoadComplete = false;

  @override
  void initState() {
    super.initState();
    // 初始化未读文章
    TinyTinyRss().getArticleInFeed(isLaunch: true).then((savedValue) {
      setState(() {
        this.unreadArticleList = savedValue;
        this.isLoadComplete = true;
      });
    });
  }

  // 接收子组件回调，更新未读列表
  void onChanged(List<Map> value) {
    setState(() {
      this.unreadArticleList = value;
    });
  }

  Future<void> _doRefresh() async {
    await TinyTinyRss().getArticleInFeed().then((value) {
      setState(() {
        this.unreadArticleList = value;
      });
    });
  }

  // 文章列表构造
  _getArticleList(index) {
    // 生成 Feed 流
    return FeedItem(
      feedId: unreadArticleList[index]['feedId'],
      feedIcon: unreadArticleList[index]['feedIcon'],
      feedTitle: unreadArticleList[index]['feedTitle'],
      feedArticles: unreadArticleList[index]['feedArticles'],
      unreadArticleList: this.unreadArticleList,
      callBack: (value) => onChanged(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 先判断是否 Loading 完成，没有的话继续展示 Loading 效果
    return this.isLoadComplete
        ? RefreshIndicator(
            // 下拉刷新
            onRefresh: this._doRefresh,
            color: Colors.black87,
            child: // 然后再判断是否有可用文章，没有的话展示无可读文章提示
                unreadArticleList.length > 0
                    ? ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: this.unreadArticleList.length,
                        itemBuilder: (context, index) {
                          return this._getArticleList(index);
                        },
                      )
                    : SingleChildScrollView(
                        // 总是可以滚动，用以保证可以下拉刷新
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          // 撑满整个屏幕，保证居中效果
                          height: MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              30.0,
                          child: Center(
                            child: Text(
                              "没有新文章",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Tool().colorFromHex("#f5712c"),
                              ),
                            ),
                          ),
                        ),
                      ),
          )
        : Loading();
  }
}