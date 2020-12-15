import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleItem extends StatelessWidget {
  ArticleItem(
      {this.id,
      this.title,
      this.isRead,
      this.description,
      this.flavorImage,
      this.publishTime,
      this.htmlContent});

  final int id;
  final String title;
  final int isRead;
  final String description;
  final String flavorImage;
  final String publishTime;
  final String htmlContent;

  // 判断是否存在文章预览图
  Widget _getArticleImage() {
    if (this.flavorImage.isEmpty) {
      return Visibility(visible: false, child: Text('Hello World'));
    } else {
      return Expanded(
        flex: 2,
        child: Container(
          height: 170,
          child: CachedNetworkImage(
            imageUrl: this.flavorImage,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  // 处理文章内容，转换成可用的文章描述
  Widget _getArticleDescription() {
    if (this.description.isEmpty) {
      return Visibility(visible: false, child: Text('Hello World'));
    } else {
      return Text(this.description, style: TextStyle(fontSize: 14.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // 文章组件主体
            Padding(padding: const EdgeInsets.only(left: 15.0)),
            // 文章文本信息组件
            Expanded(
              flex: 5,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 12.0)),
                    // 文章标题
                    Text(
                      this.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: isRead == 1
                          ? TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)
                          : TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                    ),
                    // 文章描述
                    this._getArticleDescription(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                    ),
                    Text(this.publishTime,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.black45)),
                    Padding(padding: const EdgeInsets.only(bottom: 12.0)),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
            ),
            // 文章预览图展示
            this._getArticleImage()
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
