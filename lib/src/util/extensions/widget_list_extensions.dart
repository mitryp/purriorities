import 'package:flutter/widgets.dart';

import '../../view/helpers.dart';
import '../widget_wrapper.dart' as wrappers;

extension SeparatedWidgetList on List<Widget> {
  List<Widget> separate(Widget separator) => makeSeparated(this, separator);
}

extension WidgetWrappedList on List<Widget> {
  List<Widget> wrap(wrappers.SingleChildWidgetConstructor widgetConstructor) =>
      map(wrappers.wrapWith(widgetConstructor)).toList();

  Widget wrapWithCollection(wrappers.MultiChildWidgetConstructor widgetConstructor) =>
      wrappers.wrapWithCollection(widgetConstructor)(this);
}
