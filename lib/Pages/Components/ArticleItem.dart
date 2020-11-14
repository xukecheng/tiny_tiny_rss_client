import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../ArticleDetail.dart';

class ArticleItem extends StatelessWidget {
  ArticleItem(
      {this.articleId,
      this.articleTitle,
      this.feedIcon,
      this.feedTitle,
      this.articleDesciption,
      this.flavorImage,
      this.publishTime,
      this.htmlContent});

  final int articleId;
  final String articleTitle;
  final String feedIcon;
  final String feedTitle;
  final String articleDesciption;
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
          height: 185,
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
    if (this.articleDesciption.isEmpty) {
      return Visibility(visible: false, child: Text('Hello World'));
    } else {
      return Text(this.articleDesciption, style: TextStyle(fontSize: 14.0));
    }
  }

  Widget _getFeedIcon() {
    if (this.feedIcon.isEmpty) {
      return Visibility(visible: false, child: Text('Hello World'));
    } else {
      return Row(
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
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
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 12.0)),
                    // 文章标题
                    Text(this.articleTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                    ),
                    // feed_icon 和 feed_tile
                    this._getFeedIcon(),
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
