import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/enums/currency.dart';
import '../common/enums/loot_box.dart';
import '../data/models/cat_ownership.dart';
import '../data/models/store_prices.dart';
import '../data/models/user.dart';
import '../data/user_data.dart';
import '../typedefs.dart';
import 'http/util/fetch_result.dart';

/// A class providing the store functionality of the app.
/// It has methods to open the loot boxes, buy currency and purchase the runaway cats back.
///
/// The class will check if the current user has enough currency to perform the requested operations
/// and remove the respective amount of the respective currency after a successful store operation.
///
/// This class depends on the [UserData], so make sure that the given [context] has a provider of
/// one above it in the widget tree.
class StoreService {
  final BuildContext context;
  final Dio client;
  final String basePath;

  const StoreService({
    required this.context,
    required this.client,
    this.basePath = 'api/store',
  });

  UserData _userData() => context.read<UserData>();

  /// Makes a request to get the [StorePrices] from the server.
  Future<FetchResult<StorePrices>> fetchPrices() => FetchResult.transformResponse(
        client.get<JsonMap>('$basePath/pricing'),
        StorePrices.fromJson,
      );

  /// Makes a request to open the loot box of the given [lootBoxType].
  ///
  /// If the current user is not logged in or does not have the needed amount of the required
  /// currency, returns null.
  /// Otherwise, the respective amount of the respective currency will be removed from the user
  /// balance, and the [CatOwnership] of the received cat will be returned.
  Future<FetchResult<CatOwnership>?> openCase(LootBoxType lootBoxType, StorePrices prices) async {
    final userData = _userData();
    final price = prices.priceForLootBoxType(lootBoxType);
    final currency = lootBoxType.currency;

    if (!userData.isLoggedIn || !_validateUserBalanceFor(price, currency, userData.user)) {
      return null;
    }

    final res = await FetchResult.transformResponse(
      client.post<JsonMap>('$basePath/case/${lootBoxType.requestPath}'),
      CatOwnership.fromJson,
    );

    if (!res.isSuccessful) {
      return res;
    }

    _updateUserDataWithCat(lootBoxType, res.result(), prices, userData);

    return res;
  }

  /// Makes a request to buy the common currency for 1 unit of the special one.
  ///
  /// If the current user is not logged in or does not have the required amount of the special
  /// currency, return FetchResult.success(false).
  /// Otherwise, returns FetchResult.success(true).
  Future<FetchResult> purchaseCommonCurrency(StorePrices prices) async {
    final userData = _userData();
    const price = 1;

    if (!userData.isLoggedIn || !_validateUserBalanceFor(price, Currency.catnip)) {
      return const FetchResult.failure();
    }

    final res = await FetchResult.fromResponse(client.post('$basePath/buy-feed'), true);

    if (res.isSuccessful) {
      final user = userData.user!;

      _setUserBalance({
        Currency.catnip: user.amountOfCurrency(Currency.catnip) - price,
        Currency.feed: user.amountOfCurrency(Currency.feed) + prices.catnipToFeedRate,
      });
    }

    return res;
  }

  Future<FetchResult> purchaseCatBack(CatOwnership runawayCat) async {
    final userData = _userData();
    final price = runawayCat.price;

    if (!userData.isLoggedIn || price == null || !_validateUserBalanceFor(price, Currency.feed)) {
      return const FetchResult.failure();
    }

    final res = await FetchResult.fromResponse(
      client.post('$basePath/return-cat/${runawayCat.catNameId}'),
      true,
    );

    if (res.isSuccessful) {
      final user = userData.user!;
      _setUserBalance({Currency.feed: user.amountOfCurrency(Currency.feed) - price}, userData);
      _addOrUpdateCatOwnership(runawayCat.copyWithPrice(price: null), userData);
    }

    return res;
  }

  /// Returns true if the current user has at least the [amount] of the [currency] on their balance.
  bool _validateUserBalanceFor(int amount, Currency currency, [User? user]) {
    user ??= _userData().user!;

    return user.amountOfCurrency(currency) >= amount;
  }

  /// Charges the user by the [lootBoxType] price in its currency and adds the [cat] to its
  /// collection.
  void _updateUserDataWithCat(
    LootBoxType lootBoxType,
    CatOwnership cat,
    StorePrices prices, [
    UserData? userData,
  ]) {
    userData ??= _userData();
    final user = userData.user!;

    final currencyAmount = user.amountOfCurrency(lootBoxType.currency);
    final price = prices.priceForLootBoxType(lootBoxType);

    userData.user = user
        .setCurrencyAmount(currencyAmount - price, lootBoxType.currency)
        .updateCatOwnership(cat);
  }

  void _addOrUpdateCatOwnership(CatOwnership ownership, [UserData? userData]) {
    userData ??= _userData();

    userData.user = userData.user?.updateCatOwnership(ownership);
  }

  void _setUserBalance(Map<Currency, int> balances, [UserData? userData]) {
    assert(balances.entries.every((e) => e.value >= 0));

    userData ??= _userData();
    var user = userData.user;

    for (final MapEntry(key: currency, value: amount) in balances.entries) {
      user = user?.setCurrencyAmount(amount, currency);
    }

    userData.user = user;
  }
}
