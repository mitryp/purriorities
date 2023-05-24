import 'dart:math';

import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final double height;
  final Text? caption;

  ProgressBar({
    minValue = 0,
    required maxValue,
    required initialValue,
    required this.height,
    this.caption,
    super.key,
  })  : minValue = min(minValue, maxValue),
        maxValue = max(minValue, maxValue),
        initialValue = min(max(initialValue, minValue), maxValue) {
    assert(minValue != maxValue);
  }

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  late int value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final currentValue = value / (widget.maxValue - widget.minValue);

    final progressBar = SizedBox(
      height: widget.height,
      child: LinearProgressIndicator(value: currentValue),
    );

    if (widget.caption == null) return progressBar;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        progressBar,
        widget.caption!,
      ],
    );
  }
}
