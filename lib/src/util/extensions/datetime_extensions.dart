import 'package:flutter/material.dart';

extension DateTimeConversions on DateTime {
  DateTime toDate() => DateTime(year, month, day);

  TimeOfDay toTime() => TimeOfDay(hour: hour, minute: minute);

  DateTime withDate(DateTime date) {
    final d = date.toDate();

    return copyWith(year: d.year, month: d.month, day: d.day);
  }

  DateTime withTime(TimeOfDay time) => copyWith(hour: time.hour, minute: time.minute);
}

extension TimeToMinutes on TimeOfDay {
  int toMinutes() => hour * 60 + minute;
}
