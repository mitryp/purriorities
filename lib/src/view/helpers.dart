import 'package:flutter/widgets.dart';

List<Widget> makeSeparated(List<Widget> widgets, Widget separator) {
  final nOfElements = widgets.length;

  return widgets
      .asMap()
      .entries
      .map(
        (entry) => entry.key == nOfElements - 1 ? [entry.value] : [entry.value, separator],
      )
      .expand((e) => e)
      .toList();
}
