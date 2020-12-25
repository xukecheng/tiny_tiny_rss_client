import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tool {
  String timestampToDate(timestamp) {
    return formatDate(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString.replaceAll("\n", "").replaceAll(new RegExp(r"\s+"), "");
  }

  static saveData<T>(String key, T value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (T) {
      case String:
        prefs.setString(key, value as String);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
    }
  }

  /// 读取数据
  static Future<T> getData<T>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    T res;
    switch (T) {
      case String:
        res = prefs.getString(key) as T;
        break;
      case int:
        res = prefs.getInt(key) as T;
        break;
      case bool:
        res = prefs.getBool(key) as T;
        break;
      case double:
        res = prefs.getDouble(key) as T;
        break;
    }
    return res;
  }
}
