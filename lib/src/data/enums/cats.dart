import 'package:flutter/material.dart';

const Size _defaultSize = Size.square(16);

enum Cats {
  grayCat('assets/gray-cat.webp');

  final String asset;
  final Size size;
  final bool isAnimated;

  const Cats(this.asset, {this.size = _defaultSize, this.isAnimated = true});
}