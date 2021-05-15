import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import 'ArticleItem.dart';
import 'FeedItemExpansion.dart';

import '../../Tool/Tool.dart';
import '../../Extension/Int.dart';
import '../../Data/database.dart';
import '../../Model/ArticleModel.dart';

class FeedItem extends StatelessWidget {
  FeedItem(this.feedIndex, this.articlesInFeed, this.provider);
  final int feedIndex;
  final ArticlesInFeed articlesInFeed;
  final ArticleModel provider;

  // Feed 下标记已读
  // void _setReadStatus(List<int> articleIndexList, int isRead,
  //     {int? feedIndex}) {
  //   this.provider.setReadStatus(
  //         feedIndex != null ? feedIndex : this.feedIndex,
  //         articleIndexList,
  //         isRead,
  //       );
  // }

  Widget _getFeedTitle() {
    return Text(this.articlesInFeed.feedTitle)
        .fontSize((52.rpx))
        .fontWeight(FontWeight.w900)
        .textColor(
          Tool().colorFromHex("#D35400"),
        )
        .padding(bottom: 40.rpx);
  }

  // 生成单 Feed 下的文章流
  List<Widget> _getFeedArticle() {
    List<Widget> articleList = [];
    this.articlesInFeed.feedArticles.asMap().forEach(
      (index, Article article) {
        Widget articleWidget = ArticleItem(
          this.feedIndex,
          index,
          provider,
        );
        articleList.add(articleWidget);
      },
    );

    // 当 Feed 的文章超过 3 篇时，后面的文章收起
    return articleList.length > 3
        ? [
            articleList[0],
            articleList[1],
            articleList[2],
            // 第三篇之后的展开收起文章组件
            ExpansionArticles(articleList.sublist(3)).padding(top: 40.rpx),
          ]
        : articleList;
  }

  List<Widget> _buildFeedItem(BuildContext context) {
    List<Widget> feedItem = [this._getFeedTitle()];
    feedItem.addAll(this._getFeedArticle());
    return feedItem;
  }

  @override
  Widget build(BuildContext context) {
    print('build' + this.articlesInFeed.feedTitle + feedIndex.toString());
    return Container(
            padding: EdgeInsets.all(30.rpx),
            child: this
                ._buildFeedItem(context)
                .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                .alignment(Alignment.centerLeft))
        .decorated()
        .padding(bottom: 80.rpx);
  }
}
