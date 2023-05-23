import 'package:flutter/widgets.dart';

import '../constants.dart';

/// A function that returns a scale factor for [Image.asset] scale parameter.
/// Supplying the returned scale to the Image.asset constructor will cause the image to be upsized
/// by [times] times.
double upscale(double times) => 1 / times;

double scaleTo(double dimension, {double spriteDimension = catSpriteDimension}) {
  return spriteDimension / dimension;
}