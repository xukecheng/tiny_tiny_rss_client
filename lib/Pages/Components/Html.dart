import 'package:html/parser.dart' show parse;
import 'package:flutter/material.dart' as Flutter;
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../test.dart';

var unescape = new HtmlUnescape();

class Html {
  htmlParser(html) {
    List<Flutter.Widget> parserdList = new List();
    List nodeList = new List();
    Document document = parse(test);

    findBody(value) {
      value.forEach((element) {
        if (element.toString() == '<html body>') {
          nodeList = element.nodes;
        } else {
          findBody(element.nodes);
        }
      });
    }

    findBody(document.nodes[0].nodes);
    nodeList.forEach((value) {
      // 查看每一个 Node 标签，是否为标题类型
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

    fact(nodes) {
      for (var i = 0; i < nodes.length; i++) {
        // nodeType = 3 = Node.TEXT_NODE (Element 或者 Attr 中实际的 文字)
        if (nodes[i].nodeType == 3) {
          tempList.add(Flutter.RichText(
              text: Flutter.TextSpan(
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  text: unescape.convert(nodes[i].text))));
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
          tempList.add(Flutter.RichText(
              text: Flutter.TextSpan(
            text: unescape.convert(nodes[i].text),
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
            // recognizer: 点击事件
          )));
        } else if (nodes[i].localName == 'br') {
          print("跳过 br");
        } else {
          fact(nodes[i].nodes);
        }
      }
    }

    fact(nodes);
    tempList.removeWhere((value) => value == null);
    // 尝试将 Widget 从 list 中取出，然后在主 list 中添加 Widget 而非 List。
    try {
      // if (tempList[0] is TextSpan) {
      //   List<Flutter.InlineSpan> spanList = new List();
      //   tempList.forEach((e) => spanList.add(e));
      //   return Flutter.RichText(
      //     text: TextSpan(
      //         style: TextStyle(fontSize: 16.0, color: Colors.black),
      //         children: spanList),
      //   );
      // } else if (tempList[0] != null) {
      //   List<Widget> widgetList = new List();
      //   tempList.forEach((element) => widgetList.add(element));
      //   return Flutter.Column(
      //     children: widgetList,
      //   );
      // }
      List<Widget> widgetList = new List();
      print(tempList);
      tempList.forEach((element) => widgetList.add(element));
      print(widgetList);
      return Flutter.Column(
        children: widgetList,
      );
    } catch (e) {}
  }
}
