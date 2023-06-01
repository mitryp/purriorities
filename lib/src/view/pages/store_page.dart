import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../data/enums/sprite.dart';
import '../../util/sprite_scaling.dart';
import '../theme.dart';
import '../widgets/currency/currency_balance.dart';
import '../widgets/currency/currency_info.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_indicator_button.dart';
import '../widgets/sprite_avatar.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutSelector(
      mobileLayoutBuilder: (context) => const _MobileStorePage(),
      desktopLayoutBuilder: (context) => const Placeholder(),
    );
  }
}

class _MobileStorePage extends StatelessWidget {
  const _MobileStorePage();

  @override
  Widget build(BuildContext context) {
    const commonCurrencyBalance = 100;
    const rareCurrencyBalance = 10;

    const goldLootboxPrice = 20;
    const commonLootboxPrice = 100;

    const commonCurrencyBought = 100;
    const priceOfCommonCurrency = 2;

    final List<({Currency currency, Sprite sprite, int price, Color? bgColor})>
        lootboxPurchaseColumns = [
      (
        currency: Currency.rare,
        sprite: Sprite.grayCat,
        price: goldLootboxPrice,
        bgColor: legendaryColor,
      ),
      (
        currency: Currency.common,
        sprite: Sprite.grayCat,
        price: commonLootboxPrice,
        bgColor: null,
      ),
    ];

    return MobileLayout(
      children: [
        const CurrencyBalance(
          commonCurrencyBalance: commonCurrencyBalance,
          rareCurrencyBalance: rareCurrencyBalance,
        ),
        Expanded(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        runSpacing: 10.0,
                        spacing: 30.0,
                        children: lootboxPurchaseColumns.map((lootboxInfo) {
                          return _LootboxPurchaseColumn(
                            currency: lootboxInfo.currency,
                            lootboxAsset: lootboxInfo.sprite.asset,
                            price: lootboxInfo.price,
                            radius: 50,
                            backgroundColor: lootboxInfo.bgColor,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20.0),
                      ProgressIndicatorButton.elevated(
                        onPressed: () async {}, //TODO
                        style: accentButtonStyle,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('+ $commonCurrencyBought '),
                            CurrencyImage(currency: Currency.common),
                            Text(' за $priceOfCommonCurrency '),
                            CurrencyImage(currency: Currency.rare),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _LootboxPurchaseColumn extends StatelessWidget {
  final String lootboxAsset;
  final double radius;
  final Currency currency;
  final int price;
  final Color? backgroundColor;

  const _LootboxPurchaseColumn({
    required this.lootboxAsset,
    required this.currency,
    required this.price,
    this.radius = 32,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        children: [
          SpriteAvatar.asset(
            lootboxAsset,
            minRadius: radius,
            scale: scaleToFitCircle(radius),
            backgroundColor: backgroundColor,
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {},
            child: CurrencyInfo(
              currency: currency,
              quantity: price,
            ),
          ),
        ],
      ),
    );
  }
}
