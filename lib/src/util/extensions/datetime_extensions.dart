import 'package:flutter/material.dart';

extension DateTimeConversions on DateTime {
  DateTime toDate() => DateTime(year, month, day);

  TimeOfDay toTime() => TimeOfDay.fromDateTime(this);
}
