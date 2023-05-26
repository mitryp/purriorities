import 'package:json_annotation/json_annotation.dart';

import '../enums/quest_priority.dart';
import 'quest_category.dart';
import 'quest_stage.dart';

part 'quest.g.dart';

/// A class representing a quest
@JsonSerializable()
class Quest {
  /// An id of this quest.
  final int id;

  /// A name of this quest.
  final String name;

  /// A [QuestPriority] of this quest.
  final QuestPriority priority;

  /// A UTC datetime of the deadline of this quest.
  ///
  /// If null, then this quest does not have any time limit.
  ///
  /// If null, then the [interval] must be null either.
  final DateTime? deadline;

  /// A UTC datetime of the last possible planned deadline.
  ///
  /// The time should be exactly equal to the time of the [deadline].
  ///
  /// If null, then this quest can be re-planned indefinitely many times in the future.
  /// If not null, then the [interval] must not be null either.
  /// Must be >= the [deadline].
  final DateTime? limit;

  /// A [QuestCategory] of this quest.
  final QuestCategory category;

  /// A list of [QuestStage]s of this quest.
  final List<QuestStage> stages;

  const Quest({
    required this.id,
    required this.name,
    required this.priority,
    this.deadline,
    this.limit,
    required this.category,
    required this.stages,
  });

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

  Map<String, dynamic> toJson() => _$QuestToJson(this);
}
