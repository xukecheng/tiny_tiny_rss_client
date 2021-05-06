import 'package:flutter/material.dart';

import '../Data/database.dart';

class ArticleModel with ChangeNotifier {
  ArticleModel(this.initData);
  List<ArticlesInFeed> initData;

  List<ArticlesInFeed> get articlesInFeeds => initData;
  int get total => initData.length;

  update(List<ArticlesInFeed> articlesInFeeds) {
    initData = articlesInFeeds;
    notifyListeners();
  }

  setReadStatus(int feedIndex, List<int> articleIndexList, int isRead) {
    ArticlesInFeed articlesInFeed = initData[feedIndex];
    if (articleIndexList.isEmpty) {
      articlesInFeed.feedArticles.asMap().forEach((index, article) {
        articlesInFeed.feedArticles[index] = article.copyWith(isRead: isRead);
      });
    } else {
      articleIndexList.forEach((articleIndex) {
        articlesInFeed.feedArticles[articleIndex] =
            articlesInFeed.feedArticles[articleIndex].copyWith(isRead: isRead);
      });
    }
    notifyListeners();
  }

  setStarStatus(int feedIndex, List<int> articleIndexList, int isStar) {
    ArticlesInFeed articlesInFeed = initData[feedIndex];
    if (articleIndexList == []) {
      articlesInFeed.feedArticles.asMap().forEach((index, article) {
        articlesInFeed.feedArticles[index] = article.copyWith(isStar: isStar);
      });
    } else {
      articleIndexList.forEach((articleIndex) {
        articlesInFeed.feedArticles[articleIndex] =
            articlesInFeed.feedArticles[articleIndex].copyWith(isStar: isStar);
      });
    }
    notifyListeners();
  }
}
