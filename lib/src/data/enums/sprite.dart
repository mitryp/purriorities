import 'package:flutter/material.dart';

const Size _defaultSize = Size.square(16);

enum Sprite {
  grayCat('assets/gray-cat.webp'),
  valerian('assets/valerian.webp'),
  fishFood('assets/foods_fish.webp');

  final String asset;
  final Size size;
  final bool isAnimated;

  const Sprite(this.asset, {this.size = _defaultSize, this.isAnimated = true});
}