import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final double height;
  final Widget? overlayingWidget;

  const ProgressBar({
    required this.maxValue,
    required this.value,
    required this.height,
    this.minValue = 0,
    this.overlayingWidget,
    super.key,
  })  : assert(minValue < maxValue),
        assert(value >= minValue),
        assert(value <= maxValue);

  @override
  Widget build(BuildContext context) {
    final currentValue = (value - minValue) / (maxValue - minValue);

    final progressBar = SizedBox(
      height: height,
      child: LinearProgressIndicator(value: currentValue),
    );

    if (overlayingWidget == null) return progressBar;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        progressBar,
        overlayingWidget!,
      ],
    );
  }
}