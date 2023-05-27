import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

/// A class representing a user-defined skill with the information about its current [level].
@JsonSerializable()
class Skill {
  /// A name of this skill, defined by the user during the skill creation.
  final String name;

  /// A level of this skill.
  final int level;

  /// An experience points which the current user has gained on this [level].
  final int levelExp;

  /// An id of this skill.
  final int id;

  const Skill({
    required this.name,
    required this.level,
    required this.levelExp,
    required this.id,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
