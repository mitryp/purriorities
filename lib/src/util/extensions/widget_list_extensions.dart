import 'package:flutter/widgets.dart';

import '../../view/helpers.dart';
import '../widget_wrapper.dart' as wrappers;

extension SeparatedWidgetList on List<Widget> {
  List<Widget> separate(Widget separator) => makeSeparated(this, separator);
}

extension WidgetWrappedList on List<Widget> {
  List<Widget> wrap(wrappers.WidgetWrapper widgetConstructor) => map(widgetConstructor).toList();

  Widget wrapWithCollection(wrappers.WidgetCollectionWrapper widgetConstructor) =>
      widgetConstructor(this);
}
