import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fluro/fluro.dart';

import 'ArticleItem.dart';
import 'FeedItemExpansion.dart';

import '../../Tool/SizeCalculate.dart';
import '../../Tool/Tool.dart';
import '../../Extension/Int.dart';
import '../../Extension/Double.dart';

import '../../Data/database.dart';
import '../../Model/ArticleModel.dart';
import '../../Routers/Application.dart';

class FeedItem extends StatelessWidget {
  FeedItem(this.feedIndex, this.articlesInFeed, this.provider);
  final int feedIndex;
  final ArticlesInFeed articlesInFeed;
  final ArticleModel provider;

  // Feed 下标记已读
  void _setReadStatus(List<int> articleIndexList, int isRead,
      {int? feedIndex}) {
    this.provider.setReadStatus(
          feedIndex != null ? feedIndex : this.feedIndex,
          articleIndexList,
          isRead,
        );
  }

  void _longPress(BuildContext context, int articleIndex) {
    void _batchSetRead(bool isUp) {
      // 以上全部已读
      if (isUp) {
        // 获取当前 Feed 以上的 Feed，设置为全部已读
        for (var i = 0; i < this.feedIndex; i++) {
          this._setReadStatus([], 1, feedIndex: i);
        }
        // 获取当前 Feed 中，文章之上有哪些文章
        List<int> articleIndexList = [];
        for (var i = 0; i < articleIndex; i++) {
          articleIndexList.add(i);
        }

        /// 如果当前 Feed 中需要已读的文章列表为空，则不设置已读，
        /// 防止出现选择第一篇文章以上已读，却导致当前 Feed 全部已读
        if (articleIndexList.isNotEmpty) {
          this._setReadStatus(articleIndexList, 1);
        }
      } else {
        // 以下全部已读
        // 获取当前 Feed 以下的 Feed，设置为全部已读
        for (var i = this.feedIndex + 1; i < this.provider.total; i++) {
          this._setReadStatus([], 1, feedIndex: i);
        }
        List<int> articleIndexList = [];
        for (var i = articleIndex + 1;
            i < this.articlesInFeed.feedArticles.length;
            i++) {
          articleIndexList.add(i);
        }
        if (articleIndexList.isNotEmpty) {
          this._setReadStatus(articleIndexList, 1);
        }
      }

      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          children: [
            // 上面的文章标记为已读
            SimpleDialogOption(
              onPressed: () {
                _batchSetRead(true);
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_upward)
                      .iconColor(Tool().colorFromHex("#f5712c")),
                  Text('将以上文章全部标记为已读').fontSize(16),
                ],
              ),
            ),
            // 下面的文章标记为已读
            SimpleDialogOption(
              onPressed: () {
                _batchSetRead(false);
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_downward)
                      .iconColor(Tool().colorFromHex("#f5712c")),
                  Text('将以下文章全部标记为已读').fontSize(16),
                ],
              ).padding(top: 10),
            ),
          ],
        );
      },
    );
  }

  // 生成单 Feed 下的文章流
  List<Widget> _getArticleTile(BuildContext context) {
    List<Widget> articleList = [];
    this.articlesInFeed.feedArticles.asMap().forEach(
      (index, Article article) {
        int articleId = article.id;
        Widget articleWidget = ArticleItem(
          this.feedIndex,
          index,
          provider,
        );
        articleList.add(articleWidget);
      },
    );

    // 当 Feed 的文章超过 3 篇时，后面的文章收起
    return this.articlesInFeed.feedArticles.length > 3
        ? [
            // 前三篇文章
            Column(
              children: articleList.sublist(0, 3),
            ),
            Divider(
              height: 0,
              indent: 20,
              endIndent: 20,
            ),
            // 第三篇之后的展开收起文章组件
            ExpansionArticles(articleList.sublist(3)),
          ]
        : articleList;
  }

  // 单篇文章
  Widget getArticleItem(BuildContext context) {
    Widget a = <Widget>[
      <Widget>[
        Text("2021-04-01 16:52")
            .fontSize(24.rpx)
            .textColor(Tool().colorFromHex("#E87E04"))
            .padding(bottom: 20.rpx),
        Text("学生利器：微软为 Edge 浏览器稳定版新增数学求解器功能")
            .fontSize(32.rpx)
            .bold()
            .width(454.rpx)
            .padding(bottom: 20.rpx),
        Text("IT之家 4 月 30 日消息 上个月，微软在其 Edge 浏览器中宣布了一项新的“Math Solver”（数学求解器）功能…")
            .fontSize(24.rpx)
            .width(454.rpx),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      CachedNetworkImage(
        imageUrl:
            "https://picgo-1253786286.cos.ap-guangzhou.myqcloud.com/image/1620923765.png",
        fit: BoxFit.fill,
      ).clipRRect(all: 8.rpx).constrained(height: 180.rpx, width: 180.rpx)
    ]
        .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start)
        .gestures(onTap: () {
      Application.router.navigateTo(
        context,
        '/articleDetail?articleId=1884412',
        transition: TransitionType.cupertino,
      );
    }).padding(bottom: 40.rpx);
    List<Widget> aritcleList = [a, a, a, a, a];
    return aritcleList.toColumn();
  }

  @override
  Widget build(BuildContext context) {
    print('build' + this.articlesInFeed.feedTitle + feedIndex.toString());
    return Container(
            padding: EdgeInsets.all(30.rpx),
            child: <Widget>[
              Text(this.articlesInFeed.feedTitle)
                  .fontSize((52.rpx))
                  .fontWeight(FontWeight.w900)
                  .textColor(
                    Tool().colorFromHex("#D35400"),
                  )
                  .padding(bottom: 40.rpx),
              this._getArticleTile(context).toColumn(),
            ]
                .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                .alignment(Alignment.centerLeft))
        .decorated()
        .padding(bottom: 80.rpx);
  }
}
