import 'package:moor/moor.dart';

import 'ttrss.dart';
import '../Tool/Tool.dart';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
export 'database/shared.dart';

part 'database.g.dart';

@DataClassName("Article")
class Articles extends Table {
  IntColumn get id => integer().customConstraint("UNIQUE")();
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
  IntColumn get id => integer().customConstraint("UNIQUE")();
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
  IntColumn get id => integer().customConstraint("UNIQUE")();
  TextColumn get categoryName => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ArticlesInFeed {
  final int id;
  final String feedTitle;
  final String feedIcon;
  final int categoryId;
  final List<Article> feedArticles;

  ArticlesInFeed(this.id, this.feedTitle, this.feedIcon, this.categoryId,
      this.feedArticles);
}

class ArticleStatus {
  final int id;
  final int isRead;
  final int isStar;

  ArticleStatus(this.id, this.isRead, this.isStar);
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Articles, Feeds, Categories])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase(QueryExecutor e) : super(e);

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  /// 初始化数据
  _initData() async {
    late String sessionId;
    await Tool.getData<String>('sessionId').then((value) => sessionId = value);
    bool loginStatus = await TinyTinyRss().checkLoginStatus(sessionId);
    if (!loginStatus) {
      await Tool.getData<String>('sessionId')
          .then((value) => sessionId = value);
    }
    await customUpdate("UPDATE articles SET is_read = 1 ");

    // 完成文章数据获取
    List<Article> articleList = await TinyTinyRss().insertArticles(sessionId);
    await Future.forEach(
        articleList, (Article article) => this._insertArticle(article));

    // 完成 Feed 和分类数据获取
    List<List> feedTreeData =
        await TinyTinyRss().insertCategoryAndFeed(sessionId);
    feedTreeData.first.forEach((feed) => this._insertFeed(feed));
    feedTreeData.last.forEach((category) => this._insertCategory(category));
  }

  /// 获取 ArticlesInFeed 结构的未读文章
  Future<List<ArticlesInFeed>> getUnreadArticlesInFeeds(
      {int isRead = 0, bool isLaunch = false}) async {
    List<ArticlesInFeed> articlesInFeeds = [];

    // 如果 isLaunch，那么就需要从云端拉取数据存入本地数据库
    if (!isLaunch) {
      await this._initData();
    }

    // 根据 isRead 值获取有效的 Feeds
    List<Feed> feedList = await this._getFeeds(isRead: isRead);

    // 根据上面的有效 Feeds 去获取 Feeds 下的文章，并整合成 ArticlesInFeed
    await Future.forEach(feedList, (Feed feed) async {
      var feedArticles = await this._getArticles(feed.id, isRead: isRead);
      ArticlesInFeed articlesInfeed = ArticlesInFeed(
        feed.id,
        feed.feedTitle,
        feed.feedIcon,
        feed.categoryId,
        feedArticles,
      );
      articlesInFeeds.add(articlesInfeed);
    });

    return articlesInFeeds;
  }

  Future<List<ArticlesInFeed>> getFavoriteArticlesInFeeds(
      {bool isLaunch = false}) async {
    List<ArticlesInFeed> articlesInFeeds = [];

    // 如果 isLaunch，那么就需要从云端拉取数据存入本地数据库
    if (!isLaunch) {
      await this._initData();
    }

    List<Feed> feedList = await this._getFeeds(isStar: 1);

    await Future.forEach(feedList, (Feed feed) async {
      var feedArticles = await this._getArticles(feed.id, isStar: 1);
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

  Future getArticleStatus(int id) => (select(articles)
        ..where(
          (a) => a.id.equals(id),
        ))
      .get();

  Future markRead(List<int> idList, {int isRead = 1}) async {
    TinyTinyRss().markRead(idList, isRead: isRead);
    idList.forEach((id) async {
      final query = (select(articles)..where((a) => a.id.equals(id)));
      List<Article> result = await query.get();
      this._updateArticle(Article(
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

  Future markStar(int id, {int isStar = 1}) async {
    TinyTinyRss().markStar(id, isStar: isStar);
    final query = (select(articles)..where((a) => a.id.equals(id)));
    List<Article> result = await query.get();
    this._updateArticle(Article(
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

  Future _updateArticle(Article article) => update(articles).replace(article);
  Future _insertArticle(Article article) =>
      into(articles).insertOnConflictUpdate(article);
  Future _insertFeed(Feed feed) => into(feeds).insertOnConflictUpdate(feed);
  Future _insertCategory(Category category) =>
      into(categories).insertOnConflictUpdate(category);

  Future<List<Feed>> _getFeeds({int? isRead, int? isStar}) {
    if (isRead != null) {
      return ((select(articles)
                ..where(
                  (a) => a.isRead.equals(isRead),
                ))
              .join([
        innerJoin(
          feeds,
          feeds.id.equalsExp(articles.feedId),
        )
      ])
            ..orderBy([OrderingTerm.desc(articles.publishTime)])
            ..groupBy([articles.feedId]))
          .map((rows) {
        final id = rows.read(feeds.id);
        final feedTitle = rows.read(feeds.feedTitle);
        final feedIcon = rows.read(feeds.feedIcon);
        final categoryId = rows.read(feeds.categoryId);
        return Feed(
          id: id!,
          feedTitle: feedTitle!,
          feedIcon: feedIcon!,
          categoryId: categoryId!,
        );
      }).get();
    } else {
      return ((select(articles)
                ..where(
                  (a) => a.isStar.equals(isStar),
                ))
              .join([
        innerJoin(
          feeds,
          feeds.id.equalsExp(articles.feedId),
        )
      ])
            ..orderBy([OrderingTerm.desc(articles.publishTime)])
            ..groupBy([articles.feedId]))
          .map((rows) {
        final id = rows.read(feeds.id);
        final feedTitle = rows.read(feeds.feedTitle);
        final feedIcon = rows.read(feeds.feedIcon);
        final categoryId = rows.read(feeds.categoryId);
        return Feed(
          id: id!,
          feedTitle: feedTitle!,
          feedIcon: feedIcon!,
          categoryId: categoryId!,
        );
      }).get();
    }
  }

  Future<List<Article>> _getArticles(int feedId, {int? isRead, int? isStar}) {
    if (isRead != null) {
      final query = select(articles);
      query
        ..orderBy([
          (t) =>
              OrderingTerm(expression: t.publishTime, mode: OrderingMode.desc)
        ]);
      query.where((a) => a.isRead.equals(isRead) & a.feedId.equals(feedId));
      return query.get();
    } else {
      return (select(articles)
            ..where(
              (a) => a.isStar.equals(isStar) & a.feedId.equals(feedId),
            ))
          .get();
    }
  }
  // void close() {
  //   MyDatabase().close();
  // }
}
