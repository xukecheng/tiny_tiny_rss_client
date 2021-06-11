import 'package:flutter/material.dart';

import '../Data/database.dart';

class UnreadArticleModel with ChangeNotifier {
  UnreadArticleModel(this.db);
  final AppDatabase db;
  List<ArticlesInFeed> initData = [];

  List<ArticlesInFeed> get getData => initData;

  int get total => initData.length;

  Future<void> update({bool isLaunch = false}) async {
    if (isLaunch) {
      this.initData =
          await db.getUnreadArticlesInFeeds(isRead: 0, isLaunch: isLaunch);
    } else {
      this.initData = await db.getUnreadArticlesInFeeds(isRead: 0);
    }
    notifyListeners();
  }

  setReadStatus(int feedIndex, List<int> articleIndexList, int isRead) {
    ArticlesInFeed articlesInFeed = initData[feedIndex];
    List<int> articleIdList = [];
    // 如果传过来的 indexList 为空，则代表该 Feed 下需全部已读
    if (articleIndexList.isEmpty) {
      // 找到 Feed 的所有文章，数据标记为已读，同时添加 id 到 idList 中去
      articlesInFeed.feedArticles.asMap().forEach((index, article) {
        articlesInFeed.feedArticles[index] = article.copyWith(isRead: isRead);
        articleIdList.add(article.id);
      });
    } else {
      // 找到符合 IndexList 的 Feed 文章，数据标记为已读，同时添加 id 到 idList 中去
      articleIndexList.forEach((articleIndex) {
        articlesInFeed.feedArticles[articleIndex] =
            articlesInFeed.feedArticles[articleIndex].copyWith(isRead: isRead);
        articleIdList.add(articlesInFeed.feedArticles[articleIndex].id);
      });
    }
    db.markRead(articleIdList, isRead: isRead);
    notifyListeners();
  }

  setStarStatus(int feedIndex, int articleIndex, int isStar) {
    ArticlesInFeed articlesInFeed = initData[feedIndex];
    int articleId = articlesInFeed.feedArticles[articleIndex].id;
    articlesInFeed.feedArticles[articleIndex] =
        articlesInFeed.feedArticles[articleIndex].copyWith(isStar: isStar);
    db.markStar(articleId, isStar: isStar);
    notifyListeners();
  }
}
