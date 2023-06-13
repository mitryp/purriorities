import 'package:flutter/material.dart';

import '../../../common/enums/currency.dart';
import '../../../util/sprite_scaling.dart';

const _defaultCurrencyImageSize = 25.0;

class CurrencyInfo extends StatelessWidget {
  final int quantity;
  final Currency currency;
  final double spriteSize;
  final bool reversed;
  final double gap;

  const CurrencyInfo({
    required this.quantity,
    required this.currency,
    this.spriteSize = _defaultCurrencyImageSize,
    this.reversed = false,
    this.gap = 4.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      CurrencyImage(currency: currency, spriteSize: spriteSize),
      SizedBox(width: gap),
      Text('$quantity'),
    ].toList(growable: false);


    return Row(
      mainAxisSize: MainAxisSize.min,
      children: reversed ? children.reversed.toList(growable: false) : children,
    );
  }
}

class CurrencyImage extends StatelessWidget {
  final Currency currency;
  final double spriteSize;

  const CurrencyImage({
    required this.currency,
    this.spriteSize = _defaultCurrencyImageSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      currency.sprite.asset,
      scale: scaleTo(spriteSize),
      filterQuality: FilterQuality.none,
    );
  }
}
