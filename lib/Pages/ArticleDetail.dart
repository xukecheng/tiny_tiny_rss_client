import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Components/PhotoViewer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Object/TinyTinyRss.dart';

class ArticleDetail extends StatelessWidget {
  final int id;
  ArticleDetail({this.id});

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Map> getArticleDetail() {
    return TinyTinyRss().getArticleDetail(this.id).then((value) {
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: getArticleDetail(),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [
                snapshot.hasError
                    ? Center(
                        child: Text("Error: ${snapshot.error}"),
                      )
                    // 打开原文
                    : IconButton(
                        icon: Icon(Icons.open_in_browser),
                        onPressed: () {
                          this._launchURL(snapshot.data['articleOriginLink']);
                        },
                      )
              ],
            ),
            body: snapshot.hasError
                ? Center(
                    child: Text("Error: ${snapshot.error}"),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // 文章标题
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Hero(
                            tag: snapshot.data['title'],
                            child: Text(
                              snapshot.data['title'],
                              style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  // 标记颜色和下划线，防止 hero 动画出现变色和下划线
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        // 分割线
                        Divider(
                          height: 1.0,
                          color: Colors.black26,
                        ),
                        // 富文本渲染内容
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 30),
                            child: HtmlWidget(
                              snapshot.data['htmlContent'],
                              // 捕捉点击图片事件
                              factoryBuilder: () =>
                                  _WidgetFactory(context: context),
                              customStylesBuilder: (element) {
                                if (element.localName.contains('p')) {
                                  return {
                                    'white-space': 'normal',
                                    'word-break': 'break-all',
                                  };
                                } else if (element.localName
                                    .contains('blockquote')) {
                                  return {
                                    'background-color': 'rgba(0, 0, 0, 0.04)',
                                    'margin': '0',
                                    'padding': '0.5em 0.5em'
                                  };
                                } else if (element.localName.contains('ul')) {
                                  return {'padding': '0 0 0 25px'};
                                } else if (element.localName.contains('li')) {
                                  return {'margin-bottom': '10px'};
                                } else if (element.localName.contains('a')) {
                                  return {'border-bottom': ''};
                                } else if (element.localName
                                    .contains('figure')) {
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
                            )),
                      ],
                    ),
                  ),
          );
        } else {
          // 请求未结束，显示loading
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class _WidgetFactory extends WidgetFactory {
  _WidgetFactory({@required this.context});
  final context;
  List imageList = new List();
  @override
  Widget buildImage(BuildMetadata meta, Object provider, ImageMetadata image) {
    final built = super.buildImage(meta, provider, image);
    if (built == null) return built;
    imageList.add(image.sources.first.url);
    return GestureDetector(
      child: Hero(
        tag: image.sources.first.url,
        child: built,
      ),
      onTap: () {
        // 跳转到图片预览页
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoViewer(
              this.imageList,
              initialPage: imageList.indexOf(image.sources.first.url),
            ),
          ),
        );
      },
    );
  }
}
