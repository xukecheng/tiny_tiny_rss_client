import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fluro/fluro.dart';

import 'ArticleItem.dart';
import 'FeedItemExpansion.dart';

import '../../Tool/Tool.dart';
import '../../Object/TinyTinyRss.dart';
import '../../Routers/Application.dart';

class FeedItem extends StatefulWidget {
  FeedItem({
    Key key,
    this.feedId,
    this.feedTitle,
    this.feedIcon,
    this.feedArticles,
    this.unreadArticleList,
    this.callBack,
  }) : super(key: key);
  final int feedId;
  final String feedIcon;
  final String feedTitle;
  final List<Map> feedArticles;
  final unreadArticleList;
  final callBack;

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  List<Map> feedArticles = [];

  // Feed 下标记全部已读
  void _markFeedRead() {
    List feedArticlesId = [];
    widget.feedArticles.forEach((article) {
      feedArticlesId.add(article['id']);
      setState(() {
        article['isRead'] = 1;
      });
    });
    TinyTinyRss().markRead(feedArticlesId);
  }

  // 长按文章的菜单栏
  void _longPressArticle(int id) {
    void markRead(bool isUp) {
      print(widget.unreadArticleList);
      List markReadIdList = [];
      // 编译当前所有未读列表获取 Feed
      for (Map feed in isUp
          ? widget.unreadArticleList
          : widget.unreadArticleList.reversed) {
        // 判断 Feed 是否为当前 Feed
        if (feed['feedId'] != widget.feedId) {
          // 不为当前 Feed，遍历所有文章标记为已读
          for (Map article
              in isUp ? feed['feedArticles'] : feed['feedArticles'].reversed) {
            markReadIdList.add(article['id']);
            setState(() {
              article['isRead'] = 1;
            });
          }
        } else {
          // 为当前 Feed，筛选出不是选择文章上面或下面标记为已读
          for (Map article
              in isUp ? feed['feedArticles'] : feed['feedArticles'].reversed) {
            if (article['id'] != id) {
              markReadIdList.add(article['id']);
              setState(() {
                article['isRead'] = 1;
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
      widget.callBack(widget.unreadArticleList);
      TinyTinyRss().markRead(markReadIdList);
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
  List<Widget> _getArticleTile() {
    List<Widget> articles = widget.feedArticles.map(
      (article) {
        int articleId = article['id'];

        // 接收子组件回调，更新已读和收藏状态
        void onChanged(Map<String, int> value) {
          setState(() {
            article['isRead'] = value["isRead"];
            article['isStar'] = value["isStar"];
            TinyTinyRss().markRead([articleId], isRead: value["isRead"]);
            TinyTinyRss().markStar(articleId, value["isStar"]);
          });
        }

        return InkWell(
          onTap: () {
            setState(() {
              TinyTinyRss().markRead([articleId]);
              article['isRead'] = 1;
            });
            // 点击跳转详情页
            Application.router.navigateTo(
              context,
              '/articleDetail?articleId=$articleId',
              transition: TransitionType.cupertino,
            );
          },
          onLongPress: () => this._longPressArticle(article['id']),
          child: ArticleItem(
            id: article['id'],
            title: article['title'],
            isRead: article['isRead'],
            isStar: article['isStar'],
            description: article['description'],
            flavorImage: article['flavorImage'],
            publishTime: Tool().timestampToDate(article['publishTime']),
            callBack: (Map<String, int> value) => onChanged(value),
          ),
        );
      },
    ).toList();

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
                onPressed: () => this._markFeedRead(),
              ),
            ],
          ).height(60).padding(left: 15, right: 15),
          Divider(
            height: 0,
          ),
          // Feed 下的文章列表
          Column(children: this._getArticleTile()),
        ].toColumn(),
      ).padding(left: 10, top: 10, right: 10, bottom: 10),
    ].toColumn();
  }
}
