import '../../config.dart';
import 'sprite.dart';

typedef ExchangeRate = Map<Currency, int>;

enum Currency {
  feed(Sprite.fishFood),
  catnip(Sprite.valerian, {Currency.feed: catnipToFeedExchangeRate});

  /// A static Sprite of this currency
  final Sprite sprite;

  /// A map of exchange rates to other currencies;
  ///
  /// The keys are Currencies, the values are quantities of this currency to be exchanged to one
  /// key one.
  ///
  /// E.g., {cur: 10} means that one item of this currency can be exchanged to 10 units of `cur`.
  final ExchangeRate rate;

  const Currency(this.sprite, [this.rate = const {}]);
}
