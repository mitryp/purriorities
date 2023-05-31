import 'package:json_annotation/json_annotation.dart';

import 'quest.dart';
import 'task.dart';

part 'quest_stage.g.dart';

/// A class representing a single stage of a [Quest].
@JsonSerializable()
class QuestStage {
  /// An id of this quest stage.
  final String id;

  /// A user-defined name of this quest stage.
  /// Can be empty - might want to replace it with a placeholder.
  final String name;

  /// A list of task on this stage.
  final List<Task> tasks;

  const QuestStage({
    required this.id,
    required this.name,
    required this.tasks,
  });

  factory QuestStage.fromJson(Map<String, dynamic> json) => _$QuestStageFromJson(json);

  const QuestStage.empty([int ordinal = 1])
      : id = '',
        name = 'Етап $ordinal',
        tasks = const [];

  Map<String, dynamic> toJson() => _$QuestStageToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestStage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          tasks == other.tasks;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ tasks.hashCode;
}
