import 'package:flutter/material.dart';

extension TimeComparison on TimeOfDay {
  bool operator <(TimeOfDay other) {
    return hour < other.hour && minute < other.minute;
  }

  bool operator >(TimeOfDay other) {
    return this != other && !(this < other);
  }
}
