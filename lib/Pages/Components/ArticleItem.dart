import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';

import '../../Data/database.dart';
import '../../Model/ArticleModel.dart';
import '../../Tool/Tool.dart';
import '../../Tool/SizeCalculate.dart';
import '../../Extension/Int.dart';
import '../../Routers/Application.dart';

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
            child: <Widget>[
              <Widget>[
                Text(Tool().timestampToDate(data.publishTime))
                    .fontSize(24.rpx)
                    .textColor(Tool().colorFromHex("#E87E04"))
                    .padding(bottom: 20.rpx),
                Text(data.title, overflow: TextOverflow.ellipsis, maxLines: 2)
                    .fontSize(32.rpx)
                    .bold()
                    .width(data.flavorImage.isEmpty
                        ? SizeCalculate.screenWidth - 60.rpx
                        : 454.rpx)
                    .padding(bottom: 20.rpx),
                Visibility(
                  visible: data.description.isEmpty ? false : true,
                  child: Text(data.description).fontSize(24.rpx).width(
                      data.flavorImage.isEmpty
                          ? SizeCalculate.screenWidth - 60.rpx
                          : 454.rpx),
                )
              ].toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Visibility(
                  visible: data.flavorImage.isEmpty ? false : true,
                  child: CachedNetworkImage(
                    imageUrl: data.flavorImage,
                    fit: BoxFit.fill,
                  )
                      .clipRRect(all: 8.rpx)
                      .constrained(height: 180.rpx, width: 180.rpx))
            ]
                .toRow(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start)
                .gestures(
                    onTap: () {
                      Application.router.navigateTo(
                        context,
                        '/articleDetail?articleId=${data.id}',
                        transition: TransitionType.cupertino,
                      );
                    },
                    onLongPress: () {})
                .padding(bottom: 40.rpx),
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
