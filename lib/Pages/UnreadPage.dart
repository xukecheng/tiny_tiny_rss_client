import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'Components/FeedItem.dart';
import 'Components/Loading.dart';

import '../Data/database.dart';
import '../Model/ArticleModel.dart';
import '../Tool/Tool.dart';

class UnreadPage extends StatefulWidget {
  @override
  _UnreadPageState createState() => _UnreadPageState();
}

class _UnreadPageState extends State<UnreadPage> {
  bool _isLoadComplete = false;

  @override
  void initState() {
    super.initState();
    // 初始化未读文章
    Provider.of<ArticleModel>(context, listen: false)
        .update(isLaunch: true)
        .then((value) {
      setState(() {
        this._isLoadComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 先判断是否 Loading 完成，没有的话继续展示 Loading 效果
    return this._isLoadComplete
        ? Selector<ArticleModel, ArticleModel>(
            selector: (context, provider) => provider,
            shouldRebuild: (prev, next) => true,
            builder: (context, provider, child) {
              return LiquidPullToRefresh(
                  onRefresh: () async {
                    await Provider.of<ArticleModel>(context, listen: false)
                        .update();
                  },
                  springAnimationDurationInMilliseconds: 250,
                  height: 80,
                  color: Tool().colorFromHex("#f5712c"),
                  showChildOpacityTransition: false,
                  child: provider.total > 0
                      ? ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: provider.total,
                          itemBuilder: (context, index) {
                            return Selector<ArticleModel, ArticlesInFeed>(
                                selector: (context, provider) =>
                                    provider.getData[index],
                                builder: (context, data, child) {
                                  return FeedItem(
                                    index,
                                    data,
                                    provider,
                                  );
                                });
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
                        ));
            },
          )
        : Loading();
  }
}
