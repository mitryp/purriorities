import 'package:flutter/material.dart';

import 'extensions/time_comparison_extension.dart';

TimeOfDay minTime(TimeOfDay a, TimeOfDay b) {
  if (a == b || a < b) return a;
  return b;
}

TimeOfDay maxTime(TimeOfDay a, TimeOfDay b) {
  if (a > b) return a;
  return b;
}
