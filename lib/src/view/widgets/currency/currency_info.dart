import 'package:flutter/material.dart';

import '../../../common/enums/sprite.dart';
import '../../../util/sprite_scaling.dart';

enum Currency {
  common(Sprite.fishFood),
  rare(Sprite.valerian);

  final Sprite sprite;

  const Currency(this.sprite);
}

const _defaultCurrencyImageSize = 25.0;

class CurrencyInfo extends StatelessWidget {
  final int quantity;
  final Currency currency;
  final double spriteSize;

  const CurrencyInfo({
    required this.quantity,
    required this.currency,
    this.spriteSize = _defaultCurrencyImageSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CurrencyImage(currency: currency, spriteSize: spriteSize),
        const SizedBox(width: 4.0),
        Text('$quantity'),
      ],
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
