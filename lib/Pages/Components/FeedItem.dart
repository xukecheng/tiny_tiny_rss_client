import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'ArticleItem.dart';
import 'FeedItemExpansion.dart';

import '../../Tool/Tool.dart';
import '../../Object/database.dart';
import '../../Routers/Application.dart';

class FeedItem extends StatefulWidget {
  FeedItem({
    Key key,
    this.feedId,
    this.feedTitle,
    this.feedIcon,
    this.feedArticles,
    this.articlesInfeeds,
    this.callBack,
  }) : super(key: key);
  final int feedId;
  final String feedIcon;
  final String feedTitle;
  final List<Article> feedArticles;
  final articlesInfeeds;
  final callBack;

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  // List<ArticlesInFeed> unreadArticleList = [];
  List<Article> feedArticles = [];

  @override
  void initState() {
    super.initState();
    // this.unreadArticleList = widget.articlesInfeeds;
    this.feedArticles = widget.feedArticles;
  }

  // Feed 下标记全部已读
  void _markFeedRead(AppDatabase database) {
    List feedArticlesId = [];
    this.feedArticles.forEach((article) {
      feedArticlesId.add(article.id);
      setState(() {
        article = article.copyWith(isRead: 1);
      });
    });
    database.markRead(idList: feedArticlesId);
  }

  // 长按文章的菜单栏
  void _longPressArticle(int id, AppDatabase database) {
    void markRead(bool isUp) {
      List markReadIdList = [];
      // 编译当前所有未读列表获取 Feed
      for (ArticlesInFeed feed
          in isUp ? widget.articlesInfeeds : widget.articlesInfeeds.reversed) {
        // 判断 Feed 是否为当前 Feed
        if (feed.id != widget.feedId) {
          // 不为当前 Feed，遍历所有文章标记为已读
          for (Article article
              in isUp ? feed.feedArticles : feed.feedArticles.reversed) {
            markReadIdList.add(article.id);
            setState(() {
              // article.isRead = 1;
            });
          }
        } else {
          // 为当前 Feed，筛选出不是选择文章上面或下面标记为已读
          for (Article article
              in isUp ? feed.feedArticles : feed.feedArticles.reversed) {
            if (article.id != id) {
              markReadIdList.add(article.id);
              setState(() {
                // article.isRead = 1;
              });
            } else {
              // 停止寻找当前 Feed 更多文章
              break;
            }
          }
          // 停止寻找更多 Feed
          break;
        }
      }
      widget.callBack(widget.articlesInfeeds);
      database.markRead(idList: markReadIdList);
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
                markRead(true);
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
                markRead(false);
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
  List<Widget> _getArticleTile(AppDatabase database) {
    List<Widget> articles = widget.feedArticles.map(
          (Article article) {
            int articleId = article.id;

            // 接收子组件回调，更新已读和收藏状态
            void onChanged(Map<String, int> value) {
              setState(() {
                article = article.copyWith(
                    isRead: value["isRead"], isStar: value["isStar"]);
                database.markRead(idList: [articleId], isRead: value["isRead"]);
                database.markStar(id: articleId, isStar: value["isStar"]);
              });
            }

            return InkWell(
              onTap: () {
                setState(() {
                  database.markRead(idList: [articleId]);
                  article = article.copyWith(isRead: 1);
                });
                // 点击跳转详情页
                Application.router.navigateTo(
                  context,
                  '/articleDetail?articleId=$articleId',
                  transition: TransitionType.cupertino,
                );
              },
              onLongPress: () => this._longPressArticle(article.id, database),
              child: ArticleItem(
                id: article.id,
                title: article.title,
                isRead: article.isRead,
                isStar: article.isStar,
                description: article.description,
                flavorImage: article.flavorImage,
                publishTime: Tool().timestampToDate(article.publishTime),
                callBack: (Map<String, int> value) => onChanged(value),
              ),
            );
          },
        ).toList() ??
        [];

    // 当 Feed 的文章超过 3 篇时，后面的文章收起
    return widget.feedArticles.length > 3
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
                  imageUrl: widget.feedIcon,
                  fit: BoxFit.fill,
                ).clipOval().width(28).height(28),
              ),
              // Feed 标题
              Expanded(
                flex: 10,
                child: Text(
                  widget.feedTitle,
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
                onPressed: () => this._markFeedRead(database),
              ),
            ],
          ).height(60).padding(left: 15, right: 15),
          Divider(
            height: 0,
          ),
          // Feed 下的文章列表
          Column(children: this._getArticleTile(database)),
        ].toColumn(),
      ).padding(left: 10, top: 10, right: 10, bottom: 10),
    ].toColumn();
  }
}
