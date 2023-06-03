import 'package:flutter/material.dart';

import '../../constants.dart';

const Size _defaultSize = Size.square(catSpriteDimension);

/// An enumeration of the sprites used statically in this application.
enum Sprite {
  grayCat('assets/gray-cat.webp'),
  valerian('assets/valerian.webp'),
  fishFood('assets/foods_fish.webp');

  /// A path to the asset of this [Sprite].
  final String asset;

  /// A size of this [Sprite].
  final Size size;

  /// Whether this [Sprite] has animation.
  final bool isAnimated;

  const Sprite(this.asset, {this.size = _defaultSize, this.isAnimated = true});
}
