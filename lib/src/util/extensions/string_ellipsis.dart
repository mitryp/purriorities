extension StringElipsis on String {
  String ellipsis(int maxLength, {String overflowIndicator = '...'}) {
    if (length <= maxLength) {
      return this;
    }

    final indicator = overflowIndicator;
    final indicatorLength = indicator.length;

    final cropped = substring(0, maxLength - indicatorLength);
    final withIndicator = '$cropped$indicator';

    return withIndicator;
  }
}
