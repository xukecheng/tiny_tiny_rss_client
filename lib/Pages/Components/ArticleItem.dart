import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleItem extends StatelessWidget {
  ArticleItem(
      {this.title,
      this.feedIcon,
      this.feedTitle,
      this.articleDescrition,
      this.flavorImage,
      this.publishTime});

  final String title;
  final String feedIcon;
  final String feedTitle;
  final String articleDescrition;
  final String flavorImage;
  final String publishTime;

  // 判断是否存在文章预览图
  Widget _getArticleImage() {
    if (this.flavorImage.isEmpty) {
      return Visibility(visible: false, child: Text('Hello World'));
    } else {
      return Expanded(
        flex: 2,
        child: Container(
          height: 180,
          child: ExtendedImage.network(
            this.flavorImage,
            fit: BoxFit.cover,
            cache: true,
          ),
        ),
      );
    }
  }

  // 判断是否存在有效的文章描述
  Widget _getArticleDescription() {
    if (this.articleDescrition == "&hellip;") {
      return Visibility(visible: false, child: Text('Hello World'));
    } else {
      return Text(this.articleDescrition, style: TextStyle(fontSize: 14.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 文章组件主体
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 15.0)),
            // 文章文本信息组件
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 12.0)),
                    // 文章标题
                    Text(this.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                    ),
                    // feed_icon 和 feed_tile
                    Row(
                      children: [
                        // 剪切 feed_icon 为圆形
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: this.feedIcon,
                            width: 18,
                            height: 18,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 6.0)),
                        Text(this.feedTitle, style: TextStyle(fontSize: 12.0)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                    ),
                    // 文章描述
                    _getArticleDescription(),
                    // 文章发布时间
                    Text(this.publishTime,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.black38)),
                    Padding(padding: const EdgeInsets.only(bottom: 12.0)),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
            ),
            // 文章预览图展示
            _getArticleImage()
          ],
        ),
        // 分隔线
        Divider(
          height: 1.0,
          color: Colors.black26,
        ),
      ],
    );
  }
}
