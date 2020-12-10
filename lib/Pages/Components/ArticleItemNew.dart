import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleItem extends StatelessWidget {
  ArticleItem({this.feedTitle, this.feedIcon, this.feedArticles});

  final String feedIcon;
  final String feedTitle;
  final List<Map> feedArticles;

  List<Widget> _getArticleTile() {
    return this.feedArticles.map((value) {
      return ListItem(
        title: value['title'],
        flavorImage: value['flavorImage'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: ClipOval(
              child: CachedNetworkImage(
                imageUrl: this.feedIcon,
                width: 30,
                height: 30,
                fit: BoxFit.fill,
              ),
            ),
            title: Text(this.feedTitle, style: TextStyle(color: Colors.red)),
          ),
          Divider(
            height: 0,
          ),
          Column(children: this._getArticleTile())
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({this.title, this.flavorImage});

  final String title;
  final String flavorImage;

  @override
  Widget build(BuildContext context) {
    return flavorImage.isNotEmpty
        ? Column(
            children: [
              Divider(
                height: 0,
              ),
              Padding(padding: const EdgeInsets.only(top: 14.0)),
              Container(
                height: 70,
                child: ListTile(
                  title: Text(this.title),
                  trailing: CachedNetworkImage(
                    imageUrl: this.flavorImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          )
        : ListTile(
            // trailing: Icon(Icons.chevron_right),
            title: Text(this.title),
          );
  }
}
