import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';

import '../../Data/database.dart';
import '../../Model/ArticleModel.dart';
import '../../Tool/Tool.dart';

class ArticleItem extends StatelessWidget {
  ArticleItem(
    this.feedIndex,
    this.articleIndex,
    this.provider,
  );
  final int feedIndex;
  final int articleIndex;
  final ArticleModel provider;

  void _markRead(int isRead) {
    int needReadStatus = isRead == 1 ? 0 : 1;
    provider.setReadStatus(feedIndex, [articleIndex], needReadStatus);
  }

  void _markStar(int isStar) {
    int needStarStatus = isStar == 1 ? 0 : 1;
    provider.setStarStatus(feedIndex, articleIndex, needStarStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ArticleModel, Article>(
        selector: (context, provider) =>
            provider.getData[this.feedIndex].feedArticles[this.articleIndex],
        builder: (context, data, child) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                // 文章组件主体
                <Widget>[
                  // 文章文本信息组件
                  Expanded(
                    flex: 5,
                    child: <Widget>[
                      // 文章标题
                      Text(
                        data.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                          .fontSize(16)
                          .bold()
                          .textColor(
                              data.isRead == 1 ? Colors.grey : Colors.black)
                          .padding(top: 12, bottom: 14),
                      // 文章描述
                      Visibility(
                        visible: data.description.isEmpty ? false : true,
                        child: Text(data.description).fontSize(14).textColor(
                            data.isRead == 1 ? Colors.grey : Colors.black),
                      ).padding(bottom: 8),
                      Text(Tool().timestampToDate(data.publishTime))
                          .fontSize(12)
                          .textColor(Colors.black45)
                          .padding(vertical: 10)
                          .alignment(Alignment.bottomLeft),
                    ]
                        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                        .padding(left: 15, right: 15),
                  ),
                  // 文章预览图展示
                  Visibility(
                    // 判断预览图是否存在
                    visible: data.flavorImage.isEmpty ? false : true,
                    child: Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        imageUrl: data.flavorImage,
                        fit: BoxFit.cover,
                      ).padding().height(175),
                    ),
                  )
                ].toRow(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                // 分隔线
                Divider(
                  height: 1.0,
                  color: Colors.black26,
                ),
              ],
            ),
            actions: <Widget>[
              IconSlideAction(
                  caption: data.isRead == 1 ? '未读' : '已读',
                  color: Colors.blue,
                  icon: Icons.archive,
                  onTap: () => this._markRead(data.isRead)),
              IconSlideAction(
                caption: '收藏',
                color: Colors.red,
                icon: data.isStar == 1 ? Icons.favorite : Icons.favorite_border,
                onTap: () => this._markStar(data.isStar),
              ),
            ],
          );
        });
  }
}
