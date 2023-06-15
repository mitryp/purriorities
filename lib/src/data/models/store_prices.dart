import 'package:json_annotation/json_annotation.dart';

import '../../common/enums/loot_box.dart';
import '../../typedefs.dart';

part 'store_prices.g.dart';

/// A class representing a dump of the in-game prices.
@JsonSerializable(createToJson: false)
class StorePrices {
  /// A price of a [LootBoxType.common] box (in feed).
  final int commonLootBoxPrice;

  /// A price of a [LootBoxType.legendary] box (in catnip).
  final int legendaryLootBoxPrice;

  /// An amount of feed can be bought for 1 unit of catnip.
  final int catnipToFeedRate;

  const StorePrices({
    required this.commonLootBoxPrice,
    required this.legendaryLootBoxPrice,
    required this.catnipToFeedRate,
  });

  factory StorePrices.fromJson(JsonMap json) => _$StorePricesFromJson(json);
}
