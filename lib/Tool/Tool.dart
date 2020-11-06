import 'package:date_format/date_format.dart';

class Tool {
  timestampToDate(timestamp) {
    return formatDate(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }
}
