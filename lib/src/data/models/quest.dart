import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

import '../enums/quest_priority.dart';
import 'abs/serializable.dart';
import 'abs/prototype.dart';
import 'quest_category.dart';
import 'quest_stage.dart';
import 'skill.dart';

part 'quest.g.dart';

/// A class representing a quest
@JsonSerializable()
class Quest extends Serializable with Prototype<Quest> {
  /// An id of this quest.
  final String id;

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

  /// Days between the occurrences of this quest.
  ///
  /// If null, then the quest does not repeat.
  /// Must be > 0.
  final int? interval;

  /// A [QuestCategory] of this quest.
  /// Is serialized as an int id
  @JsonKey(toJson: _serializeQuestCategory)
  final QuestCategory category;

  /// A list of [Skill]s of connected to this quest;
  @JsonKey(toJson: _serializeQuestSkills)
  final List<Skill> skills;

  /// A list of [QuestStage]s of this quest.
  final List<QuestStage> stages;

  const Quest({
    required this.id,
    required this.name,
    required this.priority,
    this.deadline,
    this.limit,
    this.interval,
    required this.category,
    required this.skills,
    required this.stages,
  });

  const Quest.empty()
      : id = '',
        name = '',
        priority = QuestPriority.regular,
        deadline = null,
        limit = null,
        interval = null,
        category = const QuestCategory.empty(),
        skills = const [],
        stages = const [QuestStage.empty()];

  factory Quest.fromJson(Map<String, dynamic> json) =>
      _$QuestFromJson(json)..stages.sort((a, b) => a.index - b.index);

  @override
  Map<String, dynamic> toJson() => _$QuestToJson(this);

  @override
  Set<String> get generatedIdentifiers => {'id'};

  @override
  Map<String, dynamic> toCreateJson() => super.toCreateJson()
    ..['stages'] = stages.map((e) => e.toCreateJson()).toList(growable: false);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          priority == other.priority &&
          deadline == other.deadline &&
          limit == other.limit &&
          interval == other.interval &&
          category == other.category &&
          skills == other.skills &&
          stages == other.stages;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      priority.hashCode ^
      deadline.hashCode ^
      limit.hashCode ^
      interval.hashCode ^
      category.hashCode ^
      skills.hashCode ^
      stages.hashCode;

  /// Preserves the schedule information. Use the [copyWithSchedule] method to change it.
  @override
  Quest copyWith({
    String? name,
    QuestPriority? priority,
    QuestCategory? category,
    List<Skill>? questSkills,
    List<QuestStage>? stages,
  }) =>
      Quest(
        id: id,
        name: name ?? this.name,
        priority: priority ?? this.priority,
        category: category ?? this.category,
        stages: stages ?? this.stages,
        skills: questSkills ?? this.skills,
        deadline: deadline,
        limit: limit,
        interval: interval,
      );

  Quest copyWithSchedule({
    required DateTime? deadline,
    required DateTime? limit,
    required int? interval,
    String? name,
    QuestPriority? priority,
    QuestCategory? category,
    List<Skill>? questSkills,
    List<QuestStage>? stages,
  }) =>
      Quest(
        id: id,
        name: name ?? this.name,
        priority: priority ?? this.priority,
        category: category ?? this.category,
        skills: questSkills ?? this.skills,
        stages: stages ?? this.stages,
        deadline: deadline,
        limit: limit,
        interval: interval,
      );
}

String _serializeQuestCategory(QuestCategory category) => category.id;

List<String> _serializeQuestSkills(List<Skill> skills) =>
    skills.map((skill) => skill.id).toList(growable: false);
