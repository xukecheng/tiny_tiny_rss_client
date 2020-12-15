import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Tool/Tool.dart';
import '../ArticleDetail.dart';
import '../../Object/TinyTinyRss.dart';
import 'ArticleItem.dart';

class FeedItem extends StatelessWidget {
  FeedItem({this.feedTitle, this.feedIcon, this.feedArticles});

  final String feedIcon;
  final String feedTitle;
  final List<Map> feedArticles;

  List<Widget> _getArticleTile() {
    List<Widget> articles = this.feedArticles.map(
      (article) {
        // 生成单 Feed 下的文章流和文章跳转，以及用 StatefulBuilder 修改每篇文章的阅读状态

        // 不能在子组件 ArticleItem 里进行阅读状态修改，因为滑动时，Flutter 会销毁已经生
        // 成的 ArticleItem 组件，导致回到条目时，组件是新生成的，而父组件的值此时并没有被改变
        return StatefulBuilder(builder: (BuildContext context, setState) {
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
                      articleTitle: article['title'],
                      articleContent: article['htmlContent']),
                ),
              );
            },
            child: ArticleItem(
                articleId: article['id'],
                articleTitle: article['title'],
                isRead: article['isRead'],
                articleDesciption: article['description'],
                flavorImage: article['flavorImage'],
                publishTime: Tool().timestampToDate(article['publishTime']),
                htmlContent: article['htmlContent']),
          );
        });
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
              child: Row(
                children: [
                  // Feed Icon
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: this.feedIcon,
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                  ),
                  // Feed 标题
                  Text(
                    this.feedTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[700]),
                  )
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

// 第三篇之后的文章组件，因为要控制展开收起，所以只能是有状态
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
                isExpanded: this.expandedStatus)
          ],
        ),
      ),
    );
  }
}
