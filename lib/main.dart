import 'package:flutter/material.dart';
import 'TestMap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("TinyTinyRss")),
      body: HomeContent(),
    ));
  }
}

class HomeContent extends StatelessWidget {
  List<Widget> _getData() {
    var unreadArticleList = new List();
    unreadArticleMap["data"].forEach((k, v) => unreadArticleList.add(v));
    return unreadArticleList.map((value) {
      return ListItem(
        title: value['title'],
        feedTitle: value['feed_title'],
        cover: value['flavor_image'],
      );
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
  ListItem({this.title, this.feedTitle, this.cover});

  final String title;
  final String feedTitle;
  final String cover;

  @override
  Widget build(BuildContext context) {
    try {
      return ListTile(
        leading: Container(
            child: Image.network(this.cover, fit: BoxFit.cover),
            width: 60,
            height: 60,
            color: Colors.grey),
        trailing: Icon(Icons.chevron_right),
        title: Text(this.title),
        subtitle: Text(this.feedTitle),
      );
    } catch (e) {
      return ListTile(
        trailing: Icon(Icons.chevron_right),
        title: Text(this.title),
        subtitle: Text(this.feedTitle),
      );
    }
  }
}
