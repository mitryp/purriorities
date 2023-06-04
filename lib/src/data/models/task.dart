import 'package:json_annotation/json_annotation.dart';

import 'abs/serializable.dart';
import 'abs/prototype.dart';

part 'task.g.dart';

/// A class representing the task in a quest stage.
@JsonSerializable()
class Task with Prototype<Task> implements Serializable {
  /// An id of the stage, which this task is bound to.
  @JsonKey(includeToJson: false)
  final String stageId;

  /// An id of this task.
  final String id;

  /// A user-defined name of this task.
  final String name;

  /// A quantity of minutes which user set for this task.
  final int minutes;

  const Task({
    required this.stageId,
    required this.id,
    required this.name,
    required this.minutes,
  });

  const Task.empty({required this.stageId, required this.id})
      : name = '',
        minutes = 10;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          stageId == other.stageId &&
          id == other.id &&
          name == other.name &&
          minutes == other.minutes;

  @override
  int get hashCode => stageId.hashCode ^ id.hashCode ^ name.hashCode ^ minutes.hashCode;

  @override
  Task copyWith({String? name, int? minutes}) => Task(
        stageId: stageId,
        id: id,
        name: name ?? this.name,
        minutes: minutes ?? this.minutes,
      );
}
