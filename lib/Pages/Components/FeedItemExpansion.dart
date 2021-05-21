import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../Tool/Tool.dart';
import '../../Extension/Int.dart';

class ExpansionArticles extends StatefulWidget {
  ExpansionArticles(this.articleList);
  // 接收第三篇之后的所有文章
  final List<Widget> articleList;

  @override
  _ExpansionArticlesState createState() => _ExpansionArticlesState();
}

class _ExpansionArticlesState extends State<ExpansionArticles> {
  // 默认收起
  bool expandedStatus = false;

  Widget _getButtonContent() {
    return <Widget>[
      Text(this.expandedStatus ? 'Hide More' : 'Read More')
          .textColor(Colors.white)
          .bold()
          .padding(left: 48.rpx),
      Icon(this.expandedStatus ? Icons.expand_less : Icons.expand_more)
          .iconColor(Colors.white)
          .padding(right: 48.rpx)
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .center()
        .backgroundColor(Tool().colorFromHex("F89406"))
        .clipRRect(all: 800.rpx)
        .constrained(width: 280.rpx, height: 75.rpx)
        .alignment(Alignment.center)
        .gestures(onTap: () {
      setState(() {
        this.expandedStatus = !this.expandedStatus;
      });
    });
  }

  Widget _getExpandArticle() {
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          axisAlignment: 4,
          axis: Axis.vertical,
          sizeFactor: animation,
          child: child,
        );
      },
      child: expandedStatus
          ? widget.articleList.toColumn().padding(top: 60.rpx)
          : Container(),
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      this._getButtonContent(),
      this._getExpandArticle(),
    ].toColumn();
  }
}
