import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:html/parser.dart';

BaseOptions options = BaseOptions(baseUrl: "https://test/");
Dio dio = Dio(options);

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;
  return parsedString;
}

main() async {
  String sessionId = '';
  List articleList = new List();
  List feedList = new List();
  Response res = await dio.post(
    "api/",
    data: {"op": "login", "user": "test", "password": "test"},
  );
  print(json.decode(res.data));
  sessionId = json.decode(res.data)["content"]["session_id"];
  Response res2 = await dio.post(
    "api/",
    data: {
      "op": "getHeadlines",
      "sid": sessionId,
      "view_mode": "unread",
      "feed_id": -4,
      "show_excerpt": true,
      "show_content": true,
    },
  );
  json.decode(res2.data)['content'].forEach((value) {
    var article = {
      "id": value["id"],
      "title": value["title"],
      "description": parseHtmlString(value["content"]).substring(0, 51) + "...",
      "content": value["content"],
      "marked": value["marked"],
      "link": value["link"],
      "feed_id": value["feed_id"],
      "tags": value["tags"],
      "flavor_image": value["flavor_image"],
      "unread": value["unread"],
      "updated": value["updated"],
    };
    articleList.add(article);
  });
  print(articleList);
  Response res4 = await dio.post(
    "api/",
    data: {
      "op": "getFeedTree",
      "sid": sessionId,
      "include_empty": false,
    },
  );
  List categoryList = new List();
  var feedTreeData = json.decode(res4.data)['content']['categories']['items'];
  feedTreeData.removeAt(0);
  feedTreeData.forEach((categoryData) {
    var category = {
      "title": categoryData["name"],
      "id": categoryData["bare_id"],
    };
    categoryList.add(category);
    categoryData['items'].forEach((feedData) {
      var feed = {
        "title": feedData["name"],
        "id": feedData["bare_id"],
        "icon": feedData["icon"],
        "categoryId": categoryData["bare_id"],
      };
      feedList.add(feed);
    });
  });
  print(categoryList);
  print(feedList);
  Response res3 = await dio.post(
    "api/",
    data: {
      "op": "updateArticle",
      "sid": sessionId,
      "article_ids": [3223, 5566].join(','),
      "mode": 0,
      "field": 2
    },
  );
  print(res3.data);
}
