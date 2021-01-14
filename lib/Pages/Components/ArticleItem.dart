import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleItem extends StatelessWidget {
  ArticleItem({
    this.id,
    this.title,
    this.isRead,
    this.description,
    this.flavorImage,
    this.publishTime,
  });

  final int id;
  final String title;
  final int isRead;
  final String description;
  final String flavorImage;
  final String publishTime;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          // 文章组件主体
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
                  Hero(
                    tag: this.title,
                    child: Text(
                      this.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      // 已读文章标题变色
                      style: isRead == 1
                          ? TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              // 标记颜色和下划线，防止 hero 动画出现变色和下划线
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )
                          : TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              // 标记颜色和下划线，防止 hero 动画出现变色和下划线
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                  ),
                  // 文章描述
                  Visibility(
                    visible: this.description.isEmpty ? false : true,
                    child: Text(
                      this.description,
                      // 已读文章描述变色
                      style: isRead == 1
                          ? TextStyle(fontSize: 14.0, color: Colors.grey)
                          : TextStyle(fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                  ),
                  Text(this.publishTime,
                      style: TextStyle(fontSize: 12.0, color: Colors.black45)),
                  Padding(padding: const EdgeInsets.only(bottom: 12.0)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
            ),
            // 文章预览图展示
            Visibility(
              // 判断预览图是否存在
              visible: this.flavorImage.isEmpty ? false : true,
              child: Expanded(
                flex: 2,
                child: Container(
                  height: 170,
                  child: CachedNetworkImage(
                    imageUrl: this.flavorImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
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
