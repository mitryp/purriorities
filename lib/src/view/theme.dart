import 'package:flutter/material.dart';

final defaultBorderRadius = BorderRadius.circular(4);

final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius)),
);
