import 'package:json_annotation/json_annotation.dart';

import 'abs/serializable.dart';
import 'abs/prototype.dart';

part 'task.g.dart';

/// A class representing the task in a quest stage.
@JsonSerializable()
class Task extends Serializable with Prototype<Task> {
  /// An id of the stage, which this task is bound to.
  @JsonKey(includeToJson: false)
  final String stageId;

  /// An id of this task.
  final String id;

  /// A user-defined name of this task.
  final String name;

  /// A quantity of minutes which user set for this task.
  final int minutes;

  /// Whether this task is finished.
  @JsonKey(name: 'completed', includeToJson: false, required: false)
  final bool? isCompleted;

  const Task({
    required this.stageId,
    required this.id,
    required this.name,
    required this.minutes,
    this.isCompleted,
  });

  const Task.empty({required this.stageId, required this.id})
      : name = '',
        minutes = 10,
        isCompleted = false;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  bool get isFinished => isCompleted == true;

  bool get isRefused => isCompleted == false;

  bool get isActive => isCompleted == null;

  bool get isNotActive => isCompleted != null;

  @override
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  Set<String> get generatedIdentifiers => {'id'};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          stageId == other.stageId &&
          id == other.id &&
          name == other.name &&
          minutes == other.minutes &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      stageId.hashCode ^ id.hashCode ^ name.hashCode ^ minutes.hashCode ^ isCompleted.hashCode;

  @override
  Task copyWith({String? name, int? minutes}) => Task(
        stageId: stageId,
        id: id,
        name: name ?? this.name,
        minutes: minutes ?? this.minutes,
      );

  Task copyWithCompletedStatus({required bool? isCompleted, String? name, int? minutes}) => Task(
        stageId: stageId,
        id: id,
        name: name ?? this.name,
        minutes: minutes ?? this.minutes,
        isCompleted: isCompleted,
      );
}
