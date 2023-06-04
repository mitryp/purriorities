import 'package:json_annotation/json_annotation.dart';

import 'abs/serializable.dart';

part 'cat_ownership.g.dart';

/// A class representing the cat ownership of the current user.
@JsonSerializable(createToJson: false)
class CatOwnership {
  /// A level of the cat with the [catNameId] name-id owned by the current user.
  final int level;

  /// A name-id of this cat.
  /// It is a string of the following look: `strawberry_cat` etc.
  final String catNameId;

  /// Whether an owned cat with this [catNameId] is away.
  final bool isAway;

  /// An percent xp boost.
  final double xpBoost;

  const CatOwnership({
    required this.level,
    required this.catNameId,
    required this.isAway,
    required this.xpBoost,
  });

  factory CatOwnership.fromJson(Map<String, dynamic> json) => _$CatOwnershipFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatOwnership &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          catNameId == other.catNameId &&
          xpBoost == other.xpBoost;

  @override
  int get hashCode => level.hashCode ^ catNameId.hashCode ^ xpBoost.hashCode;
}
