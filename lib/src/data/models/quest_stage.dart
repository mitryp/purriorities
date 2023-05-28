import 'package:json_annotation/json_annotation.dart';

import 'quest.dart';

part 'quest_stage.g.dart';

/// A class representing a single stage of a [Quest].
@JsonSerializable()
class QuestStage {
  /// An id of this quest stage.
  final String id;

  /// A user-defined name of this quest stage.
  /// Can be empty - might want to replace it with a placeholder.
  final String name;

  const QuestStage({
    required this.id,
    required this.name,
  });

  factory QuestStage.fromJson(Map<String, dynamic> json) => _$QuestStageFromJson(json);

  Map<String, dynamic> toJson() => _$QuestStageToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestStage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
