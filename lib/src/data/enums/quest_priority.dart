import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../view/theme.dart';

@JsonEnum(valueField: 'index')
enum QuestPriority {
  optional("необов'язковий", color: Colors.grey),
  regular('звичайний', color: Colors.green),
  legendary('легендарний', color: legendaryColor, textStyle: TextStyle(shadows: legendaryShadows));

  /// A human-readable label for this [QuestPriority] in Ukrainian.
  /// Will need to be changed to the proper localization in the future.
  final String label;

  /// A color for displaying the [label] of this [QuestPriority].
  final Color color;

  /// A text style for displaying the [label] of this [QuestPriority]
  final TextStyle textStyle;

  const QuestPriority(this.label, {required this.color, this.textStyle = const TextStyle()});

  /// A [textStyle] with the [color] included.
  TextStyle get textStyleWithColor => textStyle.copyWith(color: color);
}
