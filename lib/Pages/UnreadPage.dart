import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'Components/FeedItem.dart';
import 'Components/Loading.dart';

import '../Data/database.dart';
import '../Model/ArticleModel.dart';
import '../Tool/Tool.dart';
import '../Tool/SizeCalculate.dart';
import '../Extension/Int.dart';

class UnreadPage extends StatefulWidget {
  @override
  _UnreadPageState createState() => _UnreadPageState();
}

class _UnreadPageState extends State<UnreadPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoadComplete = false;
  bool _wantKeepAlive = true;

  @override
  bool get wantKeepAlive => _wantKeepAlive;

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
    // 初始化 SizeCalculate
    SizeCalculate.initialize(context);

    // 先判断是否 Loading 完成，没有的话继续展示 Loading 效果
    return this._isLoadComplete
        ? Selector<ArticleModel, ArticleModel>(
            selector: (context, provider) => provider,
            builder: (context, provider, child) {
              return LiquidPullToRefresh(
                onRefresh: () async {
                  setState(() {
                    this._wantKeepAlive = false;
                    this.updateKeepAlive();
                  });
                  await provider.update();
                  setState(() {
                    this._wantKeepAlive = true;
                    this.updateKeepAlive();
                  });
                },
                springAnimationDurationInMilliseconds: 250,
                height: (180.rpx),
                color: Tool().colorFromHex("#f5712c"),
                showChildOpacityTransition: false,
                child: provider.total > 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
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
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          Text(
                            "没有新文章",
                          )
                              .bold()
                              .fontSize(40.rpx)
                              .textColor(
                                Tool().colorFromHex("#f5712c"),
                              )
                              .center()
                              .padding(top: 549.rpx)
                        ],
                      ),
              );
            },
          )
        : Loading();
  }
}
