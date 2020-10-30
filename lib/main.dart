import 'package:flutter/material.dart';
import 'TestMap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("TinyTinyRss")),
      body: ArticleList(),
    ));
  }
}

class ArticleList extends StatefulWidget {
  ArticleList({Key key}) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  var unreadArticleList = new List();
  List<Widget> _getData() {
    unreadArticleMap["data"].forEach((k, v) => unreadArticleList.add(v));
    return unreadArticleList.map((value) {
      return ListItem(
          title: value['title'],
          feedIcon: "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg",
          feedTitle: value['feed_title'],
          feedDescrition: value['description'],
          flavorImage: value['flavor_image'],
          publishTime: value["time"]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this._getData(),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem(
      {this.title,
      this.feedIcon,
      this.feedTitle,
      this.feedDescrition,
      this.flavorImage,
      this.publishTime});

  final String title;
  final String feedIcon;
  final String feedTitle;
  final String feedDescrition;
  final String flavorImage;
  final String publishTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 文章组件主体
        Row(
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 12.0)),
            // 文章文本信息组件
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 文章标题
                    Text(this.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 20.0)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                    ),
                    // feed_icon 和 feed_tile
                    Row(
                      children: [
                        // 剪切 feed_icon 为圆形
                        ClipOval(
                            child: SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: Image.network(
                                  this.feedIcon,
                                  fit: BoxFit.fill,
                                ))),
                        Padding(padding: const EdgeInsets.only(left: 6.0)),
                        Text(this.feedTitle, style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                    ),
                    // 文章描述
                    Text(this.feedDescrition, style: TextStyle(fontSize: 14.0)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                    ),
                    // 文章发布时间
                    Text(this.publishTime, style: TextStyle(fontSize: 16.0)),
                  ],
                )),
            // 文章预览图展示
            Expanded(
                flex: 1,
                child: AspectRatio(
                    aspectRatio: 1 / 2,
                    child: Image.network(this.flavorImage, fit: BoxFit.cover))),
          ],
        ),
        // 分隔线
        Divider(
          height: 1.0,
          color: Colors.black38,
        ),
      ],
    );
  }
}
