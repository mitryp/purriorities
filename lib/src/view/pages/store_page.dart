import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/enums/currency.dart';
import '../../common/enums/loot_box.dart';
import '../../constants.dart';
import '../../data/models/cat_ownership.dart';
import '../../data/models/user.dart';
import '../../data/user_data.dart';
import '../../services/cats_info_cache.dart';
import '../../services/store_service.dart';
import '../../typedefs.dart';
import '../../util/extensions/context_synchronizer.dart';
import '../../util/sprite_scaling.dart';
import '../dialogs/loot_box_dialog.dart';
import '../widgets/authorizer.dart';
import '../widgets/currency/currency_balance.dart';
import '../widgets/currency/currency_info.dart';
import '../widgets/error_snack_bar.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_indicator_button.dart';
import '../widgets/sprite_avatar.dart';
import 'collection/collection_cat.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ProxyProvider<Dio, StoreService>(
        update: (context, client, prev) => prev ?? StoreService(context: context, client: client),
        child: LayoutSelector(
          mobileLayoutBuilder: (context) => const _MobileStorePage(),
          desktopLayoutBuilder: (context) => const Placeholder(),
        ),
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
  late final StoreService _storeService = context.read<StoreService>();

  @override
  void initState() {
    super.initState();

    context.synchronizer().syncUser();
  }

  Future<void> _processLootBoxPurchase(LootBoxType lootBoxType) async {
    log('Intending to purchase a box of type ${lootBoxType.name}', name: 'StorePage');

    final res = await _storeService.openCase(lootBoxType);

    if (!mounted) return;

    if (res == null) {
      showErrorSnackBar(
        context: context,
        content: const ErrorSnackBarContent(
          titleText: 'У вас недостатньо валюти, щоб виконати цю операцію',
        ),
      );

      return;
    }

    if (!res.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Сталась помилка при купівлі',
          subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
        ),
      );

      return;
    }

    _displayLootBoxOpening(lootBoxType, res.result());
  }

  Future<void> _processCurrencyPurchase() async {
    log('Intending to purchase some currency', name: 'StorePage');
  }

  void _displayLootBoxOpening(LootBoxType lootBoxType, CatOwnership ownership) {
    final catInfo = catInfoById(context, ownership.catNameId);
    final collectionCat = CollectionCat(catInfo, ownership);

    log('Received a cat ${catInfo.name} of level ${ownership.level}');

    showDialog(
      context: context,
      builder: (context) => LootBoxDialogContent(lootBoxType: lootBoxType, reward: collectionCat),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rate = Currency.catnip.rate.entries.first;

    return MobileLayout(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: LayoutBuilder(
            builder: (context, constraints) => ConstrainedBox(
              constraints: constraints.widthConstraints() / 2.5,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Selector<UserData, User>(
                    selector: (_, data) => data.user!,
                    builder: (context, user, _) => CurrencyBalance(
                      commonCurrencyBalance: user.feed,
                      rareCurrencyBalance: user.catnip,
                    ),
                  ),
                ),
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
                        runSpacing: 16,
                        spacing: 32,
                        children: LootBoxType.values.map((type) {
                          return _LootBoxPurchaseColumn(
                            type: type,
                            radius: 56,
                            onPurchaseIntent: _processLootBoxPurchase,
                          );
                        }).toList(growable: false),
                      ),
                      const SizedBox(height: 24),
                      Selector<UserData, int>(
                        selector: (context, userData) => userData.user!.catnip,
                        builder: (context, catnipAmount, _) => ProgressIndicatorButton.elevated(
                          onPressed: catnipAmount >= rate.value ? _processCurrencyPurchase : null,
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
  final LootBoxType type;
  final double radius;
  final FutureCallback<void, LootBoxType> onPurchaseIntent;

  const _LootBoxPurchaseColumn({
    required this.type,
    required this.onPurchaseIntent,
    this.radius = 32,
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
          const SizedBox(height: 10),
          Selector<UserData, User>(
            selector: (context, userData) => userData.user!,
            builder: (context, user, _) => ProgressIndicatorButton(
              buttonBuilder: OutlinedButton.new,
              onPressed: user.amountOfCurrency(type.currency) >= type.price
                  ? () => onPurchaseIntent(type)
                  : null,
              child: CurrencyInfo(
                currency: type.currency,
                quantity: type.price,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
