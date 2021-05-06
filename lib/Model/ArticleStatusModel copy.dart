import 'package:flutter/material.dart';

import '../Data/database.dart';

class ArticleModel with ChangeNotifier {
  List<ArticlesInFeed> initData;
  ArticleModel(this.initData);

  List<ArticlesInFeed> get articleList => initData;
  int get total => initData.length;

  setReadStatus(int feedIndex, List<int> articleIndexList, int isRead) {
    ArticlesInFeed articlesInFeed = initData[feedIndex];
    // var good = _goodsList[index];
    // _goodsList[index] = Goods(!good.isCollection, good.goodsName);
    articlesInFeed.feedArticles[articleIndexList.first] =
        articlesInFeed.feedArticles[articleIndexList.first].copyWith(isRead: 1);
    // print(initData[feedIndex].feedArticles[0].isRead);
    // initData[feedIndex] = articlesInFeed;
    // print(initData[feedIndex].feedArticles[0].isRead);
    notifyListeners();
  }
}
