import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';

import '../Data/database.dart';
import '../Model/FavoriteArticleModel.dart';
import '../Tool/SizeCalculate.dart';
import '../Tool/Tool.dart';
import '../Extension/Int.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  void initState() {
    super.initState();
    // 初始化未读文章
    Provider.of<FavoriteArticleModel>(context, listen: false)
        .update(isLaunch: true)
        .then((value) {
      setState(() {
        // this._isLoadComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 初始化 SizeCalculate
    SizeCalculate.initialize(context);

    return Container(
      child: Center(
        child: Text("Favorite")
            .fontSize((52.rpx))
            .bold()
            .textColor(Tool().colorFromHex("#D35400")),
      ),
    );
  }
}
