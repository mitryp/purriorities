import 'package:flutter/material.dart';

typedef LayoutSelectionPredicate = bool Function(MediaQueryData);

bool _defaultSelectionPredicate(MediaQueryData mediaQuery) =>
    mediaQuery.size.width < 576 && mediaQuery.orientation == Orientation.portrait;

class LayoutSelector extends StatelessWidget {
  final WidgetBuilder mobileLayoutBuilder;
  final WidgetBuilder desktopLayoutBuilder;
  final LayoutSelectionPredicate mobileSelectionPredicate;

  const LayoutSelector({
    required this.mobileLayoutBuilder,
    required this.desktopLayoutBuilder,
    this.mobileSelectionPredicate = _defaultSelectionPredicate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (mobileSelectionPredicate(mediaQuery)) {
      return mobileLayoutBuilder.call(context);
    }

    return desktopLayoutBuilder.call(context);
  }
}
