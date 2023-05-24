DateTime minDate(DateTime a, DateTime b) {
  if (a == b || a.isBefore(b)) return a;
  return b;
}

DateTime maxDate(DateTime a, DateTime b) {
  if (a.isAfter(b)) return a;
  return b;
}