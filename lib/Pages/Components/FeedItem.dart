import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Tool/Tool.dart';
import '../ArticleDetail.dart';
import '../../Object/TinyTinyRss.dart';
import 'ArticleItem.dart';

class FeedItem extends StatefulWidget {
  FeedItem({Key key, this.feedTitle, this.feedIcon, this.feedArticles})
      : super(key: key);
  final String feedIcon;
  final String feedTitle;
  final List<Map> feedArticles;

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  List<Map> feedArticles = new List();
  @override
  void initState() {
    super.initState();
    this.feedArticles = widget.feedArticles;
  }

  // Feed 下标记全部已读
  void _markFeedRead() {
    List feedArticlesId = new List();
    this.feedArticles.forEach((article) {
      feedArticlesId.add(article['id']);
      setState(() {
        article['isRead'] = 1;
      });
    });
    TinyTinyRss().markRead(feedArticlesId);
  }

  void _longPressArticle(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          children: [
            SimpleDialogOption(
              onPressed: () {
                List feedArticlesId = new List();
                for (Map article in this.feedArticles) {
                  if (article['id'] != id) {
                    feedArticlesId.add(article['id']);
                    setState(() {
                      article['isRead'] = 1;
                    });
                  } else {
                    break;
                  }
                }
                TinyTinyRss().markRead(feedArticlesId);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_upward),
                  Text(
                    '将以上文章全部标记为已读',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                List feedArticlesId = new List();
                for (Map article in this.feedArticles.reversed) {
                  if (article['id'] != id) {
                    feedArticlesId.add(article['id']);
                    setState(() {
                      article['isRead'] = 1;
                    });
                  } else {
                    break;
                  }
                }
                TinyTinyRss().markRead(feedArticlesId);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_downward),
                  Text(
                    '将以下文章全部标记为已读',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 生成单 Feed 下的文章流和文章跳转
  List<Widget> _getArticleTile() {
    setState(() {
      this.feedArticles = widget.feedArticles;
    });
    List<Widget> articles = this.feedArticles.map(
      (article) {
        return InkWell(
          onTap: () {
            setState(() {
              List markReadArticleIdList = new List();
              markReadArticleIdList.add(
                article['id'],
              );
              TinyTinyRss().markRead(markReadArticleIdList);
              article['isRead'] = 1;
            });
            // 点击跳转详情页
            Navigator.of(context).push(
              MaterialPageRoute(
                //传值
                builder: (context) => ArticleDetail(
                    title: article['title'],
                    htmlContent: article['htmlContent'],
                    articleOriginLink: article['articleOriginLink']),
              ),
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
    return this.feedArticles.length > 3
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
            // 第三篇之后的文章
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
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      // Feed 标题
                      child: Text(
                        widget.feedTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[700]),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.done),
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

// 第三篇之后的展开收起文章组件
class ExpansionArticles extends StatefulWidget {
  ExpansionArticles({Key key, this.articles}) : super(key: key);
  // 接收第三篇之后的所有文章
  final List<Widget> articles;

  @override
  _ExpansionArticlesState createState() => _ExpansionArticlesState();
}

class _ExpansionArticlesState extends State<ExpansionArticles> {
  // 默认收起
  bool expandedStatus = false;
  @override
  Widget build(BuildContext context) {
    // 用 ClipRect 剪裁 ExpansionPanelList，用于去除边框阴影
    return ClipRect(
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.white),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              this.expandedStatus = !this.expandedStatus;
            });
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: isExpanded ? Text("收起") : Text("展开"),
                );
              },
              body: Column(
                children: widget.articles,
              ),
              isExpanded: this.expandedStatus,
            )
          ],
        ),
      ),
    );
  }
}
