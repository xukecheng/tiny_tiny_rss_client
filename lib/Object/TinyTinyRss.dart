import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

BaseOptions options = BaseOptions(baseUrl: "http://192.168.2.214:8888");

class Feed {
  int id;
  String feedTitle;
  String feedIcon;

  //构造方法
  Feed({this.id, this.feedTitle, this.feedIcon});
  Map<String, dynamic> toJson() {
    return {"id": id, "feedTitle": feedTitle, "feedIcon": feedIcon};
  }

  //用于将JSON字典转换成类对象的工厂类方法
  factory Feed.fromJson(Map<String, dynamic> parsedJson) {
    return Feed(
      id: parsedJson['id'],
      feedTitle: parsedJson['feedTitle'],
      feedIcon: parsedJson['feedIcon'],
    );
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

class TinyTinyRss {
  _initailDataBase() async {
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
            feedIcon TEXT)
            ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        //dosth for migration
      },
      version: 1,
    );
    return database;
  }

  _shutDownDataBase() async {
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

    Dio dio = Dio(options);
    try {
      Response response = await dio.get("/get_unreads");
      response.data["data"].forEach((value) async {
        var articleData = Article(
          id: value['id'],
          feedId: value['feedId'],
          title: value['title'],
          isMarked: value['isMarked'],
          isRead: value['isRead'],
          description: value['description'],
          htmlContent: value['htmlContent'],
          flavorImage: value['flavorImage'],
          articleOriginLink: value['articleOriginLink'],
          publishTime: value['publishTime'],
        );
        await insertArticle(articleData);
      });
    } catch (e) {
      print(e);
    }
  }

  _insertFeed(db) async {
    Future<void> insertFeed(Feed std) async {
      await db.insert(
        "feed",
        std.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Dio dio = Dio(options);
    try {
      Response response = await dio.get("/get_feed_tree");
      response.data["data"].forEach((category) async {
        category['categoryFeed'].forEach((feed) async {
          var feedData = Feed(
              id: feed['feedId'],
              feedTitle: feed['feedTitle'],
              feedIcon: feed['feedIcon']);
          await insertFeed(feedData);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List> getArticle({bool isUnread = true}) async {
    var articleList;
    // 等待完成数据库初始化
    var database = this._initailDataBase();
    final Database db = await database;
    // 等待完成数据请求和插入
    await this._insertFeed(db);
    await this._insertArticle(db);
    // 该方法返回单条数据为 Map 的 List
    Future<List> getArticle() async {
      String sql = '''SELECT 
          article.id,
          article.title,
          article.description,
          article.flavorImage,
          article.publishTime,
          article.htmlContent,
          article.isRead,
          feed.feedIcon,
          feed.feedTitle 
          FROM article INNER JOIN feed ON article.feedId = feed.id
          WHERE article.isRead = ? 
          ORDER BY publishTime DESC
          ''';
      final List<Map> maps = isUnread
          // 未读文章获取
          ? await db.rawQuery(sql, [0])
          // 已读文章获取
          : await db.rawQuery(sql);

      return List.generate(maps.length, (i) {
        Map articleData = {};
        maps[i].forEach((key, value) => articleData[key] = value);
        return articleData;
      });
    }

    await getArticle().then((list) {
      articleList = list;
    });
    this._shutDownDataBase();
    return articleList;
  }

  void markRead(List articleIdList) async {
    var database = this._initailDataBase();
    final Database db = await database;
    Dio dio = Dio(options);
    // 调用接口设置已读
    try {
      String articleIdString = articleIdList.join(',');
      await dio.get('/mark_read?article_id_string=$articleIdString');
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
    this._shutDownDataBase();
  }

  Future<List> getArticleInFeed() async {
    // 等待完成数据库初始化
    var database = this._initailDataBase();
    final Database db = await database;
    // 等待完成数据请求和插入
    await this._insertFeed(db);
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
    this._shutDownDataBase();
    return feedList;
  }
}
