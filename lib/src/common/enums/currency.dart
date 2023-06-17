import 'sprite.dart';

typedef ExchangeRate = Map<Currency, int>;

enum Currency {
  feed(Sprite.fishFood),
  catnip(Sprite.valerian);

  /// A static Sprite of this currency
  final Sprite sprite;

  const Currency(this.sprite);
}
