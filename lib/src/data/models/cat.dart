import 'package:json_annotation/json_annotation.dart';

import '../enums/cat_rarity.dart';

/// A class representing a collectible cat.
@JsonSerializable()
class Cat {
  /// A human-readable name of this cat.
  final String name;

  /// A human-readable description of this cat.
  final String description;

  /// A rarity level of this cat.
  final CatRarity rarity;

  const Cat({
    required this.name,
    required this.description,
    required this.rarity,
  });
}
