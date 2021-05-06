import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

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
  void _setReadStatus(
      AppDatabase database, List<int> articleIndexList, int isRead,
      {int feedIndex}) {
    List<int> articleIdList = [];
    if (articleIndexList == []) {
      this.articlesInFeed.feedArticles.forEach((article) {
        articleIdList.add(article.id);
      });
    } else {
      articleIndexList.forEach((articleIndex) {
        articleIdList.add(this.articlesInFeed.feedArticles[articleIndex].id);
      });
    }
    if (feedIndex != null) {
      this.provider.setReadStatus(feedIndex, articleIndexList, isRead);
      database.markRead(idList: articleIdList, isRead: isRead);
    } else {
      this.provider.setReadStatus(this.feedIndex, articleIndexList, isRead);
      database.markRead(idList: articleIdList, isRead: isRead);
    }
  }

  void _longPress(
      AppDatabase database, BuildContext context, int articleIndex) {
    void _batchSetRead(bool isUp) {
      if (isUp) {
        for (var i = 0; i < feedIndex; i++) {
          this._setReadStatus(database, [], 1, feedIndex: i);
        }
        List<int> articleIndexList = [];
        for (var i = 0; i < articleIndex; i++) {
          articleIndexList.add(i);
        }
        this._setReadStatus(database, articleIndexList, 1);
      } else {
        for (var i = feedIndex + 1; i > this.provider.total; i++) {
          this._setReadStatus(database, [], 1, feedIndex: i);
        }
        List<int> articleIndexList = [];
        for (var i = articleIndex;
            i < this.articlesInFeed.feedArticles.length;
            i++) {
          articleIndexList.add(i);
        }
        this._setReadStatus(database, articleIndexList, 1);
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
  List<Widget> _getArticleTile(AppDatabase database, BuildContext context) {
    int index = 0;
    List<Widget> articles = this.articlesInFeed.feedArticles.map(
          (Article article) {
            int articleId = article.id;

            return InkWell(
              onTap: () {
                print('点击了：' + index.toString());
                // this._setReadStatus(database, [index], 1);
                this.provider.setReadStatus(this.feedIndex, [index], 1);
                index += 1;
                // 点击跳转详情页
                Application.router.navigateTo(
                  context,
                  '/articleDetail?articleId=$articleId',
                  transition: TransitionType.cupertino,
                );
              },
              onLongPress: () => this._longPress(database, context, index),
              child: ArticleItem(
                id: article.id,
                title: article.title,
                isRead: article.isRead,
                isStar: article.isStar,
                description: article.description,
                flavorImage: article.flavorImage,
                publishTime: Tool().timestampToDate(article.publishTime),
              ),
            );
          },
        ).toList() ??
        [];

    // 当 Feed 的文章超过 3 篇时，后面的文章收起
    return this.articlesInFeed.feedArticles.length > 3
        ? [
            // 前三篇文章
            Column(
              children: articles.sublist(0, 3),
            ),
            Divider(
              height: 0,
              indent: 20,
              endIndent: 20,
            ),
            // 第三篇之后的展开收起文章组件
            ExpansionArticles(articles: articles.sublist(3)),
          ]
        : articles;
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
    print('build' + this.articlesInFeed.feedTitle);
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
                    .textColor(Colors.blueGrey[700])
                    .padding(left: 10),
              ),
              // 全部已读 Icon
              IconButton(
                icon: Icon(Icons.done_all)
                    .iconColor(Tool().colorFromHex("#f5712c")),
                onPressed: () => this._setReadStatus(database, [], 1),
              ),
            ],
          ).height(60).padding(left: 15, right: 15),
          Divider(
            height: 0,
          ),
          // Feed 下的文章列表
          Column(children: this._getArticleTile(database, context)),
        ].toColumn(),
      ).padding(left: 10, top: 10, right: 10, bottom: 10),
    ].toColumn();
  }
}
