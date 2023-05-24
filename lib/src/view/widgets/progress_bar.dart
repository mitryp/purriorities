import 'dart:math';

import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final double height;
  final Text? caption;

  const ProgressBar({
    required this.maxValue,
    required this.initialValue,
    required this.height,
    this.minValue = 0,
    this.caption,
    super.key,
  }) : // todo asserts, stateless
        assert(minValue != maxValue);

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
