import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticleDetail extends StatelessWidget {
  final articleContent;
  ArticleDetail({this.articleContent = "没有"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("TinyTinyRss")),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: HtmlWidget(
            this.articleContent,
            customStylesBuilder: (element) {
              if (element.localName.contains('p')) {
                return {
                  'white-space': 'normal',
                  'text-align': 'justify',
                  'word-break': 'break-all',
                };
              } else if (element.localName.contains('blockquote')) {
                return {
                  'background-color': 'rgba(0, 0, 0, 0.04)',
                  'margin': '0',
                  'padding': '0.5em 0.5em'
                };
              } else if (element.localName.contains('ul')) {
                return {'padding': '0 0 0 25px'};
              } else if (element.localName.contains('li')) {
                return {'margin-bottom': '10px'};
              }
              return null;
            },
            onTapUrl: (url) => print('tapped $url'),
            textStyle: TextStyle(fontSize: 16, height: 1.6),
          ),
        )));
  }
}
