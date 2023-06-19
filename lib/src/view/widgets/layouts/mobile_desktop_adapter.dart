import 'package:flutter/material.dart';

class MobileDesktopAdapter extends StatelessWidget {
  final Widget child;
  final double aspectRatio;

  const MobileDesktopAdapter({
    required this.child,
    this.aspectRatio = 3 / 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.background;

    return DecoratedBox(
      decoration: BoxDecoration(color: background),
      child: Align(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: child,
        ),
      ),
    );
  }
}
