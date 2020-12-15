import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Components/PhotoViewer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticleDetail extends StatelessWidget {
  final String title;
  final String htmlContent;
  ArticleDetail({this.title, this.htmlContent});

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
      appBar: AppBar(title: Text(this.title)),
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
                this.title,
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
                padding: EdgeInsets.fromLTRB(15, 10, 15, 30),
                child: HtmlWidget(
                  this.htmlContent,
                  // 捕捉点击图片事件
                  factoryBuilder: () => _WidgetFactory(context: context),
                  customStylesBuilder: (element) {
                    if (element.localName.contains('p')) {
                      return {
                        'white-space': 'normal',
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
                    } else if (element.localName.contains('a')) {
                      return {'border-bottom': ''};
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
  }
}

class _WidgetFactory extends WidgetFactory {
  _WidgetFactory({@required this.context});
  final context;

  @override
  Widget buildImage(BuildMetadata meta, Object provider, ImageMetadata image) {
    final built = super.buildImage(meta, provider, image);
    if (built == null) return built;

    return GestureDetector(
      child: built,
      onTap: () {
        print(image.sources.first.url);
        // 跳转到图片预览页
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoViewer(
              imageUrl: image.sources.first.url,
            ),
          ),
        );
      },
    );
  }
}
