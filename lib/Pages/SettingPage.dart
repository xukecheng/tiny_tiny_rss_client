import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../Tool/SizeCalculate.dart';
import '../Tool/Tool.dart';
import '../Extension/Int.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 初始化 SizeCalculate
    SizeCalculate.initialize(context);

    return Container(
      child: Center(
        child: Text("Setting")
            .fontSize((52.rpx))
            .bold()
            .textColor(Tool().colorFromHex("#D35400")),
      ),
    );
  }
}
