import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

/// A class representing the task in a quest stage.
@JsonSerializable()
class Task {
  /// An id of the stage, which this task is bound to.
  final String stageId;

  /// An id of this task.
  final String id;

  /// A user-defined name of this task.
  final String name;

  const Task({
    required this.stageId,
    required this.id,
    required this.name,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
