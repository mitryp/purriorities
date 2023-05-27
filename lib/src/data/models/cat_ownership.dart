import 'package:json_annotation/json_annotation.dart';

part 'cat_ownership.g.dart';

/// A class representing the cat ownership of the current user.
@JsonSerializable()
class CatOwnership {
  /// A level of the cat with the [catNameId] name-id owned by the current user.
  final int level;

  /// A date when the cat with the [catNameId] name-id was acquired bu the current user.
  final DateTime acquireDate;

  /// A name-id of this cat.
  /// It is a string of the following look: `strawberry_cat` etc.
  final String catNameId;

  const CatOwnership({
    required this.level,
    required this.acquireDate,
    required this.catNameId,
  });

  factory CatOwnership.fromJson(Map<String, dynamic> json) => _$CatOwnershipFromJson(json);

  Map<String, dynamic> toJson() => _$CatOwnershipToJson(this);
}
