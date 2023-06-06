import '../../data/enums/cat_rarity.dart';
import 'currency.dart';
import 'sprite.dart';

enum LootBoxType {
  common(100, Currency.feed, catRarity: CatRarity.rare, sprite: Sprite.grayCat),
  legendary(20, Currency.catnip, catRarity: CatRarity.legendary, sprite: Sprite.grayCat);

  final CatRarity catRarity;
  final int price;
  final Currency currency;
  final Sprite sprite;

  const LootBoxType(this.price, this.currency, {required this.sprite, required this.catRarity});
}
