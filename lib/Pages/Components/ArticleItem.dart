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

  Widget _getArticlePublishTime(int publishTime) {
    return Text(Tool().timestampToDate(publishTime))
        .fontSize(24.rpx)
        .textColor(Tool().colorFromHex("#E87E04"))
        .padding(bottom: 20.rpx);
  }

  Widget _getArticleTitle(String title, bool hasImage, int isRead) {
    return Text(title, overflow: TextOverflow.ellipsis, maxLines: 2)
        .fontSize(32.rpx)
        .textColor(isRead == 1 ? Tool().colorFromHex("858585") : Colors.black)
        .bold()
        .width(hasImage ? 454.rpx : SizeCalculate.screenWidth - 60.rpx)
        .padding(bottom: 20.rpx);
  }

  Widget _getArticleDesc(String description, bool hasImage) {
    return Visibility(
      visible: description.isNotEmpty ? true : false,
      child: Text(description)
          .fontSize(24.rpx)
          .width(hasImage ? 454.rpx : SizeCalculate.screenWidth - 60.rpx),
    );
  }

  Widget _getArticleText(String title, String description, int publishTime,
      bool hasImage, int isRead) {
    return <Widget>[
      this._getArticlePublishTime(publishTime),
      this._getArticleTitle(title, hasImage, isRead),
      this._getArticleDesc(description, hasImage)
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Widget _getArticleImage(String flavorImage, bool hasImage) {
    return Visibility(
      visible: hasImage ? true : false,
      child: CachedNetworkImage(
        imageUrl: flavorImage,
        fit: BoxFit.fill,
      ).clipRRect(all: 8.rpx).constrained(height: 180.rpx, width: 180.rpx),
    );
  }

  Widget _getArticleItem(BuildContext context, Article data, bool hasImage) {
    return <Widget>[
      this._getArticleText(data.title, data.description, data.publishTime,
          hasImage, data.isRead),
      this._getArticleImage(data.flavorImage, hasImage)
    ]
        .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start)
        .gestures(
            onTap: () => this._toArticleDetail(context, data.id),
            onLongPress: () => this._longPress(
                  context,
                ))
        .padding(bottom: 40.rpx);
  }

  Widget _getLongPressDialog(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      children: [
        // 上面的文章标记为已读
        SimpleDialogOption(
          child: <Widget>[
            Icon(Icons.arrow_upward).iconColor(Tool().colorFromHex("#f5712c")),
            Text('将以上文章全部标记为已读').fontSize(16),
          ].toRow(),
        ).gestures(onTap: () => this._batchSetRead(context, true)),
        // 下面的文章标记为已读
        SimpleDialogOption(
          child: <Widget>[
            Icon(Icons.arrow_downward)
                .iconColor(Tool().colorFromHex("#f5712c")),
            Text('将以下文章全部标记为已读').fontSize(16),
          ].toRow().padding(top: 10),
        ).gestures(onTap: () => this._batchSetRead(context, false)),
      ],
    );
  }

  List<Widget> _getArticleSlideItem(int isRead, int isStar) {
    return <Widget>[
      IconSlideAction(
          icon: isRead == 1 ? Icons.undo : Icons.done,
          onTap: () =>
              this._setReadStatus([this.articleIndex], isRead == 1 ? 0 : 1)),
      IconSlideAction(
        foregroundColor: Colors.red,
        icon: isStar == 1 ? Icons.favorite : Icons.favorite_border,
        onTap: () => provider.setStarStatus(
            this.feedIndex, this.articleIndex, isStar == 1 ? 0 : 1),
      ),
    ];
  }

  void _toArticleDetail(BuildContext context, int id) {
    Application.router.navigateTo(
      context,
      '/articleDetail?articleId=$id',
      transition: TransitionType.cupertino,
    );
    this._setReadStatus([this.articleIndex], 1);
  }

  void _setReadStatus(List<int> articleIndexList, int needReadStatus,
      {int? feedIndex}) {
    this.provider.setReadStatus(
          feedIndex != null ? feedIndex : this.feedIndex,
          articleIndexList,
          needReadStatus,
        );
  }

  void _batchSetRead(BuildContext context, bool isUp) {
    List<int> articleIndexList = [];
    List<int> feedIndexList = [];
    // 以上全部已读
    if (isUp) {
      feedIndexList = List<int>.generate(this.feedIndex, (i) => i);
      articleIndexList = List<int>.generate(this.articleIndex, (i) => i);
    } else {
      // 以下全部已读
      feedIndexList = [
        for (var i = this.feedIndex + 1; i < this.provider.total; i++) i
      ];
      articleIndexList = [
        for (var i = this.articleIndex + 1;
            i < provider.getData[this.feedIndex].feedArticles.length;
            i++)
          i
      ];
    }

    feedIndexList
        .forEach((index) => this._setReadStatus([], 1, feedIndex: index));

    /// 如果当前 Feed 中需要已读的文章列表为空，则不设置已读，
    /// 防止出现选择第一篇文章以上已读，却导致当前 Feed 全部已读
    if (articleIndexList.isNotEmpty) {
      this._setReadStatus(articleIndexList, 1);
    }
    Navigator.pop(context);
  }

  void _longPress(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this._getLongPressDialog(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ArticleModel, Article>(
        selector: (context, provider) =>
            provider.getData[this.feedIndex].feedArticles[this.articleIndex],
        builder: (context, data, child) {
          bool hasImage = data.flavorImage.isNotEmpty;
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: this._getArticleItem(context, data, hasImage),
            actions: this._getArticleSlideItem(data.isRead, data.isStar),
          );
        });
  }
}
