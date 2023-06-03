String formatMinutes(int minutes) {
  final hours = (minutes / 60).floor();
  final minutesLeft = hours != 0 ? minutes % (60 * hours) : minutes;

  final hoursStr = '$hours год.';
  final minutesStr = '$minutesLeft хв.';

  if (hours != 0 && minutesLeft != 0) return '$hoursStr $minutesStr';
  if (hours != 0) return hoursStr;
  return minutesStr;
}
