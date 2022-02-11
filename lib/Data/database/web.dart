import 'package:drift/web.dart';

import '../database.dart';

AppDatabase constructDb({bool logStatements = false}) {
  return AppDatabase(WebDatabase('db', logStatements: logStatements));
}
