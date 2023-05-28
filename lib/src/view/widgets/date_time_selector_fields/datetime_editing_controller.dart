import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../util/extensions/datetime_extensions.dart';

class DateTimeEditingController extends TextEditingController {
  final String format;
  final String? notSelectedPlaceholder;

  final DateFormat _format;

  DateTime? _dateTime;

  DateTime? get dateTime => _dateTime;

  set dateTime(DateTime? dateTime) {
    _dateTime = dateTime;

    final optionalText = dateTime != null ? _format.format(dateTime) : notSelectedPlaceholder;
    text = optionalText ?? '';
  }

  DateTimeEditingController({
    this.format = 'dd.MM.yyyy',
    this.notSelectedPlaceholder,
    DateTime? selectedDate,
  })  : _dateTime = selectedDate,
        _format = DateFormat(format);
}

class TimeEditingController extends DateTimeEditingController {
  TimeEditingController({
    super.format = 'HH:mm',
    super.notSelectedPlaceholder,
    TimeOfDay? selectedTime,
  }) : super(selectedDate: DateTime(2023).withTime(selectedTime ?? TimeOfDay.now()));

  TimeOfDay? get time => dateTime?.toTime();

  set time(TimeOfDay? time) => dateTime = time != null ? dateTime?.withTime(time) : null;
}
