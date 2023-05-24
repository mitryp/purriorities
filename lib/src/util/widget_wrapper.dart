import 'package:flutter/cupertino.dart';

typedef WidgetWrapper = Widget Function(Widget);
typedef WidgetCollectionWrapper = Widget Function(List<Widget>);

typedef SingleChildWidgetConstructor = Widget Function({
  required Widget child,
});

typedef MultiChildWidgetConstructor = Widget Function({
  required List<Widget> children,
});

WidgetWrapper wrapWith(SingleChildWidgetConstructor widgetConstructor) =>
    (w) => widgetConstructor(child: w);

WidgetCollectionWrapper wrapWithCollection(MultiChildWidgetConstructor widgetConstructor) =>
    (ws) => widgetConstructor(children: ws);
