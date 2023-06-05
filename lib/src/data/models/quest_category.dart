import 'package:json_annotation/json_annotation.dart';

import 'abs/serializable.dart';
import 'abs/prototype.dart';
import 'quest.dart';

part 'quest_category.g.dart';

/// A class representing a user-defined category of [Quest]s.
@JsonSerializable()
class QuestCategory extends Serializable with Prototype<QuestCategory> {
  /// A user-defined name of this category.
  final String name;

  /// An id of this category.
  final String id;

  const QuestCategory({
    required this.name,
    required this.id,
  });

  const QuestCategory.empty()
      : id = '',
        name = '';

  factory QuestCategory.fromJson(Map<String, dynamic> json) => _$QuestCategoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QuestCategoryToJson(this);

  @override
  Set<String> get generatedIdentifiers => {'id'};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestCategory &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  @override
  QuestCategory copyWith({String? name}) => QuestCategory(
        name: name ?? this.name,
        id: id,
      );
}
