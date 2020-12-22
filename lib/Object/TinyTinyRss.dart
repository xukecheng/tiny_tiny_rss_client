import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/config.dart';
import 'dart:convert';
import '../Tool/Tool.dart';
import 'package:shared_preferences/shared_preferences.dart';

BaseOptions options = BaseOptions(baseUrl: Config.apiHost);
Dio dio = Dio(options);

// Category Feed Article 是自定义对象，用于整理数据插入到数据库中
class Category {
  int id;
  int categoryName;

  //构造方法
  Category({this.id, this.categoryName});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "categoryName": categoryName,
    };
  }

  //用于将JSON字典转换成类对象的工厂类方法
  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(
      id: parsedJson['id'],
      categoryName: parsedJson['categoryName'],
    );
  }
}

class Feed {
  int id;
  String feedTitle;
  String feedIcon;
  int categoryId;

  //构造方法
  Feed({this.id, this.feedTitle, this.feedIcon, this.categoryId});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "feedTitle": feedTitle,
      "feedIcon": feedIcon,
      'categoryId': categoryId
    };
  }

  //用于将JSON字典转换成类对象的工厂类方法
  factory Feed.fromJson(Map<String, dynamic> parsedJson) {
    return Feed(
        id: parsedJson['id'],
        feedTitle: parsedJson['feedTitle'],
        feedIcon: parsedJson['feedIcon'],
        categoryId: parsedJson['categoryId']);
  }
}

class Article {
  int id;
  int feedId;
  String title;
  int isMarked;
  int isRead;
  String description;
  String htmlContent;
  String flavorImage;
  String articleOriginLink;
  int publishTime;

  //构造方法
  Article({
    this.id,
    this.feedId,
    this.title,
    this.isMarked,
    this.isRead,
    this.description,
    this.htmlContent,
    this.flavorImage,
    this.articleOriginLink,
    this.publishTime,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "feedId": feedId,
      "title": title,
      "isMarked": isMarked,
      "isRead": isRead,
      "description": description,
      "htmlContent": htmlContent,
      "flavorImage": flavorImage,
      "articleOriginLink": articleOriginLink,
      "publishTime": publishTime,
    };
  }

  //用于将JSON字典转换成类对象的工厂类方法
  factory Article.fromJson(Map<String, dynamic> parsedJson) {
    return Article(
      id: parsedJson['id'],
      feedId: parsedJson['feedId'],
      title: parsedJson['title'],
      isMarked: parsedJson['isMarked'],
      isRead: parsedJson['isRead'],
      description: parsedJson['description'],
      htmlContent: parsedJson['htmlContent'],
      flavorImage: parsedJson['flavorImage'],
      articleOriginLink: parsedJson['articleOriginLink'],
      publishTime: parsedJson['publishTime'],
    );
  }
}

// TinyTinyRss 主功能
class TinyTinyRss {
  SharedPreferences session;
  SharedPreferences account;

  main() async {
    // 初始化登录数据和用户名密码
    this.session = await SharedPreferences.getInstance();
    this.account = await SharedPreferences.getInstance();
    await this.account.setString('username', Config.userName);
    await this.account.setString('password', Config.passWord);
  }

  _login() async {
    Response res = await dio.post(
      "api/",
      data: {
        "op": "login",
        "user": this.account.getString('username'),
        "password": this.account.getString('password')
      },
    );

    await this
        .session
        .setString('id', json.decode(res.data)["content"]["session_id"]);
  }

  _checkLoginStatus() async {
    Response response = await dio.post(
      "api/",
      data: {
        "op": "isLoggedIn",
        "sid": this.session.getString('id'),
      },
    );
    if (!json.decode(response.data)['content']['status']) {
      print('未登录');
      await this._login();
    }
  }

  Future<Database> _initailDataBase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'tiny_tiny_rss.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE article(
            id INTEGER PRIMARY KEY,
            feedId INTEGER,
            title TEXT,
            isMarked INTEGER,
            isRead INTEGER,
            description TEXT,
            htmlContent TEXT,
            flavorImage TEXT,
            articleOriginLink INTEGER,
            publishTime INTEGER)
            ''');
        db.execute('''
          CREATE TABLE feed(
            id INTEGER PRIMARY KEY,
            feedTitle TEXT,
            feedIcon TEXT,
            categoryId INTEGER)
            ''');
        db.execute('''
          CREATE TABLE category(
            id INTEGER PRIMARY KEY,
            categoryName INTEGER)
            ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        //dosth for migration
      },
      version: 1,
    );
    return database;
  }

  void _shutDownDataBase() async {
    //释放数据库资源
    var database = this._initailDataBase();
    final Database db = await database;
    db.close();
  }

  _insertArticle(db) async {
    // 再插入新数据之前，把老数据全部标记为已读，再由 insertArticle 去拉取未读文章并更新
    Future<int> updateRead() async {
      return await db.update('article', {'isRead': 1});
    }

    await updateRead();

    Future<void> insertArticle(Article std) async {
      await db.insert(
        "article",
        std.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    try {
      Response response = await dio.post(
        "api/",
        data: {
          "op": "getHeadlines",
          "sid": this.session.getString('id'),
          "view_mode": "unread",
          "feed_id": -4,
          "show_content": true,
        },
      );
      json.decode(response.data)['content'].forEach((articleData) async {
        await insertArticle(
          Article(
            id: articleData['id'],
            feedId: articleData['feed_id'],
            title: articleData['title'],
            description: articleData['content'].toString() != 'false'
                ? Tool()
                        .parseHtmlString(articleData["content"])
                        .substring(0, 51) +
                    "..."
                : '',
            isMarked: articleData['marked'] ? 1 : 0,
            isRead: articleData['unread'] ? 0 : 1,
            htmlContent: articleData['content'],
            flavorImage: articleData['flavor_image'],
            articleOriginLink: articleData['link'],
            publishTime: articleData['updated'],
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  _insertCategoryAndFeed(db) async {
    Future<void> insertCategory(Category std) async {
      await db.insert(
        "category",
        std.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<void> insertFeed(Feed std) async {
      await db.insert(
        "feed",
        std.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    try {
      Response response = await dio.post(
        "api/",
        data: {
          "op": "getFeedTree",
          "sid": this.session.getString('id'),
          "include_empty": false,
        },
      );

      var feedTreeData =
          json.decode(response.data)['content']['categories']['items'];
      feedTreeData.removeAt(0);
      feedTreeData.forEach((categoryData) async {
        await insertCategory(
          Category(
            id: categoryData["bare_id"],
            categoryName: categoryData["name"],
          ),
        );

        categoryData['items'].forEach((feedData) async {
          await insertFeed(
            Feed(
              id: feedData["bare_id"],
              feedTitle: feedData["name"],
              feedIcon: feedData["icon"].toString() == 'false'
                  ? ''
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

  void markRead(List articleIdList) async {
    var database = this._initailDataBase();
    final Database db = await database;
    await this._checkLoginStatus();
    // 调用接口设置已读
    try {
      String articleIdString = articleIdList.join(',');
      Response response = await dio.post(
        "api/",
        data: {
          "op": "updateArticle",
          "sid": this.session.getString('id'),
          "article_ids": articleIdString,
          "mode": 0,
          "field": 2
        },
      );
      print(response.data);
    } catch (e) {
      print(e);
    }
    // 本地数据库标记已读
    Future<int> markRead() async {
      try {
        articleIdList.forEach((articleId) async {
          await db.update("article", {"isRead": 1},
              where: 'id = ?', whereArgs: [articleId]);
        });
        return 1;
      } catch (e) {
        print(e);
        return 0;
      }
    }

    await markRead();
    // this._shutDownDataBase();
  }

  Future<List> getArticleInFeed() async {
    // 等待完成数据库初始化
    var database = this._initailDataBase();
    final Database db = await database;
    // 等待完成数据请求和插入
    await this._checkLoginStatus();
    await this._insertCategoryAndFeed(db);
    await this._insertArticle(db);

    Future<List<Map>> getFeed({bool isUnread = true}) async {
      String sql = '''SELECT 
            article.feedId, 
            feed.feedTitle,
            feed.feedIcon
            FROM article INNER JOIN feed ON article.feedId = feed.id
            WHERE article.isRead = ? 
            GROUP BY feedId 
            ORDER BY publishTime DESC
            ''';
      final List<Map> maps = isUnread
          // 未读文章获取
          ? await db.rawQuery(sql, [0])
          // 已读文章获取
          : await db.rawQuery(sql);

      return List.generate(maps.length, (i) {
        Map feedData = {};
        maps[i].forEach((key, value) => feedData[key] = value);
        return feedData;
      });
    }

    List feedList = await getFeed(isUnread: true);
    String sql = '''SELECT 
          article.id,
          article.title,
          article.description,
          article.flavorImage,
          article.publishTime,
          article.htmlContent,
          article.isRead,
          article.articleOriginLink,
          feed.feedIcon,
          feed.feedTitle 
          FROM article INNER JOIN feed ON article.feedId = feed.id
          WHERE article.isRead = ? 
          AND article.feedId = ?
          ORDER BY publishTime DESC
          ''';
    await Future.forEach(feedList, (feed) async {
      final List<Map> maps = await db.rawQuery(
        sql,
        [0, feed['feedId']],
      );
      feed["feedArticles"] = List.generate(maps.length, (i) {
        Map articleData = new Map();
        maps[i].forEach((key, value) => articleData[key] = value);
        return articleData;
      });
    });
    // this._shutDownDataBase();
    return feedList;
  }

  // Future<List> getArticle({bool isUnread = true}) async {
  //   var articleList;
  //   // 等待完成数据库初始化
  //   var database = this._initailDataBase();
  //   final Database db = await database;
  //   // 等待完成数据请求和插入
  //   await this._insertFeed(db);
  //   await this._insertArticle(db);
  //   // 该方法返回单条数据为 Map 的 List
  //   Future<List> getArticle() async {
  //     String sql = '''SELECT
  //         article.id,
  //         article.title,
  //         article.description,
  //         article.flavorImage,
  //         article.publishTime,
  //         article.htmlContent,
  //         article.isRead,
  //         feed.feedIcon,
  //         feed.feedTitle
  //         FROM article INNER JOIN feed ON article.feedId = feed.id
  //         WHERE article.isRead = ?
  //         ORDER BY publishTime DESC
  //         ''';
  //     final List<Map> maps = isUnread
  //         // 未读文章获取
  //         ? await db.rawQuery(sql, [0])
  //         // 已读文章获取
  //         : await db.rawQuery(sql);

  //     return List.generate(maps.length, (i) {
  //       Map articleData = {};
  //       maps[i].forEach((key, value) => articleData[key] = value);
  //       return articleData;
  //     });
  //   }

  //   await getArticle().then((list) {
  //     articleList = list;
  //   });
  //   // this._shutDownDataBase();
  //   return articleList;
  // }
}
