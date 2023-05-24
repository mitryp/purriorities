extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    if (length == 1) return toUpperCase();

    return '${substring(0, 1).toUpperCase()}${substring(1)}';
  }
}
