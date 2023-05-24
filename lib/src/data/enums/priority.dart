import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../view/theme.dart';

@JsonEnum()
enum QuestPriority {
  @JsonValue(0)
  optional("необов'язковий", color: Colors.grey),
  @JsonValue(1)
  regular('звичайний', color: Colors.green),
  @JsonValue(2)
  legendary('легендарний', color: legendaryColor, textStyle: TextStyle(shadows: legendaryShadows));

  final String label;
  final Color color;
  final TextStyle textStyle;

  const QuestPriority(this.label, {required this.color, this.textStyle = const TextStyle()});
}
