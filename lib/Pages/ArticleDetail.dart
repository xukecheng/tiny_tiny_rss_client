import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'Components/PhotoViewer.dart';

class ArticleDetail extends StatelessWidget {
  final String articleTitle;
  final String articleContent;
  ArticleDetail({this.articleTitle, this.articleContent});

  _launchURL(url) async {
    if (url) if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(this.articleTitle)),
      body: SingleChildScrollView(
        // 增加回弹效果
        // physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 文章标题
            Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
              child: Text(
                this.articleTitle,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            // 分割线
            Divider(
              height: 1.0,
              color: Colors.black26,
            ),
            // 富文本渲染内容
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: Html(
                data: this.articleContent,
                style: {
                  "img": Style(alignment: Alignment.center),
                  "p": Style(fontSize: FontSize.large),
                  "span": Style(fontSize: FontSize.large),
                  "div": Style(fontSize: FontSize.large),
                  "b": Style(fontSize: FontSize.large),
                  "a": Style(
                      fontSize: FontSize.large,
                      textDecoration: TextDecoration.none),
                  "h1": Style(fontSize: FontSize.xLarge),
                  "h2": Style(fontSize: FontSize(18)),
                  "h3": Style(
                      fontSize: FontSize.large, fontWeight: FontWeight.bold),
                },
                customRender: {
                  // 处理无序列表中的图片样式，示例 feed -> 游戏时光
                  "li": (context, child, attributes, _) {
                    if (_.nodes.toString() == '[<html img>]') {
                      return Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CachedNetworkImage(
                          imageUrl: _.nodes[0].attributes['src'],
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return child;
                    }
                  },
                  // 处理引用内容样式
                  "blockquote": (context, child, attributes, _) {
                    List<Widget> quoteList = new List();
                    findQuoteText(node) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(node.text,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      );
                    }

                    _.nodes.forEach(
                        (element) => quoteList.add(findQuoteText(element)));
                    return Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      color: Colors.grey[200],
                      child: Column(
                        children: quoteList,
                      ),
                    );
                  }
                },
                onLinkTap: (url) {
                  this._launchURL(url);
                },
                onImageTap: (src) {
                  // 跳转到图片预览页
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PhotoViewer(
                        imageUrl: src,
                      ),
                    ),
                  );
                },
                onImageError: (exception, stackTrace) {
                  print(exception);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
