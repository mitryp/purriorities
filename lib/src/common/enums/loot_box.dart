import '../../data/enums/cat_rarity.dart';
import 'currency.dart';
import 'sprite.dart';

enum LootBoxType {
  common(
    Currency.feed,
    catRarity: CatRarity.rare,
    sprite: Sprite.catCarrier,
  ),
  legendary(
    Currency.catnip,
    catRarity: CatRarity.legendary,
    sprite: Sprite.catCarrier,
  );

  final CatRarity catRarity;
  final Currency currency;
  final Sprite sprite;
  final String? _requestPath;

  const LootBoxType(
    this.currency, {
    required this.sprite,
    required this.catRarity,
    String? requestPath,
  }) : _requestPath = requestPath;

  /// The path variable to make the request to open this loot box type.
  String get requestPath => _requestPath ?? name;
}
