import 'package:flutter/material.dart';

import '../../constants.dart';

class SpriteAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String? assetName;
  final double? maxRadius;
  final double? minRadius;
  final double? scale;

  const SpriteAvatar({
    required ImageProvider this.image,
    this.maxRadius,
    this.minRadius,
    this.scale,
    super.key,
  }) : assetName = null;

  const SpriteAvatar.asset(
    String this.assetName, {
    this.maxRadius,
    this.minRadius,
    this.scale,
    super.key,
  }) : image = null;

  @override
  Widget build(BuildContext context) {
    final image = this.image ??
        Image(
          image: AssetImage(assetName!),
          filterQuality: FilterQuality.none,
        );

    return CircleAvatar(
      maxRadius: maxRadius,
      minRadius: minRadius,
      child: Image.asset(
        assetName!,
        scale: scale,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}
