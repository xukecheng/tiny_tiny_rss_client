import 'database.dart';

import 'package:dio/dio.dart';
import '../utils/config.dart';
import 'dart:convert';
import '../Tool/Tool.dart';

BaseOptions options = BaseOptions(baseUrl: Config.apiHost);
Dio dio = Dio(options);

class TinyTinyRss {
  _login() async {
    Response res = await dio.post(
      "api/",
      data: {
        "op": "login",
        "user": Config.userName,
        "password": Config.passWord,
      },
    );
    await Tool.saveData<String>(
        'sessionId', json.decode(res.data)["content"]["session_id"]);
    print('登录中');
  }

  Future<bool> checkLoginStatus({String sessionId = ''}) async {
    if (sessionId != null) {
      Response response = await dio.post(
        "api/",
        data: {
          "op": "isLoggedIn",
          "sid": sessionId ?? '',
        },
      );
      if (!json.decode(response.data)['content']['status']) {
        print('未登录');
        await this._login();
        return false;
      } else {
        print('已登录');
        return true;
      }
    } else {
      print('未登录');
      await this._login();
      return false;
    }
  }

  markRead({List articleIdList, int isRead = 1}) async {
    String sessionId;
    await Tool.getData<String>('sessionId').then((value) => sessionId = value);
    await this.checkLoginStatus(sessionId: sessionId);
    // 调用接口设置已读
    try {
      String articleIdString = articleIdList.join(',');
      await dio.post(
        "api/",
        data: {
          "op": "updateArticle",
          "sid": sessionId,
          "article_ids": articleIdString,
          "mode": isRead == 1 ? 0 : 1,
          "field": 2
        },
      );
    } catch (e) {
      print(e);
    }
  }

  markStar({int id, int isStar = 1}) async {
    String sessionId;
    await Tool.getData<String>('sessionId').then((value) => sessionId = value);
    await this.checkLoginStatus(sessionId: sessionId);
    // 调用接口设置已读
    try {
      await dio.post(
        "api/",
        data: {
          "op": "updateArticle",
          "sid": sessionId,
          "article_ids": id.toString(),
          "mode": isStar,
          "field": 0
        },
      );
    } catch (e) {
      print(e);
    }
  }

  insertArticles({String sessionId = ''}) async {
    try {
      Response response = await dio.post(
        "api/",
        data: {
          "op": "getHeadlines",
          "sid": sessionId,
          "view_mode": "unread",
          "feed_id": -4,
          "show_content": true,
        },
      );
      json.decode(response.data)['content'].forEach((articleData) async {
        AppDatabase().insertArticle(Article(
          id: articleData['id'],
          feedId: articleData['feed_id'],
          title: articleData['title'],
          description: articleData['content'].toString() != 'false'
              ? Tool()
                      .parseHtmlString(articleData["content"])
                      .substring(0, 51) +
                  "..."
              : '',
          isStar: articleData['marked'] ? 1 : 0,
          isRead: articleData['unread'] ? 0 : 1,
          htmlContent: articleData['content'],
          flavorImage: articleData['flavor_image'],
          articleOriginLink: articleData['link'],
          publishTime: articleData['updated'],
        ));
      });
    } catch (e) {
      print('错误$e');
    }
  }

  insertCategoryAndFeed({String sessionId = ''}) async {
    try {
      Response response = await dio.post(
        "api/",
        data: {
          "op": "getFeedTree",
          "sid": sessionId,
          "include_empty": false,
        },
      );

      var feedTreeData =
          json.decode(response.data)['content']['categories']['items'];
      feedTreeData.removeAt(0);
      feedTreeData.forEach((categoryData) async {
        await AppDatabase().insertCategory(
          Category(
            id: categoryData["bare_id"],
            categoryName: categoryData["name"],
          ),
        );

        categoryData['items'].forEach((feedData) async {
          await AppDatabase().insertFeed(
            Feed(
              id: feedData["bare_id"],
              feedTitle: feedData["name"],
              feedIcon: feedData["icon"].toString() == 'false'
                  ? 'https://picgo-1253786286.cos.ap-guangzhou.myqcloud.com/image/1608987140.svg'
                  : Config.apiHost + feedData["icon"],
              categoryId: categoryData["bare_id"],
            ),
          );
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
