import 'package:flutter/material.dart';

import 'mobile_desktop_adapter.dart';

typedef LayoutSelectionPredicate = bool Function(MediaQueryData);

bool _defaultSelectionPredicate(MediaQueryData mediaQuery) =>
    mediaQuery.size.width < 576 && mediaQuery.orientation == Orientation.portrait;

class LayoutSelector extends StatelessWidget {
  final WidgetBuilder mobileLayoutBuilder;
  final WidgetBuilder? desktopLayoutBuilder;
  final LayoutSelectionPredicate mobileSelectionPredicate;

  const LayoutSelector({
    required this.mobileLayoutBuilder,
    this.desktopLayoutBuilder,
    this.mobileSelectionPredicate = _defaultSelectionPredicate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (mobileSelectionPredicate(mediaQuery)) {
      return mobileLayoutBuilder.call(context);
    }

    final desktopLayoutBuilder = this.desktopLayoutBuilder ??
        (context) => MobileDesktopAdapter(child: mobileLayoutBuilder.call(context));

    return desktopLayoutBuilder.call(context);
  }
}
