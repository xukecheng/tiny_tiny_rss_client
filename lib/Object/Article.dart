import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const articleBox = 'articles';
const dataBaseName = 'article';

class Article {
  int id;
  String title;
  int feedId;
  String description;
  String flavorImage;
  String publishTime;
  String htmlContent;
  //构造方法
  Article(
      {this.id,
      this.title,
      this.feedId,
      this.description,
      this.flavorImage,
      this.publishTime,
      this.htmlContent});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "feedId": feedId,
      "description": description,
      "flavorImage": flavorImage,
      "publishTime": publishTime,
      "htmlContent": htmlContent,
    };
  }

  //用于将JSON字典转换成类对象的工厂类方法
  factory Article.fromJson(Map<String, dynamic> parsedJson) {
    return Article(
      id: parsedJson['id'],
      title: parsedJson['title'],
      feedId: parsedJson['feedId'],
      description: parsedJson['description'],
      flavorImage: parsedJson['flavorImage'],
      publishTime: parsedJson['publishTime'],
      htmlContent: parsedJson['htmlContent'],
    );
  }
}

class TinyTinyRss {
  initailDataBase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'tiny_tiny_rss.db'),
      onCreate: (db, version) => db.execute(
          "CREATE TABLE article(id INTEGER PRIMARY KEY, title TEXT, feedId INTEGER, description TEXT, flavorImage TEXT, publishTime TEXT, htmlContent TEXT)"),
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
    Future<void> insertArticleData(Article std) async {
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
        title: value['title'],
        feedId: value['feed_id'],
        description: value['description'],
        flavorImage: value['flavor_image'],
        publishTime: value['time'],
        htmlContent: value['content'],
      );
      await insertArticleData(articleData);
    });
  }

  getArticle() async {
    var articleList;
    var database = initailDataBase();
    await insertArticle();
    Future<List<Article>> getArticledata() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query("article");
      return List.generate(maps.length, (i) => Article.fromJson(maps[i]));
    }

    //读取出数据库中插入的Student对象集合
    // getArticledata()
    //     .then((list) => list.forEach((value) => print(value.title)));
    await getArticledata().then((list) {
      articleList = list;
    });
    return articleList;
  }
}
