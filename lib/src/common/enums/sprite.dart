import 'package:flutter/material.dart';

import '../../constants.dart';

const Size _defaultSize = Size.square(catSpriteDimension);

/// An enumeration of the sprites used statically in this application.
enum Sprite {
  grayCat('assets/gray-cat.webp', animatedAsset: 'assets/gray-cat-animated.webp'),
  valerian('assets/valerian.webp', animatedAsset: 'assets/valerian-animated.webp'),
  fishFood('assets/foods-fish.webp', animatedAsset: 'assets/foods-fish-animated.webp'),
  catCarrier('assets/cat-carrier.webp');

  /// A path to the asset of this [Sprite].
  final String asset;

  /// A path to the animated asset of this [Sprite].
  /// By default, the same as the [asset].
  final String animatedAsset;

  /// A size of this [Sprite].
  final Size size;

  const Sprite(
    this.asset, {
    String? animatedAsset,
    this.size = _defaultSize,
  }) : animatedAsset = animatedAsset ?? asset;
}
