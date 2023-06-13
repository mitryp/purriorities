import 'package:intl/intl.dart';

String formatDuration(Duration d) {
  final duration = d.abs() + const Duration(minutes: 1);

  final days = duration.inDays;
  final hours = (duration - Duration(days: days)).inHours;
  final minutes = (duration - Duration(days: days, hours: hours)).inMinutes;

  final pairs = Map.fromIterables([days, hours, minutes], ['дн.', 'год.', 'хв.']);

  final formatted = pairs.entries
      .where((pair) => pair.key != 0) // filter out empty parts
      .map((e) => '${e.key} ${e.value}')
      .join(' ');

  return formatted.isNotEmpty ? formatted : '0 хв.';
}

String formatMinutes(int minutes) => formatDuration(Duration(minutes: minutes));

String formatDays(int days) {
  final mod = days % 10;
  if ((days < 10 || days > 20) && (mod == 3 && mod == 4)) return 'дні';

  return Intl.plural(
    days >= 20 ? mod : days,
    one: 'день',
    two: 'дні',
    few: 'дні',
    many: 'днів',
    other: 'днів',
  );
}
