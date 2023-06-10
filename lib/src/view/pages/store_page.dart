import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/enums/currency.dart';
import '../../common/enums/loot_box.dart';
import '../../constants.dart';
import '../../data/models/user.dart';
import '../../data/user_data.dart';
import '../../typedefs.dart';
import '../../util/extensions/context_synchronizer.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/authorizer.dart';
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
    return Authorizer(
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => const _MobileStorePage(),
        desktopLayoutBuilder: (context) => const Placeholder(),
      ),
    );
  }
}

class _MobileStorePage extends StatefulWidget {
  const _MobileStorePage();

  @override
  State<_MobileStorePage> createState() => _MobileStorePageState();
}

class _MobileStorePageState extends State<_MobileStorePage> {
  @override
  void initState() {
    super.initState();

    context.synchronizer().syncUser();
  }

  Future<void> _processLootBoxPurchase(LootBoxType type) async {
    log('Intending to purchase a box of type ${type.name}', name: 'StorePage');
  }

  Future<void> _processCurrencyPurchase() async {
    log('Intending to purchase some currency', name: 'StorePage');
  }

  @override
  Widget build(BuildContext context) {
    final rate = Currency.catnip.rate.entries.first;

    return MobileLayout(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => ConstrainedBox(
            constraints: constraints.widthConstraints() / 2.5,
            child: Selector<UserData, User>(
              selector: (_, data) => data.user!,
              builder: (context, user, _) => CurrencyBalance(
                commonCurrencyBalance: user.feed,
                rareCurrencyBalance: user.catnip,
              ),
            ),
          ),
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
                        children: LootBoxType.values.map((type) {
                          return _LootBoxPurchaseColumn(
                            type: type,
                            radius: 50,
                            onPurchaseIntent: _processLootBoxPurchase,
                          );
                        }).toList(growable: false),
                      ),
                      const SizedBox(height: 20.0),
                      ProgressIndicatorButton.elevated(
                        onPressed: _processCurrencyPurchase, //TODO
                        style: accentButtonStyle,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('+ ${rate.value} '),
                            const CurrencyImage(currency: Currency.feed),
                            const Text(' за 1 '),
                            const CurrencyImage(currency: Currency.catnip),
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

class _LootBoxPurchaseColumn extends StatelessWidget {
  // final String lootBoxAsset;
  // final Currency currency;
  // final Color? backgroundColor;
  // final int price;
  final LootBoxType type;
  final double radius;
  final FutureCallback<void, LootBoxType> onPurchaseIntent;

  const _LootBoxPurchaseColumn({
    required this.type,
    required this.onPurchaseIntent,
    this.radius = 32,
    // this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        children: [
          SpriteAvatar.asset(
            type.sprite.asset,
            minRadius: radius,
            scale: scaleToFitCircle(radius),
            backgroundColor: type.catRarity.color,
          ),
          const SizedBox(
            height: 10.0,
          ),
          ProgressIndicatorButton(
            buttonBuilder: OutlinedButton.new,
            onPressed: () => onPurchaseIntent(type),
            child: CurrencyInfo(
              currency: type.currency,
              quantity: type.price,
            ),
          ),
        ],
      ),
    );
  }
}
