import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  void initState() {
    super.initState();
    this.feedArticles = widget.feedArticles;
  }

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

    // void markRead() {
    //   List feedArticlesId = [];
    //   for (Map article in widget.feedArticles) {
    //     if (article['id'] == id) {
    //       feedArticlesId.add(article['id']);
    //       setState(() {
    //         article['isRead'] = isRead == 0 ? 1 : 0;
    //       });
    //     }
    //   }
    //   TinyTinyRss().markRead(feedArticlesId, isRead: isRead);
    // }

    // void markStar() {
    //   for (Map article in widget.feedArticles) {
    //     if (article['id'] == id) {
    //       setState(() {
    //         article['isStar'] = isStar == 0 ? 1 : 0;
    //       });
    //     }
    //   }
    //   TinyTinyRss().markStar(id, isStar);
    // }

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
                  Icon(
                    Icons.arrow_upward,
                    color: Tool().colorFromHex("#f5712c"),
                  ),
                  Text(
                    '将以上文章全部标记为已读',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            // 下面的文章标记为已读
            SimpleDialogOption(
              onPressed: () {
                markRead(false);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: Tool().colorFromHex("#f5712c"),
                  ),
                  Text(
                    '将以下文章全部标记为已读',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
          ],
        );
      },
    );
  }

  // 生成单 Feed 下的文章流
  List<Widget> _getArticleTile() {
    setState(() {
      this.feedArticles = widget.feedArticles;
    });
    List<Widget> articles = widget.feedArticles.map(
      (article) {
        int articleId = article['id'];
        return InkWell(
          onTap: () {
            setState(() {
              List markReadArticleIdList = [];
              markReadArticleIdList.add(
                articleId,
              );
              TinyTinyRss().markRead(markReadArticleIdList);
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
            description: article['description'],
            flavorImage: article['flavorImage'],
            publishTime: Tool().timestampToDate(article['publishTime']),
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
    return Column(children: [
      Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            // 卡片顶部 -> Feed 信息
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              height: 60,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  // Feed Icon
                  Expanded(
                    flex: 1,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.feedIcon,
                        width: 28,
                        height: 28,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Feed 标题
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.feedTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[700],
                        ),
                      ),
                    ),
                  ),
                  // 全部已读 Icon
                  IconButton(
                    icon: Icon(
                      Icons.done_all,
                      color: Tool().colorFromHex("#f5712c"),
                    ),
                    onPressed: () {
                      this._markFeedRead();
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            // Feed 下的文章列表
            Column(children: this._getArticleTile()),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
      ),
    ]);
  }
}
