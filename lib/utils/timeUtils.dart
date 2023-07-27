import 'package:intl/intl.dart';

class TimeUtils {
  static String dayMonth(DateTime date) {
    final DateFormat formatter = DateFormat('d/M/y');
    return formatter.format(date).toString();
  }

  static String date(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd yyyy');
    return formatter.format(date).toString();
  }

  static String shortMonthDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd yyyy');
    return formatter.format(date).toString();
  }

  static String datePlusTime(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd yyyy hh:mm a');
    return formatter.format(date).toString();
  }

  static String time(DateTime date) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(date).toString();
  }
}
