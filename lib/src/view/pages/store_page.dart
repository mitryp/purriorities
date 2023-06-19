import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/enums/currency.dart';
import '../../common/enums/loot_box.dart';
import '../../constants.dart';
import '../../data/models/cat_ownership.dart';
import '../../data/models/store_prices.dart';
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
import '../widgets/punishment_consumer.dart';
import '../widgets/sprite_avatar.dart';
import 'collection/collection_cat.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ProxyProvider<Dio, StoreService>(
        update: (context, client, prev) => StoreService(context: context, client: client),
        child: PunishmentConsumer(
          child: LayoutSelector(
            mobileLayoutBuilder: (context) => const _MobileStorePage(),
          ),
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

  late final StorePrices _storePrices;
  bool _arePricesLoaded = false;

  @override
  void initState() {
    super.initState();

    context.synchronizer().syncUser();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    if (_arePricesLoaded) return;

    final pricesRes = await _storeService.fetchPrices();

    if (!mounted) return;

    if (!pricesRes.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Під час отримання цін магазину сталася помилка',
          subtitleText: 'Повідомлення від сервера: ${pricesRes.errorMessage}',
        ),
      );

      return;
    }

    _storePrices = pricesRes.result();
    setState(() => _arePricesLoaded = true);
  }

  Future<void> _processLootBoxPurchase(LootBoxType lootBoxType) async {
    log('Intending to purchase a box of type ${lootBoxType.name}', name: 'StorePage');

    final res = await _storeService.openCase(lootBoxType, _storePrices);

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
          titleText: 'Сталась помилка при купівлі переноски',
          subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
        ),
      );

      return;
    }

    _displayLootBoxOpening(lootBoxType, res.result());
  }

  Future<void> _processCurrencyPurchase() async {
    log('Intending to purchase some currency', name: 'StorePage');

    final res = await _storeService.purchaseCommonCurrency(_storePrices);

    if (!mounted) return;

    if (!res.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Сталась помилка при купівлі валюти',
          subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
        ),
      );

      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Успішно!',
        backgroundColor: Colors.green[300],
      ),
    );
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
    if (!_arePricesLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final rate = _storePrices.catnipToFeedRate;
    const catnipAmountToBuyFeed = 1;

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
                            prices: _storePrices,
                          );
                        }).toList(growable: false),
                      ),
                      const SizedBox(height: 24),
                      Selector<UserData, int>(
                        selector: (context, userData) => userData.user!.catnip,
                        builder: (context, catnipAmount, _) => ProgressIndicatorButton.elevated(
                          onPressed: catnipAmount >= catnipAmountToBuyFeed
                              ? _processCurrencyPurchase
                              : null,
                          style: accentButtonStyle,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('+ $rate '),
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
  final StorePrices prices;

  const _LootBoxPurchaseColumn({
    required this.type,
    required this.onPurchaseIntent,
    required this.prices,
    this.radius = 32,
  });

  @override
  Widget build(BuildContext context) {
    final price = prices.priceForLootBoxType(type);

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
              buttonBuilder: ({required child, required onPressed, style}) => OutlinedButton(
                onPressed: onPressed,
                style: style,
                child: child,
              ),
              onPressed: user.amountOfCurrency(type.currency) >= price
                  ? () => onPurchaseIntent(type)
                  : null,
              child: CurrencyInfo(
                currency: type.currency,
                quantity: price,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
