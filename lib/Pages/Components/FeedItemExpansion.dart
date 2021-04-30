import 'package:flutter/material.dart';

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
