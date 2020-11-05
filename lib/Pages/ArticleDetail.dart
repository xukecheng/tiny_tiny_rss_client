import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';

class ArticleDetail extends StatelessWidget {
  final articleContent;
  ArticleDetail({this.articleContent = "没有"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TinyTinyRss")),
      body: SingleChildScrollView(
        child: Html(
          data: this.articleContent,
          //Optional parameters:
          onLinkTap: (url) {
            // open url in a webview
          },
          style: {
            "p": Style(fontSize: FontSize.large),
          },
          onImageTap: (src) {
            // Display the image in large form.
          },
        ),
      ),
    );
  }
}
