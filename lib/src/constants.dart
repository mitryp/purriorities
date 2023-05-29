// Art
import 'package:flutter/material.dart';
import 'view/theme.dart';

const catSpriteDimension = 16.0;

final accentButtonStyle = ButtonStyle(
  side: MaterialStateProperty.all(
    const BorderSide(
      style: BorderStyle.solid,
      color: legendaryColor,
      width: 1,
    ),
  ),
);