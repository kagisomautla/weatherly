import 'package:weatherly/utils/get_week_day.dart';

String formatDateTime(DateTime dateTime, {bool showWeekday = false, bool showTime = false, bool showWeekDayAndTime = false}) {
  String weekday = getWeekdayName(dateTime.weekday);
  String time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

  //show the time in 12-hour format
  if (dateTime.hour > 12) {
    time = '${dateTime.hour - 12}:${dateTime.minute.toString().padLeft(2, '0')} PM';
  } else if (dateTime.hour == 12) {
    time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} PM';
  } else {
    time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} AM';
  }

  //if weekday is today, show weekday as 'Today'
  //if yesterday, show weekday as 'Yesterday'
  //if tomorrow, show weekday as 'Tomorrow'
  //else show the weekday
  if (dateTime.day == DateTime.now().day) {
    weekday = 'Today';
  } else if (dateTime.day == DateTime.now().subtract(Duration(days: 1)).day) {
    weekday = 'Yesterday';
  } else if (dateTime.day == DateTime.now().add(Duration(days: 1)).day) {
    weekday = 'Tomorrow';
  }

  if (showWeekDayAndTime == true) {
    return '$weekday, $time';
  } else if (showWeekday == true) {
    return weekday;
  } else if (showTime == true) {
    return time;
  }

  return '$weekday, $time';
}
