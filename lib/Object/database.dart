import 'package:moor/moor.dart';
import 'dart:io';

// These imports are only needed to open the database
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'ttrss.dart';
import '../Tool/Tool.dart';
// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'database.g.dart';

@DataClassName("Article")
class Articles extends Table {
  IntColumn get id => integer()();
  IntColumn get feedId => integer()();
  TextColumn get title => text()();
  IntColumn get isStar => integer()();
  IntColumn get isRead => integer()();
  TextColumn get description => text()();
  TextColumn get htmlContent => text().named('body')();
  TextColumn get flavorImage => text()();
  TextColumn get articleOriginLink => text()();
  IntColumn get publishTime => integer()();

  @override
  Set<Column> get primaryKey => {id, feedId};
}

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
@DataClassName("Feed")
class Feeds extends Table {
  IntColumn get id => integer()();
  TextColumn get feedTitle => text()();
  TextColumn get feedIcon => text()();
  IntColumn get categoryId => integer()();

  @override
  Set<Column> get primaryKey => {id, categoryId};
}

// This will make moor generate a class called "Category" to represent a row in this table.
// By default, "Categorie" would have been used because it only strips away the trailing "s"
// in the table name.
@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer()();
  TextColumn get categoryName => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ArticlesInFeed {
  int id;
  String feedTitle;
  String feedIcon;
  int categoryId;
  List<Article> feedArticles;

  ArticlesInFeed(this.id, this.feedTitle, this.feedIcon, this.categoryId,
      this.feedArticles);
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Articles, Feeds, Categories])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  // MyDatabase() : super(_openConnection());
  AppDatabase() : super(_openConnection()) {
    moorRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  // the schemaVersion getter and the constructor from the previous page
  // have been omitted.

  _initData() async {
    String sessionId;
    await Tool.getData<String>('sessionId').then((value) => sessionId = value);
    bool loginStatus =
        await TinyTinyRss().checkLoginStatus(sessionId: sessionId);
    if (!loginStatus) {
      await Tool.getData<String>('sessionId')
          .then((value) => sessionId = value);
    }
    // 等待完成数据请求和插入
    await TinyTinyRss().insertArticles(sessionId: sessionId);
    await TinyTinyRss().insertCategoryAndFeed(sessionId: sessionId);
  }

  Future<List<ArticlesInFeed>> getArticlesInFeeds({int isRead: 0}) async {
    List<ArticlesInFeed> articlesInFeeds = [];
    await this._initData();
    List<Feed> feedList = await this._getFeeds(isRead: isRead);
    feedList.forEach((feed) async {
      List<Article> feedArticles =
          await this._getArticles(isRead: 0, feedId: feed.id);
      ArticlesInFeed articlesInfeed = ArticlesInFeed(feed.id, feed.feedTitle,
          feed.feedIcon, feed.categoryId, feedArticles);
      articlesInFeeds.add(articlesInfeed);
    });
    return articlesInFeeds;
  }

  Future<List<Article>> getArticleDetail({int id: 0}) => (select(articles)
        ..where(
          (a) => a.id.equals(id),
        ))
      .get();

  Future markRead({List<int> idList, int isRead = 1}) async {
    TinyTinyRss().markRead(articleIdList: idList, isRead: isRead);
    idList.forEach((id) async {
      final query = (select(articles)..where((a) => a.id.equals(id)));
      List<Article> result = await query.get();
      update(articles).replace(Article(
          id: result.first.id,
          feedId: result.first.feedId,
          title: result.first.title,
          isStar: result.first.isStar,
          isRead: isRead,
          description: result.first.description,
          htmlContent: result.first.htmlContent,
          flavorImage: result.first.flavorImage,
          articleOriginLink: result.first.articleOriginLink,
          publishTime: result.first.publishTime));
    });
  }

  Future markStar({int id, int isStar = 1}) async {
    TinyTinyRss().markStar(id: id, isStar: isStar);
    final query = (select(articles)..where((a) => a.id.equals(id)));
    List<Article> result = await query.get();
    update(articles).replace(Article(
        id: result.first.id,
        feedId: result.first.feedId,
        title: result.first.title,
        isStar: isStar,
        isRead: result.first.isRead,
        description: result.first.description,
        htmlContent: result.first.htmlContent,
        flavorImage: result.first.flavorImage,
        articleOriginLink: result.first.articleOriginLink,
        publishTime: result.first.publishTime));
  }

  Future insertArticle(Article article) =>
      into(articles).insertOnConflictUpdate(article);
  Future insertFeed(Feed feed) => into(feeds).insertOnConflictUpdate(feed);
  Future insertCategory(Category category) =>
      into(categories).insertOnConflictUpdate(category);

  Future<List<Feed>> _getFeeds({int isRead: 0}) => ((select(articles)
                ..where(
                  (a) => a.isRead.equals(isRead),
                ))
              .join([
        innerJoin(
          feeds,
          feeds.id.equalsExp(articles.feedId),
        )
      ])
                ..groupBy([articles.feedId]))
          .map((rows) {
        final id = rows.read(feeds.id);
        final feedTitle = rows.read(feeds.feedTitle);
        final feedIcon = rows.read(feeds.feedIcon);
        final categoryId = rows.read(feeds.categoryId);
        return Feed(
            id: id,
            feedTitle: feedTitle,
            feedIcon: feedIcon,
            categoryId: categoryId);
      }).get();

  Future<List<Article>> _getArticles({int isRead: 0, int feedId}) =>
      (select(articles)
            ..where(
              (a) => a.isRead.equals(isRead) & a.feedId.equals(feedId),
            ))
          .get();

  // void close() {
  //   MyDatabase().close();
  // }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ttt.sqlite'));
    return VmDatabase(file);
  });
}
