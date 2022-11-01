import 'package:intl/intl.dart';

String dateOnlyString(DateTime dateTime) {
  var formatter = DateFormat('MM-dd-yy');
  return formatter.format(dateTime);
}
