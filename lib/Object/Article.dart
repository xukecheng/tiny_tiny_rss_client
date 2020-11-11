import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const articleBox = 'articles';
const dataBaseName = 'article';

class Article {
  int id;
  int feedId;
  String title;
  int isMarked;
  int isUnread;
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
    this.isUnread,
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
      "isUnread": isUnread,
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
      isUnread: parsedJson['isUnread'],
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
            isUnread INTEGER,
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

  insertArticle() async {
    var database = initailDataBase();
    Future<void> insertArticle(Article std) async {
      final Database db = await database;
      await db.insert(
        "article",
        std.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    BaseOptions options = BaseOptions(baseUrl: "http://192.168.2.214:8888");
    Dio dio = Dio(options);
    Response response = await dio.get("/get_unreads");
    response.data["data"].forEach((value) async {
      var articleData = Article(
        id: value['id'],
        feedId: value['feedId'],
        title: value['title'],
        isMarked: value['isMarked'],
        isUnread: value['isUnread'],
        description: value['description'],
        htmlContent: value['htmlContent'],
        flavorImage: value['flavorImage'],
        articleOriginLink: value['articleOriginLink'],
        publishTime: value['publishTime'],
      );
      await insertArticle(articleData);
    });
  }

  getArticle() async {
    var articleList;
    var database = initailDataBase();
    await insertArticle();
    Future<List<Article>> getArticle() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query("article", orderBy: "publishTime DESC");
      return List.generate(maps.length, (i) => Article.fromJson(maps[i]));
    }

    // precacheImage(NetworkImage(element.attributes['src']), context);
    await getArticle().then((list) {
      articleList = list;
    });
    this.shutDownDataBase();
    return articleList;
  }

  getDetail(id) async {
    var htmlContent;
    var database = initailDataBase();
    Future<List<Article>> getDetail() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query("article", where: "id = $id");
      return List.generate(maps.length, (i) => Article.fromJson(maps[i]));
    }

    await getDetail().then((list) {
      htmlContent = list[0].htmlContent;
    });
    this.shutDownDataBase();
    return htmlContent;
  }
}
