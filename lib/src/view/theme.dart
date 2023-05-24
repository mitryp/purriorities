import 'package:flutter/material.dart';

const legendaryColor = Colors.amber;

const legendaryShadows = [
  Shadow(
    color: legendaryColor,
    blurRadius: 16,
    offset: Offset(1, 1),
  ),
];

final defaultBorderRadius = BorderRadius.circular(4);

final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  ),
);
