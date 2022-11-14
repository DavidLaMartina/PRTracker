import 'package:intl/intl.dart';

String dateOnlyString(DateTime? dateTime) {
  if (dateTime == null) return '';
  var formatter = DateFormat('MM-dd-yy');
  return formatter.format(dateTime);
}
