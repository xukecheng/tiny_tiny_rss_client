import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:styled_widget/styled_widget.dart';

class ArticleItem extends StatelessWidget {
  ArticleItem({
    this.id,
    this.title,
    this.isRead,
    this.isStar,
    this.description,
    this.flavorImage,
    this.publishTime,
    this.callBack,
  });

  final int id;
  final String title;
  final int isRead;
  final int isStar;
  final String description;
  final String flavorImage;
  final String publishTime;
  final callBack;

  void _markRead() {
    int isReadStatus = this.isRead == 1 ? 0 : 1;
    this.callBack({"isRead": isReadStatus, "isStar": this.isStar});
  }

  void _markStar() {
    int isStarStatus = this.isStar == 1 ? 0 : 1;
    this.callBack({"isRead": this.isRead, "isStar": isStarStatus});
  }

  @override
  Widget build(BuildContext context) {
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
                  this.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
                    .fontSize(16)
                    .bold()
                    .textColor(isRead == 1 ? Colors.grey : Colors.black)
                    .padding(top: 12, bottom: 14),
                // 文章描述
                Visibility(
                  visible: this.description.isEmpty ? false : true,
                  child: Text(this.description)
                      .fontSize(14)
                      .textColor(isRead == 1 ? Colors.grey : Colors.black),
                ).padding(bottom: 8),
                Text(this.publishTime)
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
              visible: this.flavorImage.isEmpty ? false : true,
              child: Expanded(
                flex: 2,
                child: CachedNetworkImage(
                  imageUrl: this.flavorImage,
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
          caption: this.isRead == 1 ? '未读' : '已读',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => this._markRead(),
        ),
        IconSlideAction(
          caption: '收藏',
          color: Colors.red,
          icon: this.isStar == 1 ? Icons.favorite : Icons.favorite_border,
          onTap: () => this._markStar(),
        ),
      ],
    );
  }
}
