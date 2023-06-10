import 'package:flutter/material.dart';
import '../../theme.dart';
import 'progress_bar.dart';

class LabeledProgressBar extends StatelessWidget {
  final String label;
  final num minValue;
  final num maxValue;
  final num value;
  final String? progressBarCaption;
  final double spacing;
  final TextAlign labelAlign;
  final double progressBarHeight;
  final int labelFlex;
  final int barFlex;

  const LabeledProgressBar({
    required this.label,
    required this.value,
    required this.maxValue,
    this.minValue = 0,
    this.progressBarCaption,
    this.spacing = 8.0,
    this.labelAlign = TextAlign.end,
    this.progressBarHeight = 25.0,
    this.labelFlex = 2,
    this.barFlex = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final caption = progressBarCaption;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: labelFlex,
          child: Text(label, textAlign: labelAlign),
        ),
        SizedBox(width: spacing),
        Expanded(
          flex: barFlex,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: ProgressBar(
              minValue: minValue,
              maxValue: maxValue,
              value: value,
              height: progressBarHeight,
              overlayingWidget:
                  caption != null ? Text(caption, style: progressBarCaptionTextStyle) : null,
            ),
          ),
        ),
      ],
    );
  }
}
