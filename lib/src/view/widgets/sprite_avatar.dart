import 'package:flutter/material.dart';

class SpriteAvatar extends StatelessWidget {
  final Image? image;
  final String? assetName;
  final double? maxRadius;
  final double? minRadius;
  final double? scale;

  final Color? backgroundColor;
  final Color? foregroundColor;

  const SpriteAvatar({
    required Image this.image,
    this.maxRadius,
    this.minRadius,
    this.scale,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  }) : assetName = null;

  const SpriteAvatar.asset(
    String this.assetName, {
    this.maxRadius,
    this.minRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.scale,
    super.key,
  }) : image = null;

  @override
  Widget build(BuildContext context) {
    final image = this.image ??
        Image.asset(
          assetName!,
          scale: scale,
          filterQuality: FilterQuality.none,
        );

    return CircleAvatar(
      maxRadius: maxRadius,
      minRadius: minRadius,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: image,
    );
  }
}
