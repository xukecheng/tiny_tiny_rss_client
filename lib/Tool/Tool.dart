import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class Tool {
  String timestampToDate(timestamp) {
    return formatDate(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
