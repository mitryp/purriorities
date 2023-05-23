import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  final List<Widget>? bodyChildren;
  final Widget? child;

  final MainAxisSize? mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  final EdgeInsets minimumSafeArea;

  const MobileLayout({
    required List<Widget> children,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.minimumSafeArea = const EdgeInsets.all(8),
    super.key,
  })  : child = null,
        bodyChildren = children;

  const MobileLayout.child({
    required Widget this.child,
    this.minimumSafeArea = const EdgeInsets.all(8),
    super.key,
  })  : bodyChildren = null,
        mainAxisSize = null,
        mainAxisAlignment = null,
        crossAxisAlignment = null;

  @override
  Widget build(BuildContext context) {
    final child = this.child ??
        Column(
          mainAxisSize: mainAxisSize!,
          mainAxisAlignment: mainAxisAlignment!,
          crossAxisAlignment: crossAxisAlignment!,
          children: bodyChildren!,
        );

    return Scaffold(
      body: SafeArea(
        minimum: minimumSafeArea,
        child: child,
      ),
    );
  }
}
