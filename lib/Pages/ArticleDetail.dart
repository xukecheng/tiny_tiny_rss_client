import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';

class ArticleDetail extends StatelessWidget {
  final articleTitle;
  final flavorImage;
  final articleContent;
  ArticleDetail({this.articleTitle, this.flavorImage, this.articleContent});

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
      appBar: AppBar(title: Text("TinyTinyRss")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
              child: Text(
                this.articleTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 1.0,
              color: Colors.black26,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 30),
                child: Html(
                  data: this.articleContent,
                  style: {
                    "img": Style(alignment: Alignment.center),
                    "p": Style(fontSize: FontSize.large),
                    "a": Style(fontSize: FontSize.large),
                    "h1": Style(fontSize: FontSize.xxLarge),
                    "h2": Style(fontSize: FontSize.xxLarge),
                    "h3": Style(fontSize: FontSize.xLarge),
                  },
                  customRender: {
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
                    print(src);
                  },
                  onImageError: (exception, stackTrace) {
                    print(exception);
                  },
                )
                // HtmlWidget(
                //   this.articleContent,
                //   customStylesBuilder: (element) {
                //     if (element.localName.contains('p')) {
                //       return {
                //         'white-space': 'normal',
                //         'word-break': 'break-all',
                //         'text-align': 'justify'
                //       };
                //     } else if (element.localName.contains('a')) {
                //       return {
                //         'white-space': 'normal',
                //         'word-break': 'break-all',
                //         'text-align': 'justify'
                //       };
                //     } else if (element.localName.contains('blockquote')) {
                //       return {
                //         'background-color': 'rgba(0, 0, 0, 0.04)',
                //         'margin': '0',
                //         'padding': '0.5em 0.5em'
                //       };
                //     } else if (element.localName.contains('ul')) {
                //       return {'padding': '0 0 0 25px'};
                //     } else if (element.localName.contains('li')) {
                //       return {'margin-bottom': '10px'};
                //     }
                //     return null;
                //   },
                //   customWidgetBuilder: (element) {
                //     if (element.localName.contains('li') &&
                //         element.nodes.toString() == '[<html img>]') {
                //       return CachedNetworkImage(
                //         imageUrl: element.nodes[0].attributes['src'],
                //         fit: BoxFit.cover,
                //       );
                //     }
                //   },
                //   onTapUrl: (url) => this._launchURL(url),
                //   textStyle: TextStyle(fontSize: 16, height: 1.6),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
