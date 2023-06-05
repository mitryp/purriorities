import 'package:json_annotation/json_annotation.dart';

import '../enums/cat_rarity.dart';

part 'cat.g.dart';

/// A class representing a collectible cat.
@JsonSerializable(createToJson: false)
class Cat {
  /// An internal identifier of this cat.
  final String nameId;

  /// A human-readable name of this cat.
  final String name;

  /// A human-readable description of this cat.
  final String description;

  /// A rarity level of this cat.
  final CatRarity rarity;

  const Cat({
    required this.nameId,
    required this.name,
    required this.description,
    required this.rarity,
  });

  factory Cat.fromJson(Map<String, dynamic> json) => _$CatFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cat &&
          runtimeType == other.runtimeType &&
          nameId == other.nameId &&
          name == other.name &&
          description == other.description &&
          rarity == other.rarity;

  @override
  int get hashCode => nameId.hashCode ^ name.hashCode ^ description.hashCode ^ rarity.hashCode;
}
