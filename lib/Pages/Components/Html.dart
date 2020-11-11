import 'package:html/parser.dart' show parse;
import 'package:flutter/material.dart' as Flutter;
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html_unescape/html_unescape.dart';
// import '../../test1.dart';

var unescape = new HtmlUnescape();

class Html {
  htmlParser(html) {
    List<Flutter.Widget> parserdList = new List();
    Document document = parse(html);
    var nodeList = document.nodes[0].nodes[1].nodes;
    nodeList.forEach((value) {
      // 每一个 Node 查看标签，是否为标题
      if (value.toString() == '<html h2>') {
        parserdList.add(Flutter.Text(unescape.convert(value.text),
            style: TextStyle(fontSize: 22.0)));
      } else if (value.toString() == '<html h2>') {
        parserdList.add(Flutter.Text(unescape.convert(value.text),
            style: TextStyle(fontSize: 20.0)));
      } else if (value.toString() == '<html h2>') {
        parserdList.add(Flutter.Text(unescape.convert(value.text),
            style: TextStyle(fontSize: 18.0)));
      } // 不为标题时，进入递归方法
      else {
        parserdList.add(nodesSplit(value.nodes));
      }
    });
    parserdList.removeWhere((value) => value == null);
    return parserdList;
  }

  nodesSplit(List nodes) {
    List tempList = new List();

    for (var i = 0; i < nodes.length; i++) {
      // nodeType = 3 = Node.TEXT_NODE (Element 或者 Attr 中实际的 文字)
      if (nodes[i].nodeType == 3) {
        tempList.add(Flutter.TextSpan(text: unescape.convert(nodes[i].text)));
      } else if (nodes[i].localName == 'img') {
        tempList.add(CachedNetworkImage(
          imageUrl: nodes[i].attributes['src'],
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
      } else if (nodes[i].localName == 'li') {
        tempList.add(Flutter.Row(
          children: [
            Flutter.Text('\u{2022} '),
            Flutter.RichText(
              text: Flutter.TextSpan(
                text: unescape.convert(nodes[i].text),
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            )
          ],
        ));
      } else if (nodes[i].localName == 'a') {
        tempList.add(Flutter.TextSpan(
          text: unescape.convert(nodes[i].text),
          style: TextStyle(fontSize: 16.0, color: Colors.blue),
          // recognizer: 点击事件
        ));
        print(tempList);
      } else if (nodes[i].localName == 'br') {
        print("跳过 br");
      } else {
        tempList.add(nodesSplit(nodes[i].nodes));
        print(tempList);
      }
    }

    // 尝试将 Widget 从 list 中取出，然后在主 list 中添加 Widget 而非 List。
    try {
      if (tempList[0] is TextSpan) {
        List<Flutter.InlineSpan> spanList = new List();
        tempList.forEach((e) => spanList.add(e));
        return Flutter.RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              children: spanList),
        );
      } else if (tempList[0] != null) {
        List<Widget> widgetList = new List();
        // 有些中间插入的 Null 值需要排除
        tempList.removeWhere((value) => value == null);
        tempList.forEach((element) => widgetList.add(element));
        return Flutter.Column(
          children: widgetList,
        );
      }
    } catch (e) {}
  }
}
