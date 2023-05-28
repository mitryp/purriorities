import 'package:flutter/material.dart';
import 'progress_bar.dart';

class LabeledProgressBar extends StatelessWidget {
  final String label;
  final int minValue;
  final int maxValue;
  final int value;
  final String? progressBarCaption;

  const LabeledProgressBar({
    required this.label,
    required this.value,
    required this.maxValue,
    this.minValue = 0,
    this.progressBarCaption,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final caption = progressBarCaption;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(label, textAlign: TextAlign.end),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 3,
          child: ProgressBar(
            minValue: minValue,
            maxValue: maxValue,
            value: value,
            height: 25,
            overlayingWidget: caption != null ? Text(caption) : null,
          ),
        ),
      ],
    );
  }
}
