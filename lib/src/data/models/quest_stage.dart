import 'package:json_annotation/json_annotation.dart';

import 'abs/serializable.dart';
import 'abs/prototype.dart';
import 'quest.dart';
import 'task.dart';

part 'quest_stage.g.dart';

/// A class representing a single stage of a [Quest].
@JsonSerializable()
class QuestStage extends Serializable with Prototype<QuestStage> {
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

  const QuestStage.empty([int ordinal = 1, int? displayOrdinal])
      : id = 'new-$ordinal',
        name = 'Етап ${displayOrdinal ?? ordinal}',
        tasks = const [];

  @override
  Map<String, dynamic> toJson() => _$QuestStageToJson(this);

  @override
  Set<String> get excludeCreateKeys => {'id'};

  @override
  Map<String, dynamic> toCreateJson() =>
      super.toCreateJson()..['tasks'] = tasks.map((e) => e.toCreateJson()).toList(growable: false);

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

  @override
  QuestStage copyWith({String? name, List<Task>? tasks}) => QuestStage(
        id: id,
        name: name ?? this.name,
        tasks: tasks ?? this.tasks,
      );
}
