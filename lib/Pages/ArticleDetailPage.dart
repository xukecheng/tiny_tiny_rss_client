import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';

import '../Tool/ImageClickWidgetFactory.dart';
import '../Data/database.dart';

class ArticleDetailPage extends StatelessWidget {
  final int id;
  ArticleDetailPage(this.id);

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Article> getArticleDetail(AppDatabase database) {
    return database.getArticleDetail(id: this.id).then((value) {
      return value.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase database = Provider.of<AppDatabase>(context, listen: false);

    return FutureBuilder<Article>(
      future: getArticleDetail(database),
      builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
        // 请求已结束
        switch (snapshot.connectionState) {
          //如果未执行则提示，未执行
          case ConnectionState.none:
            return Text('未执行');
          //如果正在执行则提示：加载中
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          //如果执行完毕
          default:
            //若执行出现异常
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            //若执行正常完成
            else
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  actions: [
                    // 打开原文
                    IconButton(
                      icon: Icon(Icons.open_in_browser),
                      onPressed: () {
                        this._launchURL(
                          snapshot.data!.articleOriginLink,
                        );
                      },
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // 文章标题
                      Text(
                        snapshot.data!.title,
                        style: TextStyle(decoration: TextDecoration.none),
                      )
                          .bold()
                          .fontSize(24)
                          .textColor(Colors.black)
                          .padding(left: 15, top: 20, right: 15, bottom: 10),
                      // 分割线
                      Divider(
                        height: 1.0,
                        color: Colors.black26,
                      ),
                      // 富文本渲染内容
                      HtmlWidget(
                        snapshot.data!.htmlContent,
                        // 捕捉点击图片事件
                        factoryBuilder: () => ImageClickWidgetFactory(
                          context: context,
                        ),
                        customStylesBuilder: (element) {
                          if (element.localName!.contains('p')) {
                            return {
                              'white-space': 'normal',
                              'word-break': 'break-all',
                            };
                          } else if (element.localName!
                              .contains('blockquote')) {
                            return {
                              'background-color': 'rgba(0, 0, 0, 0.04)',
                              'margin': '0',
                              'padding': '0.5em 0.5em'
                            };
                          } else if (element.localName!.contains('ul')) {
                            return {'padding': '0 0 0 25px'};
                          } else if (element.localName!.contains('li')) {
                            return {'margin-bottom': '10px'};
                          } else if (element.localName!.contains('a')) {
                            return {'border-bottom': ''};
                          } else if (element.localName!.contains('figure')) {
                            return {
                              'margin': '0',
                              'font-size': '0.857em',
                              'color': 'grey'
                            };
                          }
                          return null;
                        },
                        onTapUrl: (url) => this._launchURL(url),
                        textStyle: TextStyle(fontSize: 16, height: 1.6),
                      ).padding(left: 15, top: 10, right: 15, bottom: 30)
                    ],
                  ),
                ),
              );
        }
      },
    );
  }
}
