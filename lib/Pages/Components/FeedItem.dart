import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fluro/fluro.dart';

import 'ArticleItem.dart';
import 'FeedItemExpansion.dart';

import '../../Tool/Tool.dart';
import '../../Data/database.dart';
import '../../Model/ArticleStatusModel.dart';
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
        print(articleIndexList);

        /// 如果当前 Feed 中需要已读的文章列表为空，则不设置已读，
        /// 防止出现选择第一篇文章以上已读，却导致当前 Feed 全部已读
        if (articleIndexList.isNotEmpty) {
          this._setReadStatus(articleIndexList, 1);
        }
      } else {
        // 以下全部已读

        // 获取当前 Feed 以下的 Feed，设置为全部已读
        for (var i = this.feedIndex + 1; i > this.provider.total; i++) {
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
        Widget articleWidget = InkWell(
          onTap: () {
            this._setReadStatus([index], 1);
            // 点击跳转详情页
            Application.router.navigateTo(
              context,
              '/articleDetail?articleId=$articleId',
              transition: TransitionType.cupertino,
            );
          },
          onLongPress: () => this._longPress(context, index),
          child: ArticleItem(
            this.feedIndex,
            index,
            provider,
          ),
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

  @override
  Widget build(BuildContext context) {
    print('build' + this.articlesInFeed.feedTitle + feedIndex.toString());
    return <Widget>[
      Card(
        child: <Widget>[
          // 卡片顶部 -> Feed 信息
          Flex(
            direction: Axis.horizontal,
            children: [
              // Feed Icon
              Expanded(
                flex: 1,
                child: CachedNetworkImage(
                  imageUrl: this.articlesInFeed.feedIcon,
                  fit: BoxFit.fill,
                ).clipOval().width(28).height(28),
              ),
              // Feed 标题
              Expanded(
                flex: 10,
                child: Text(
                  this.articlesInFeed.feedTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
                    .fontSize(16)
                    .fontWeight(FontWeight.w600)
                    .textColor(Colors.blueGrey[700]!)
                    .padding(left: 10),
              ),
              // 全部已读 Icon
              IconButton(
                icon: Icon(Icons.done_all)
                    .iconColor(Tool().colorFromHex("#f5712c")),
                onPressed: () => this._setReadStatus([], 1),
              ),
            ],
          ).height(60).padding(left: 15, right: 15),
          Divider(
            height: 0,
          ),
          // Feed 下的文章列表
          Column(children: this._getArticleTile(context)),
        ].toColumn(),
      ).padding(left: 10, top: 10, right: 10, bottom: 10),
    ].toColumn();
  }
}
