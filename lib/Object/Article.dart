import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const dataBaseName = 'article';
BaseOptions options = BaseOptions(baseUrl: "http://192.168.2.214:8888");

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
  initailDataBase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'tiny_tiny_rss.db'),
      onCreate: (db, version) => db.execute('''
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
            '''),
      onUpgrade: (db, oldVersion, newVersion) {
        //dosth for migration
      },
      version: 1,
    );
    return database;
  }

  shutDownDataBase() async {
    //释放数据库资源
    var database = initailDataBase();
    final Database db = await database;
    db.close();
  }

  _insertArticle() async {
    var database = initailDataBase();
    List unreadIds = new List();
    Future<void> insertArticle(Article std) async {
      final Database db = await database;
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
        unreadIds.add(value['id']);
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
    Future<int> updateRead() async {
      final Database db = await database;
      return await db.update("article", {"isRead": 1},
          where: 'id not in ?', whereArgs: [unreadIds]);
    }

    await updateRead();
  }

  getArticle({bool isRead = false}) async {
    var articleList;
    // 等待完成数据库初始化
    var database = initailDataBase();
    // 等待完成数据请求和插入
    await this._insertArticle();
    // 该方法返回单条数据为 Map 的 List
    Future<List<Article>> getArticle() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = isRead
          // 全部文章获取
          ? await db.query("article", orderBy: "publishTime DESC")
          // 未读文章获取
          : await db.query("article",
              where: "isRead = 0", orderBy: "publishTime DESC");
      return List.generate(maps.length, (i) => Article.fromJson(maps[i]));
    }

    // precacheImage(NetworkImage(element.attributes['src']), context);
    await getArticle().then((list) {
      articleList = list;
    });
    this.shutDownDataBase();
    return articleList;
  }

  void markRead(int articleId) async {
    var database = initailDataBase();
    Dio dio = Dio(options);
    // 调用接口设置已读
    try {
      await dio.get('/mark_read?id=$articleId');
    } catch (e) {
      print(e);
    }
    // 本地数据库标记已读
    Future<int> markRead() async {
      final Database db = await database;
      return await db.update("article", {"isRead": 1},
          where: 'id = ?', whereArgs: [articleId]);
    }

    await markRead();
    this.shutDownDataBase();
  }
}
