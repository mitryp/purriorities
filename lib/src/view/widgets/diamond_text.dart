import 'package:flutter/material.dart';
import 'dart:math' as math;

class DiamondText extends StatelessWidget {
  final String caption;

  const DiamondText({required this.caption, super.key});

  @override
  Widget build(BuildContext context) {
    const diamondSize = 20.0;
    const borderWidth = 1.0;

    final theme = Theme.of(context);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(
        math.pi / 4,
      ),
      child: Container(
        width: diamondSize,
        height: diamondSize,
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(
            width: borderWidth,
            color: theme.colorScheme.primary,
          ),
        ),
        child: Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(
              -math.pi / 4,
            ),
            child: FittedBox(
              child: Text(
                caption,
                //style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
