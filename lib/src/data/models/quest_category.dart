import 'package:json_annotation/json_annotation.dart';

import 'quest.dart';

part 'quest_category.g.dart';

/// A class representing a user-defined category of [Quest]s.
@JsonSerializable()
class QuestCategory {
  /// A user-defined name of this category.
  final String name;

  /// An id of this category.
  final int id;

  const QuestCategory({
    required this.name,
    required this.id,
  });

  factory QuestCategory.fromJson(Map<String, dynamic> json) => _$QuestCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$QuestCategoryToJson(this);
}
